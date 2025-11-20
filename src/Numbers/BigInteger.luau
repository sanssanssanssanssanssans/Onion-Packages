--[[
고정 크기를 초과하는 정수 연산을 지원하기 위한 **임의 정밀도(Big Integer)** 구현입니다.  
Roblox Lua는 기본적으로 64bit 정수 범위 안에서만 정확한 정수 연산이 가능하지만,  
이 모듈은 **무제한 자리수의 정수**를 저장·연산할 수 있도록 설계되었습니다.

본 모듈은 다음과 같은 특징을 갖습니다:

---

- 내부적으로 숫자를 1,000,000 진수(10⁶ 단위) 블록으로 분해해 저장  
- 어떤 크기의 정수든 제한 없이 다룰 수 있음

### 지원 연산
- 덧셈 (`a + b`)
- 뺄셈 (`a - b`)
- 곱셈 (`a * b`)
- 음수/양수 처리
- 문자열 변환 및 복원
- number 변환(단, number 한계 이내일 때만 정확)

### 저장 구조
정수는 아래 형태로 저장됨:

{
    sign = -1 | 0 | 1,   -- 부호 (음수, 0, 양수)
    d = { chunk1, chunk2, ... }  -- 각 chunk는 0~999,999 (10^6 - 1)
}]]

local RADIX, RADIX_POW = 1000000, 6

local Big = {}
Big.__index = Big

local function new_raw(sign, d)
	return setmetatable({ sign = sign, d = d }, Big)
end

local function trim(d)
	while #d > 1 and d[#d] == 0 do table.remove(d) end
	if #d == 0 then d[1] = 0 end
	return d
end

local function cmpAbs(a, b)
	local ad, bd = a.d, b.d
	if #ad ~= #bd then return (#ad < #bd) and -1 or 1 end
	for i = #ad, 1, -1 do
		if ad[i] ~= bd[i] then return (ad[i] < bd[i]) and -1 or 1 end
	end
	return 0
end

local function addAbs(ad, bd)
	local n = math.max(#ad, #bd)
	local res, carry = table.create(n+1, 0), 0
	for i=1,n do
		local s = (ad[i] or 0) + (bd[i] or 0) + carry
		if s >= RADIX then res[i] = s - RADIX; carry = 1 else res[i] = s; carry = 0 end
	end
	if carry ~= 0 then res[n+1] = carry end
	return trim(res)
end

local function subAbs(ad, bd)
	local n = #ad
	local res, borrow = table.create(n, 0), 0
	for i=1,n do
		local ai = ad[i] or 0
		local bi = bd[i] or 0
		local s = ai - bi - borrow
		if s < 0 then s = s + RADIX; borrow = 1 else borrow = 0 end
		res[i] = s
	end
	return trim(res)
end

function Big.fromString(s)
	assert(type(s) == "string", "string required")
	s = s:gsub("^%s+", ""):gsub("%s+$", "")
	if s == "" or s:match("^0+$") then return new_raw(0, {0}) end
	local sign = 1
	if s:sub(1,1) == "-" then sign = -1; s = s:sub(2)
	elseif s:sub(1,1) == "+" then s = s:sub(2) end
	assert(s:match("^[0-9]+$"), "invalid decimal string")
	local d = {}
	for i = #s, 1, -RADIX_POW do
		local a = math.max(1, i - RADIX_POW + 1)
		local chunk = tonumber(s:sub(a, i))
		d[#d+1] = chunk
	end
	d = trim(d)
	return new_raw(1, d):withSign(sign)
end

function Big.zero() return new_raw(0, {0}) end
function Big.one() return new_raw(1, {1}) end

function Big.fromNumber(n)
	assert(type(n) == "number", "number required")
	if n == 0 then return Big.zero() end
	local sign = (n < 0) and -1 or 1
	n = math.abs(n)
	local d = {}
	while n > 0 do
		local q = math.floor(n / RADIX)
		local r = n - q * RADIX
		d[#d+1] = r
		n = q
	end
	return new_raw(1, trim(d)):withSign(sign)
end

function Big:clone()
	return new_raw(self.sign, table.clone(self.d))
end

function Big:isZero() return self.sign == 0 end
function Big:isNeg() return self.sign < 0 end

function Big:abs()
	return new_raw((self.sign == 0) and 0 or 1, table.clone(self.d))
end

function Big:withSign(sign)
	local z = self:clone()
	if z.d[1] == 0 and #z.d == 1 then z.sign = 0 else z.sign = sign end
	return z
end

function Big:cmp(other)
	if self.sign ~= other.sign then return (self.sign < other.sign) and -1 or 1 end
	if self.sign == 0 then return 0 end
	local c = cmpAbs(self, other)
	return (self.sign > 0) and c or -c
end

function Big:neg()
	if self.sign == 0 then return self end
	return self:withSign(-self.sign)
end

function Big:add(b)
	if self.sign == 0 then return b:clone() end
	if b.sign == 0 then return self:clone() end
	if self.sign == b.sign then
		return new_raw(self.sign, addAbs(self.d, b.d))
	else
		local c = cmpAbs(self, b)
		if c == 0 then return Big.zero() end
		if c > 0 then
			return new_raw(self.sign, subAbs(self.d, b.d))
		else
			return new_raw(b.sign, subAbs(b.d, self.d))
		end
	end
end

function Big:sub(b)
	return self:add(b:neg())
end

function Big:mul(b)
	if self.sign == 0 or b.sign == 0 then return Big.zero() end
	local ad, bd = self.d, b.d
	local n, m = #ad, #bd
	local res = table.create(n + m, 0)
	for i=1,n do
		local carry = 0
		local ai = ad[i]
		for j=1,m do
			local idx = i + j - 1
			local s = res[idx] + ai * bd[j] + carry
			carry = math.floor(s / RADIX)
			res[idx] = s - carry * RADIX
		end
		if carry > 0 then
			res[i + m] = res[i + m] + carry
		end
	end
	res = trim(res)
	local sign = (self.sign == b.sign) and 1 or -1
	return new_raw(sign, res)
end

function Big:toString()
	if self.sign == 0 then return "0" end
	local d = self.d
	local s = tostring(d[#d])
	for i = #d-1, 1, -1 do
		s ..= string.format("%0"..RADIX_POW.."d", d[i])
	end
	if self.sign < 0 then s = "-"..s end
	return s
end

function Big:toNumber()
	if self.sign == 0 then return 0 end
	local n = 0
	for i = #self.d, 1, -1 do
		n = n * RADIX + self.d[i]
	end
	return (self.sign < 0) and -n or n
end

function Big.new(x)
	if getmetatable(x) == Big then return x end
	local t = type(x)
	if t == "string" then return Big.fromString(x)
	elseif t == "number" then return Big.fromNumber(x)
	else error("BigInteger.new: string|number|BigInteger expected") end
end

return Big
