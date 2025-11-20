--[[
	주어진 초(totalSec)를 사람이 읽기 쉬운 시간 문자열로 변환합니다.
	- days > 0이면 "D일 HH:MM:SS" 형식 반환
	- days == 0이면 "HH:MM:SS" 형식 반환
	- 소수점 초는 반올림 처리
]]

return function (totalSec: number)
	totalSec = math.max(0, math.floor(totalSec + 0.5))
	local days = math.floor(totalSec / 86400)
	totalSec %= 86400
	local hours = math.floor(totalSec / 3600)
	totalSec %= 3600
	local mins = math.floor(totalSec / 60)
	local secs = totalSec % 60

	if days > 0 then
		return string.format("%d일 %02d:%02d:%02d", days, hours, mins, secs)
	else
		return string.format("%02d:%02d:%02d", hours, mins, secs)
	end
end
