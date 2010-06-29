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
	dr = 'Alliance of Oppressed People'}

function registerstate(name)
	states[name] = {}
	states[name].keypressed = {}
end
registerstate'game'
registerstate'dead'

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
end

function love.update(dt)
	if state.current == 'game' then
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
	elseif state.current == 'mission' then
		mission.missionupdate(dt)
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
	elseif state.current == 'dead' then
		love.graphics.print('Nice steering, captain. You\'re dead now.', 100, 100)
		love.graphics.print('Press R to restart the game.', 100, 120)
	elseif state.current == 'base' then
		ui.drawbase()
	elseif state.current == 'mainmenu' then
		mainmenu.draw()
	elseif state.current == 'mission' then
		mission.missiondraw()
	elseif state.current == 'mission_debrief' then
		mission.mission_debriefdraw()
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
	end
end
