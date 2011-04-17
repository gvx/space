local counter

local function num2name(n)
	return '_' .. n
end

local function find_key(t, value)
	for k,v in pairs(t) do
		if v == value then
			return k
		end
	end
end

local function write(t, memo)
	local ty = type(t)
	if ty == 'number' or ty == 'boolean' then
		return tostring(t)
	elseif ty == 'string' then
		return ("%q"):format(t):gsub('\\\n', '\\n')
	elseif ty == 'table' or ty == 'function' then
		if not memo[t] then
			counter = counter + 1
			memo[t] = counter
		end
		return num2name(memo[t])
	else
		return '???'
	end
end

local function make_safe(text)
	local m = {}
	text = ("%q"):format(text):gsub('\\\n', '\\n')
	for i=1,#text do
		local s = text:byte(i)
		if s < 32 or s >= 127 then
			m[i] = ("\\%03d"):format(s)
		else
			m[i] = text:sub(i,i)
		end
	end
	return table.concat(m)
end

local function write_key_value_pair(k, v, memo, name)
	if type(k) == 'string' and k:match '^[_%a][_%w]*$' then
		return (name and name .. '.' or '') .. k..' = ' ..write(v, memo)
	else
		return (name or '') .. '['..write(k, memo)..'] = ' ..write(v, memo)
	end
end

local function is_cyclic(memo, sub, super)
	if type(sub) == 'table' or type(sub) == 'function' then
		local m = memo[sub]
		local p = memo[super]
		return m and p and m < p
	end
end

local function write_table_ex(t, memo, srefs, name)
	if name then
		memo[t] = name
	end
	srefs[t] = srefs[t] or {}
	if type(t) == 'function' then
		return (name and 'local ' .. num2name(name) .. ' = ' or 'return ') .. 'loadstring ' .. make_safe(string.dump(t))
	end
	local m = {'{'}
	for i,v in ipairs(t) do
		if v == t then
			srefs[t][#srefs[t]+1] = {name, i, v}
		else
			m[#m+1] = write(v, memo) .. ', '
		end
	end
	for k,v in pairs(t) do
		if type(k) ~= 'number' or math.floor(k) ~= k or k < 1 or k > #t then
			if v == t or k == t then
				srefs[t][#srefs[t]+1] = {name, k, v}
			elseif is_cyclic(memo, v, t) then
				srefs[v] = srefs[v] or {}
				srefs[v][#srefs[v]+1] = {name, k, v}
			elseif is_cyclic(memo, k, t) then
				srefs[k] = srefs[k] or {}
				srefs[k][#srefs[k]+1] = {name, k, v}
			else
				m[#m+1] = write_key_value_pair(k, v, memo) .. ', '
			end
		end
	end
	m[#m+1] = '}'
	return (name and 'local ' .. num2name(name) .. ' = ' or 'return ') .. table.concat(m)
end

function write_table(t)
	counter = 0

	local memo = {}
	local srefs = {}
	local result = {write_table_ex(t, memo, {})}
	local i = 0
	while i < counter do
		i = i + 1
		local tbl = find_key(memo, i)
		table.insert(result, 1, write_table_ex(tbl, memo, srefs, i))
	end
	for _,g in pairs(srefs) do
		for i,v in ipairs(g) do
			table.insert(result, #result, write_key_value_pair(v[2], v[3], memo, num2name(v[1])))
		end
	end
	return table.concat(result, '\n')
end