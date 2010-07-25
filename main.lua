require 'roundrect'
math.randomseed(os.time())

varfilter = '$(%w+)%$?'
function printf(template, rep)
	return (template:gsub(varfilter, rep))
end

state = {frame = 0, totaltime = 0, current = 'mainmenu'}
states = {}

officialnames = {spacecorp = 'SpaceCorp', a = 'Amania', b = 'Bzadoria',
	c = 'Cadadonia', d = 'Darzamin', ar = 'Anarchists',
	br = 'Fighters for the Common Good', cr = 'Eclectic Monkeys',
	dr = 'Alliance of Oppressed People', dem = 'Deus Ex Machines',
	player = 'You'}

function registerstate(name)
	states[name] = {}
	states[name].keypressed = {}
end
registerstate'game'
registerstate'dead'

require "hook"

function love.load()
	require "map"
	require "graphics"
	require "ui"
	require "player"
	require "ai"
	require "ships"
	require "physics"
	require "mainmenu"
	require "base"
	require "mission"
	require "diplomacy"
	require "help"
	require "conv"
	
	smallfont = love.graphics.newFont('gemfontone.ttf', 16)
	largefont = love.graphics.newFont('gemfontone.ttf', 30)
	mediumfont = love.graphics.newFont('gemfontone.ttf', 22)
	love.graphics.setFont(largefont)
	
	restart()
end

function restart()
	map.load()
	graphics.load()
	ui.load()
	ships.load()
	player.load()
	ai.load()
	physics.load()
	mainmenu.load()
	base.load()
	mission.load()
	help.load()
	conv.load()
	diplomacy.load()
end

function love.update(dt)
	if state.current == 'game' then
		if not ui.cmdstring then
			state.frame = state.frame + 1
			state.totaltime = state.totaltime + dt
			
			mission.update(dt)
			map.update(dt)
			ui.update(dt)
			player.update(dt)
			ai.update(dt)
			ships.update(dt)
			physics.update(dt)
			graphics.update(dt)
		end
		love.timer.sleep(10)
	elseif state.current == 'paused' then
		state.frame = state.frame + 1
		love.timer.sleep(20)
	elseif state.current == 'dead' then
		love.timer.sleep(50)
	elseif state.current == 'mainmenu' then
		mainmenu.update(dt)
		love.timer.sleep(20)
	elseif state.current == 'base' then
		ui.base.update(dt)
		love.timer.sleep(20)
	elseif state.current == 'help' then
		help.update(dt)
		love.timer.sleep(20)
	elseif state.current == 'conv' then
		conv.update(dt)
		love.timer.sleep(20)
	elseif state.current:sub(1,7) == 'mission' then
		mission.updatescreen(dt)
		love.timer.sleep(20)
	elseif state.current:sub(1,4) == 'base' then
		base.update(dt)
		love.timer.sleep(20)
	elseif state.current:sub(1,8) == 'mainmenu' then
		mainmenu[state.current:sub(10)].update(dt)
		love.timer.sleep(20)
	end
end

function love.draw()
	if state.current == 'game' or state.current == 'paused' then
		map.draw()
		graphics.draw()
		ui.draw()
		player.draw()
		ai.draw()
		ships.draw()
		physics.draw()
	elseif state.current == 'help' then
		help.draw()
	elseif state.current == 'dead' then
		love.graphics.print('Nice steering, captain. You\'re dead now.', 100, 100)
		love.graphics.print('Press R to restart the game.', 100, 130)
	elseif state.current == 'base' then
		ui.drawbase()
	elseif state.current == 'mainmenu' then
		mainmenu.draw()
	elseif state.current == 'conv' then
		conv.draw()
	elseif state.current:sub(1,7) == 'mission' then
		mission.drawscreen()
	elseif state.current:sub(1,4) == 'base' then
		base.draw()
	elseif state.current:sub(1,8) == 'mainmenu' then
		mainmenu[state.current:sub(10)].draw()
	end
end

function love.keypressed(key, unicode)
	if key == 'return' then key = 'enter' end
	if states[state.current].keypressed[key] then
		states[state.current].keypressed[key]()
	elseif states[state.current].keypressed.other then
		states[state.current].keypressed.other(key, unicode)
	end
end

local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. msg, 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

function love.errhand(msg)

	error_printer(msg, 2)

	-- Load.
	love.graphics.setScissor()

	love.graphics.setColor(255, 255, 255, 255)

	local trace = debug.traceback()

	love.graphics.clear()

	local err = {msg}

	for l in string.gmatch(trace, "(.-)\n") do
		if not string.match(l, "boot.lua") then
			l = string.gsub(l, "stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end

	local p = table.concat(err, "\n")

	p = string.gsub(p, "\t", "")
	p = string.gsub(p, "%[string \"(.-)\"%]", "%1")

	local wi = love.graphics.getWidth() - 140
	address = 'github.com/gvx/space/issues'
	local wa = love.graphics.getWidth() - largefont:getWidth(address) - 20
	local ha = love.graphics.getHeight() - 20

	local function draw()
		love.graphics.clear()
		love.graphics.setFont(largefont)
		love.graphics.print('Oops! Something went wrong.', 20, 35)
		love.graphics.print(address, wa, ha)
		love.graphics.setFont(mediumfont)
		if showtrace then
			love.graphics.printf(p, 70, 120, wi)
		else
			love.graphics.printf('An error occurred. It would be great if you want to file a bug report. To do that, please visit github.com/gvx/space/issues. First check if this bug has not been fixed already. If you have no terminal with the traceback of the error, press space. To quit, press escape.', 70, 120, wi)
		end
		love.graphics.present()
	end

	draw()

	local e, a, b, c
	while true do
		e, a, b, c = love.event.wait()

		if e == "q" then
			return
		end
		if e == "kp" then
			if a == "escape" then
				return
			elseif a == ' ' then
				showtrace = not showtrace
			end
		end

		draw()

		love.timer.sleep(25)

	end

end
