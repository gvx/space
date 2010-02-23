require 'roundrect'
math.randomseed(os.time())

state = {frame = 0, totaltime = 0, current = 'mainmenu'}
states = {}

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
	
	smallfont = love.graphics.newFont('gemfontone.ttf', 16)
	largefont = love.graphics.newFont('gemfontone.ttf', 30)
	love.graphics.setFont(largefont)
	
	restart()
end

function restart()
	map.load()
	graphics.load()
	ui.load()
	player.load()
	ai.load()
	ships.load()
	physics.load()
	mainmenu.load()
	base.load()
end

function love.update(dt)
	if state.current == 'game' then
		state.frame = state.frame + 1
		state.totaltime = state.totaltime + dt
		
		map.update(dt)
		ui.update(dt)
		player.update(dt)
		ai.update(dt)
		ships.update(dt)
		physics.update(dt)
		graphics.update(dt)
		love.timer.sleep(10)
	elseif state.current == 'paused' then
		love.timer.sleep(20)
	elseif state.current == 'dead' then
		love.timer.sleep(50)
	elseif state.current == 'mainmenu' then
		mainmenu.update(dt)
		love.timer.sleep(20)
	elseif state.current == 'base' then
		ui.base.update(dt)
		love.timer.sleep(20)
	elseif state.current:sub(1,4) == 'base' then
		base.update(dt)
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
	elseif state.current:sub(1,4) == 'base' then
		base.draw()
	elseif state.current == 'mainmenu' then
		mainmenu.draw()
	end
end

function love.keypressed(key, unicode)
	if states[state.current].keypressed[key] then
		states[state.current].keypressed[key]()
	end
end
