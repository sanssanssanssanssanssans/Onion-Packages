--[[

	Roblox DataStore를 손쉽게 다루기 위한 간단한 래퍼 모듈입니다.
	주요 기능:
	 - BigInteger (커스텀) 타입의 직렬화/역직렬화 지원
	 - GetAsync / SetAsync 대신 Retry를 감싼 안전한 호출
	 - UpdateAsync 기반의 원자적 업데이트 (업데이터 콜백)
	 - 메모리상 프로파일 캐시와 수동/자동 저장(autoSave)
	 - 플레이어 라이프사이클 훅 (PlayerRemoving, BindToClose)
	 - 간단한 bindPlayer 편의 메서드

	사용 예:
		local DSP = require(path.to.DataStorePlus)
		local store = DSP.new("MyStore", "ScopeName")
		local profile = store:bindPlayer(player, { coins = Big.new("0") })
		-- profile은 decode된 테이블이며 Big 타입 유지

	보안/주의:
	 - DataStore 호출에는 실패/지연이 있을 수 있으니 retry 전략을 사용합니다.
	 - BindToClose에서 긴 작업을 수행하면 서버 종료 시 충분한 시간이 없을 수 있습니다.
	 - UpdateAsync는 충돌 가능성이 있으므로 업데이터는 빠르게 실행되어야 합니다.
	 - Roblox DataStore의 사용 제한(초당 호출 수 등)을 항상 유의하세요.
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local Big = require(script.Parent.Parent.Numbers.BigIntenger)

local DSP = {}
DSP.__index = DSP

local function isBig(x) return getmetatable(x) == getmetatable(Big.zero()) end

local function encodeValue(v)
	local t = typeof(v)
	if isBig(v) then
		return { __bigint = v:toString() }
	elseif t == "table" then
		local out = {}
		for k,val in pairs(v) do
			out[k] = encodeValue(val)
		end
		return out
	else
		return v
	end
end

local function decodeValue(v)
	if typeof(v) == "table" then
		if v.__bigint ~= nil then
			return Big.new(v.__bigint)
		end
		local out = {}
		for k,val in pairs(v) do
			out[k] = decodeValue(val)
		end
		return out
	else
		return v
	end
end

local function retry(fn)
	local tries, delaySec = 0, 0.4
	while true do
		tries += 1
		local ok, res = pcall(fn)
		if ok then return true, res end
		if tries >= 6 then
			warn("[DataStorePlus] failed after retries:", res)
			return false, res
		end
		task.wait(delaySec)
		delaySec = math.min(5, delaySec * 2)
	end
end

function DSP.new(name, scope)
	local ds = DataStoreService:GetDataStore(name, scope)
	return setmetatable({ _store = ds, _autosave = false, _profiles = {} }, DSP)
end

function DSP:loadProfile(userId, defaultValue)
	local ok, data = retry(function()
		return self._store:GetAsync(("u:%d"):format(userId))
	end)
	if not ok or data == nil then
		data = defaultValue and encodeValue(defaultValue) or {}
	end
	local decoded = decodeValue(data)
	self._profiles[userId] = decoded
	return decoded
end

function DSP:saveProfile(userId)
	local data = self._profiles[userId]
	if not data then return true end
	local encoded = encodeValue(data)
	local ok = retry(function()
		return self._store:SetAsync(("u:%d"):format(userId), encoded)
	end)
	return ok
end

function DSP:update(userId, updater)
	local ok, res = retry(function()
		return self._store:UpdateAsync(("u:%d"):format(userId), function(old)
			old = old or {}
			old = decodeValue(old)
			local newTbl = updater(old) or old
			return encodeValue(newTbl)
		end)
	end)
	if ok then
		self._profiles[userId] = decodeValue(res)
	end
	return ok, self._profiles[userId]
end

function DSP:autoSaveStart(intervalSec)
	if self._autosave then return end
	self._autosave = true
	task.spawn(function()
		while self._autosave do
			task.wait(intervalSec or 60)
			for uid,_ in pairs(self._profiles) do
				self:saveProfile(uid)
			end
		end
	end)
end

function DSP:autoSaveStop() self._autosave = false end

function DSP:hookLifecycle()
	Players.PlayerRemoving:Connect(function(plr)
		self:saveProfile(plr.UserId)
		self._profiles[plr.UserId] = nil
	end)
	game:BindToClose(function()
		for uid,_ in pairs(self._profiles) do
			self:saveProfile(uid)
		end
	end)
end

function DSP:bindPlayer(player, defaultValue)
	return self:loadProfile(player.UserId, defaultValue)
end

return DSP
