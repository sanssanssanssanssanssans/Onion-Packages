--[[

https://github.com/sanssanssanssanssanssans/struct를 참고하세요.

]]

local Struct = {}

local function deepCopy(v)
	if typeof(v) ~= "table" then return v end
	local t = {}
	for k,val in pairs(v) do t[k] = deepCopy(val) end
	return t
end

local function shallowCopy(v)
	if typeof(v) ~= "table" then return v end
	local t = {}
	for k,val in pairs(v) do t[k] = val end
	return t
end

local function typeMatches(expect, value)
	if type(expect) == "function" then
		local ok, res = pcall(expect, value)
		return ok and res == true
	end
	if expect == "any" then return true end
	if expect == "number"  then return typeof(value) == "number" end
	if expect == "string"  then return typeof(value) == "string" end
	if expect == "boolean" then return typeof(value) == "boolean" end
	if expect == "table"   then return typeof(value) == "table" end
	if expect == "Vector3" then return typeof(value) == "Vector3" end
	if expect == "CFrame"  then return typeof(value) == "CFrame" end
	if expect == "Instance"then return typeof(value) == "Instance" end
	if typeof(expect) == "table" then
		for _, e in ipairs(expect) do
			if typeMatches(e, value) then return true end
		end
		return false
	end
	return false
end

local function buildValidator(name, schema)
	local ordered = {}
	for k,_ in pairs(schema) do table.insert(ordered, k) end
	table.sort(ordered)

	local function validate(tbl)
		for _, key in ipairs(ordered) do
			local rule = schema[key]
			local val  = tbl[key]
			if val == nil then
				if rule.optional then
					-- ok
				else
					error(("[%s] Missing required field '%s'"):format(name, key), 3)
				end
			else
				if rule.type and not typeMatches(rule.type, val) then
					error(("[%s] Field '%s' type mismatch"):format(name, key), 3)
				end
				if rule.validate then
					local ok, res = pcall(rule.validate, val, tbl)
					if not ok or res ~= true then
						error(("[%s] Field '%s' validation failed"):format(name, key), 3)
					end
				end
			end
		end
		return true
	end

	local function coerceDefault(def)
		return (typeof(def) == "table") and deepCopy(def) or def
	end

	local function fillDefaults(src)
		local out = {}
		for k, rule in pairs(schema) do
			if src[k] ~= nil then
				out[k] = src[k]
			elseif rule.default ~= nil then
				out[k] = coerceDefault(rule.default)
			elseif rule.optional then
				out[k] = nil
			else
				error(("[%s] Missing required field '%s'"):format(name, k), 3)
			end
		end
		return out
	end

	return validate, fillDefaults
end

function Struct.define(name, schema)
	assert(type(name) == "string" and name ~= "", "Struct name required")
	assert(type(schema) == "table", "Schema table required")

	local validate, fillDefaults = buildValidator(name, schema)

	local S = {}
	S.__name = name
	S.__schema = schema

	function S.is(v) return (typeof(v) == "table") and (getmetatable(v) == S) end
	function S.new(init) return S.from(init or {}) end

	function S.from(tbl)
		local base = fillDefaults(tbl or {})
		validate(base)

		local data = base
		local methods = {}

		function methods:toTable(deep) return deep and deepCopy(data) or shallowCopy(data) end
		function methods:clone(patch)
			local t = shallowCopy(data)
			if patch then for k,v in pairs(patch) do t[k] = v end end
			return S.new(t)
		end
		function methods:with(patch) return self:clone(patch) end
		function methods:get(k) return data[k] end
		function methods:validate() return validate(data) end

		local mt = {}
		mt.__index = function(_, k) return methods[k] or data[k] end
		mt.__newindex = function() error(("Struct '%s' is immutable"):format(name), 2) end
		mt.__tostring = function() return ("<Struct %s>"):format(name) end

		return setmetatable({}, mt)
	end

	function S.decode(tbl) assert(type(tbl)=="table","decode expects table"); return S.from(tbl) end
	function S.encode(inst, deep) assert(S.is(inst), "encode expects this struct"); return inst:toTable(deep ~= false) end

	S.__index = S
	return S
end

return Struct
