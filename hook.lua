-- based on thelinx's Public Domain UaLove hook system
hook = {hooks = {}}

function hook.add(event, func)
	hook.hooks[event] = hook.hooks[event] or {}
	table.insert(hook.hooks[event], func)
end

function hook.call(event, ...)
	if not hook.hooks[event] then return end
	for i=1,#hook.hooks[event] do
		if hook.hooks[event][i](...) then
			break
		end
	end
end

