--[[
	이 모듈은 Discord Webhook용 메시지 페이로드를 구성하기 위한 유틸리티입니다.
	주요 기능:
	 - username, avatar_url, content, tts 설정
	 - embed 내부: title, description, url, color, timestamp, footer, image, thumbnail, author, fields
	 - 필드 추가(addField) 및 컬러/타임스탬프 자동 처리
	 - build() 호출로 최종 Webhook payload 생성
	 - nil/빈 값 자동 제거(sanitize)
	
	사용 예시:
		local EmbedBuilder = require(path.to.EmbedBuilder)
		local embed = EmbedBuilder.new()
			:setUsername("MyBot")
			:setAvatar("https://example.com/avatar.png")
			:setContent("Hello!")
			:setTitle("Embed Title")
			:setDescription("Embed description here")
			:setColor("#FF0000")
			:setTimestamp()
			:addField("Field1", "Value1", true)
			:build()
		-- embed는 Discord Webhook에 바로 POST 가능한 Lua 테이블 형태

	주의:
	 - color는 0x000000 ~ 0xFFFFFF 범위만 허용하며, 문자열 "#RRGGBB" 또는 10진수 입력 가능
	 - timestamp 미지정 시 현재 시간(DateTime.now) 사용
	 - fields는 최대 25개 제한, Discord API 제한 준수 필요
]]

local DateTime = DateTime
local tostring = tostring
local type = type
local next = next

local EmbedBuilder = {}
EmbedBuilder.__index = EmbedBuilder

local function clamp(n, a, b)
	if n < a then return a end
	if n > b then return b end
	return n
end

function EmbedBuilder.new()
	return setmetatable({
		username = nil,
		avatar_url = nil,
		content = nil,
		tts = false,
		embeds = {{
			title = nil,
			description = nil,
			url = nil,
			color = nil,
			timestamp = nil,
			footer = nil,
			image = nil,
			thumbnail = nil,
			author = nil,
			fields = {},
		}}
	}, EmbedBuilder)
end

local function top(self) return self.embeds[1] end

function EmbedBuilder:setUsername(name) self.username = name and tostring(name) or nil; return self end
function EmbedBuilder:setAvatar(url) self.avatar_url = url and tostring(url) or nil; return self end
function EmbedBuilder:setContent(text) self.content = text and tostring(text) or nil; return self end
function EmbedBuilder:setTTS(val) self.tts = not not val; return self end

function EmbedBuilder:setTitle(title) top(self).title = title and tostring(title) or nil; return self end
function EmbedBuilder:setURL(url) top(self).url = url and tostring(url) or nil; return self end
function EmbedBuilder:setDescription(desc) top(self).description = desc and tostring(desc) or nil; return self end

function EmbedBuilder:setColor(hexOrInt)
	local n = tonumber(hexOrInt)
	if not n and type(hexOrInt) == "string" then
		n = tonumber((hexOrInt:gsub("^#","")), 16)
	end
	top(self).color = clamp(n or 0x2f3136, 0, 0xFFFFFF)
	return self
end

function EmbedBuilder:setTimestamp(iso8601)
	if iso8601 then
		top(self).timestamp = tostring(iso8601)
	else
		top(self).timestamp = DateTime.now():ToIsoDate()
	end
	return self
end

function EmbedBuilder:setFooter(text, iconUrl)
	top(self).footer = { text = text and tostring(text) or "", icon_url = iconUrl and tostring(iconUrl) or nil }
	return self
end

function EmbedBuilder:setAuthor(name, url, iconUrl)
	top(self).author = { name = name and tostring(name) or "", url = url and tostring(url) or nil, icon_url = iconUrl and tostring(iconUrl) or nil }
	return self
end

function EmbedBuilder:setThumbnail(url) top(self).thumbnail = url and { url = tostring(url) } or nil; return self end
function EmbedBuilder:setImage(url) top(self).image = url and { url = tostring(url) } or nil; return self end

function EmbedBuilder:addField(name, value, inline)
	if not name or not value then return self end
	local f = { name = tostring(name), value = tostring(value), inline = not not inline }
	table.insert(top(self).fields, f)
	return self
end

local function sanitizeEmbed(e)
	local out = {}
	for k, v in pairs(e) do
		if v ~= nil then
			if type(v) == "table" then
				if next(v) ~= nil then out[k] = v end
			else
				out[k] = v
			end
		end
	end
	return out
end

function EmbedBuilder:build()
	local emb = sanitizeEmbed(self.embeds[1] or {})
	local payload = {
		username = self.username,
		avatar_url = self.avatar_url,
		content = self.content,
		tts = self.tts,
		embeds = { emb },
	}
	if not payload.content and not emb.title and not emb.description and (#emb.fields == 0) then
		payload.content = "(no content)"
	end
	return payload
end

return EmbedBuilder
