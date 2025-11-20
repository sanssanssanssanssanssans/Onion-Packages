--[[
	이 모듈은 특정 영역(Zone)에 플레이어가 들어갔는지 / 나갔는지 감지하기 위한 유틸리티입니다.
	"CommandZones"라는 폴더를 Workspace에서 찾아,
	그 안의 모든 BasePart를 "Zone"으로 간주하여 충돌 판정을 수행합니다.

	이 모듈의 주요 기능:
	1. IsInRestrictedZone(player)
	    → 플레이어가 지정된 Zone 안에 있는지 여부를 true/false로 반환

	2. StartMonitor(player, onEnter, onExit, pollSec)
	    → 플레이어를 지속적으로 감시하여 Zone 진입/이탈 이벤트를 실행함
	    → 반환값: 모니터링을 중지할 수 있는 함수

	사용 예시:
		local stop = Zones.StartMonitor(
			player,
			function() print(player.Name, "entered zone!") end,
			function() print(player.Name, "left zone!") end
		)
		-- 이후 중지하고 싶으면 stop() 호출
]]

local RunService = game:GetService("RunService")
local M = {}
local ZONES_FOLDER_NAME = "CommandZones"

local function pointInside(part, worldPos)
	if not part or not part:IsA("BasePart") then return false end
	local half = part.Size * 0.5
	local p = part.CFrame:PointToObjectSpace(worldPos)
	return math.abs(p.X) <= half.X and math.abs(p.Y) <= half.Y and math.abs(p.Z) <= half.Z
end

local function zones()
	return workspace:FindFirstChild(ZONES_FOLDER_NAME)
end

function M.IsInRestrictedZone(player)
	local char = player and player.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	local folder = zones()
	if not folder then return false end
	for _, inst in ipairs(folder:GetChildren()) do
		if inst:IsA("BasePart") and pointInside(inst, hrp.Position) then
			return true
		end
	end
	return false
end

function M.StartMonitor(player, onEnter, onExit, pollSec)
	pollSec = pollSec or 0.2
	local alive = true
	local prev = false
	task.spawn(function()
		while alive and player.Parent do
			local now = M.IsInRestrictedZone(player)
			if now ~= prev then
				if now and onEnter then onEnter() end
				if (not now) and onExit then onExit() end
				prev = now
			end
			task.wait(pollSec)
		end
	end)
	return function() alive = false end
end

return M
