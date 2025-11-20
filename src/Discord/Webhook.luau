--[[
	이 모듈은 HttpService를 사용하여 Discord Webhook 또는 일반 HTTP POST 요청을 안전하게 전송하는 기능을 제공합니다.
	주요 기능:
	 - JSON payload 자동 인코딩
	 - 실패 시 재시도(retry) 지원
	 - 지수적 백오프(backoff) 적용
	 - Discord 429 Too Many Requests 처리 (Retry-After 헤더 지원)
	 - 단순한 사용법: Webhook.send(url, payload, opts)

	사용 예시:
		local Webhook = require(path.to.Webhook)
		local EmbedBuilder = require(path.to.EmbedBuilder)

		local payload = EmbedBuilder.new()
			:setUsername("MyBot")
			:setContent("Hello World")
			:build()

		local ok, err = Webhook.send("https://discord.com/api/webhooks/WEBHOOK_ID/TOKEN", payload)
		if not ok then
			warn("Failed to send webhook:", err)
		end

	옵션(opts) 예시:
		Webhook.send(url, payload, { retries = 5, backoff = 0.3 })
		- retries: 재시도 최대 횟수 (기본 3)
		- backoff: 지수적 백오프 기본값 (기본 0.5초)
]]

local HttpService = game:GetService("HttpService")
local task_wait = task.wait

local Webhook = {}
Webhook.__index = Webhook

local function sleep(sec)
	if sec and sec > 0 then task_wait(sec) end
end

local function headerGetCI(headers, key)
	if not headers then return nil end
	local lk = key:lower()
	for k, v in pairs(headers) do
		if k:lower() == lk then return v end
	end
	return nil
end

local function jsonEncode(v)
	return HttpService:JSONEncode(v)
end

function Webhook.send(url, payload, opts)
	opts = opts or {}
	local retries = (opts.retries ~= nil) and opts.retries or 3
	local baseBackoff = opts.backoff or 0.5

	local body
	local okEncode, enc = pcall(jsonEncode, payload)
	if okEncode then body = enc else return false, "json_encode_failed: "..tostring(enc) end

	for attempt = 0, retries do
		local ok, res = pcall(function()
			return HttpService:RequestAsync({
				Url = url,
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = body,
			})
		end)

		if ok and res and res.Success and res.StatusCode and res.StatusCode >= 200 and res.StatusCode < 300 then
			return true
		end

		local status = (ok and res and res.StatusCode) or 0
		local headers = (ok and res and res.Headers) or {}
		if status == 429 then
			local retryAfter = tonumber(headerGetCI(headers, "retry-after")) or tonumber(headerGetCI(headers, "Retry-After")) or 1
			if retryAfter > 1000 then retryAfter = retryAfter / 1000 end
			sleep(retryAfter + (math.random() * 0.1))
		else
			if attempt >= retries then
				local errBody = (ok and res and res.Body) or tostring(res)
				local sc = (ok and res and res.StatusCode) or nil
				return false, ("request_failed (status=%s) body=%s"):format(tostring(sc), tostring(errBody))
			end
			local backoff = baseBackoff * (2 ^ attempt) + (math.random() * 0.1)
			sleep(backoff)
		end
	end

	return false, "unknown_error"
end

return Webhook
