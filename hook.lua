-- based on thelinx's Public Domain UaLove hook system
hook = {}

function hook.add(event, func, id)
	hook.hooks[id] = {event, func}
end

function hook.call(event, ...)
	for k,v in pairs(hook.hooks) do
		if v[1] == event then
			if v[2](...) then
				break
			end
		end
	end
end

