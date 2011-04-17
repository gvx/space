require 'write'

love.filesystem.mkdir 'saves'

local modules = {map=map, graphics=graphics,
	ui=ui, player=player, ai=ai, ships=ships,
	physics=physics, mainmenu=mainmenu,
	base=base, mission=mission,
	diplomacy=diplomacy, help=help, conv=conv}

function savegame(filename)
	local buildsave = {}
	for key, mod in pairs(modules) do
		buildsave[key] = {}
		for k, v in pairs(mod) do
			if mod.allowsave(k) then
				buildsave[key][k] = v
			end
		end
	end
	-- now write buildsave to filename
	f = love.filesystem.newFile('saves/'..filename)
	f:open'w'
	f:write(write_table(buildsave))
	f:close()
end

function loadgame(filename)
	local ok, chunk = pcall(love.filesystem.load, 'saves/'..filename)
	if ok then
		for key, mod in pairs(chunk()) do
			for k, v in pairs(mod) do
				modules[key][k] = v
			end
		end
	else
		-- display a distressing message?
	end
end
