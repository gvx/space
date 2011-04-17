local counter

local function write(t, memo)
	local ty = type(t)
	if ty == 'number' or ty == 'boolean' then
		return tostring(t)
	elseif ty == 'string' then
		return ("%q"):format(t):gsub('\\\n', '\\n')
	elseif ty == 'table' then
		if not memo[t] then
			counter = counter + 1
			memo[t] = '_' .. counter
		end
		return memo[t]
	else
		return '???'
	end
end

local function write_key_value_pair(k, v, memo, name)
	if type(k) == 'string' and k:match '^[_%a][_%w]*$' then
		return (name and name .. '.' or '') .. k..' = ' ..write(v, memo)
	else
		return (name or '') .. '['..write(k, memo)..'] = ' ..write(v, memo)
	end
end

local function write_table_ex(t, memo, srefs, name)
	if name then
		memo[t] = name
	end
	local m = {'{'}
	for i,v in ipairs(t) do
		if v == t then
			srefs[i] = v
		else
			m[#m+1] = write(v, memo) .. ', '
		end
	end
	for k,v in pairs(t) do
		if type(k) ~= 'number' or math.floor(k) ~= k or k < 1 or k > #t then
			if v == t or k == t then
				srefs[k] = v
			else
				m[#m+1] = write_key_value_pair(k, v, memo) .. ', '
			end
		end
	end
	m[#m+1] = '}'
	return (name and 'local ' .. name .. ' = ' or 'return ') .. table.concat(m)
end

local function find_key(t, value)
	for k,v in pairs(t) do
		if v == value then
			return k
		end
	end
end

function write_table(t)
	counter = 0

	local memo = {}
	local result = {write_table_ex(t, memo)}
	local i = 0
	while i < counter do
		i = i + 1
		local name = '_' .. i
		local srefs = {}
		table.insert(result, 1, write_table_ex(find_key(memo, name), memo, srefs, name))
		for k,v in pairs(srefs) do
			table.insert(result, 2, write_key_value_pair(k, v, memo, name))
		end
	end
	return table.concat(result, '\n')
end