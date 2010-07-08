-- based on thelinx's Public Domain UaLove hook system
hook = {hooks = {}}

function hook.add(event, func)
	hook.hooks[event] = hook.hooks[event] or {}
	table.insert(hook.hooks[event], func)
end

function hook.call(event, ...)
	if not hook.hooks[event] then return end
	local i = 1
	while i <= #hook.hooks[event] do
		local r = hook.hooks[event][i](...)
		if r == 'remove' then
			table.remove(hook.hooks[event], i)
		elseif r then
			break
		else
			i = i + 1
		end
	end
end

