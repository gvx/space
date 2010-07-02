-- based on thelinx's Public Domain UaLove hook system
hook = {hooks = {}}

function hook.add(event, func, id)
	hook.hooks[event] = hook.hooks[event] or {}
	table.insert(hook.hooks[event], func)
end

function hook.call(event, ...)
	for i=1,#hook.hooks[event] do
		if hook.hooks[event][i](...) then
			break
		end
	end
end

