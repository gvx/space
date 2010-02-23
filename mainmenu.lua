mainmenu = {
	selitem = 1,
	sely = 40,
	seldy = 0,
	items = {'New game', 'Continue', 'Settings', 'Credits', 'Quit'},
	actions = {
		function ()
			love.graphics.setFont(smallfont)
			state.current = 'game'
		end,
		function ()
			love.graphics.setFont(smallfont)
			state.current = 'game'
		end,
		function ()
			love.graphics.setFont(smallfont)
			state.current = 'game'
		end,
		function ()
			love.graphics.setFont(smallfont)
			state.current = 'game'
		end,
		function ()
			love.event.push'q'
		end
		}
	}
registerstate 'mainmenu'

function mainmenu.load()
end

function mainmenu.update(dt)
	local to = mainmenu.selitem*40
	if mainmenu.sely > to + 15 then
		--mainmenu.sely = mainmenu.sely - 100 * dt
		mainmenu.seldy = mainmenu.seldy - 450 * dt
	elseif mainmenu.sely > to + 5 then
		mainmenu.seldy = mainmenu.seldy*.94 - 50 * dt
	elseif mainmenu.sely < to - 15 then
		mainmenu.seldy = mainmenu.seldy + 450 * dt
	elseif mainmenu.sely < to - 5 then
		mainmenu.seldy = mainmenu.seldy*.94 + 50 * dt
	end
	if mainmenu.seldy > 200 then
		mainmenu.seldy = 200
	end
	if mainmenu.seldy < -200 then
		mainmenu.seldy = -200
	end
	mainmenu.sely = mainmenu.sely + mainmenu.seldy * dt
	if love.mouse.isDown'l' then
		local y = love.mouse.getY() 
		if y > 300 + 40 - 30  - mainmenu.sely and y < 300 + 40*#mainmenu.items - mainmenu.sely then
			mainmenu.actions[math.floor((y - 300 + 30 + mainmenu.sely)/40)]()
		end
	end
end

function mainmenu.draw()
	love.graphics.setColor(255,255,255)
	local sh = math.sqrt(math.abs(mainmenu.seldy))*.3
	local shx = sh > 2 and math.random(sh)-.5*sh or 0
	local shy = sh > 2 and math.random(sh)-.5*sh or 0
	love.graphics.print('Space', 20 + shx, 50 + shy)
	local I = mainmenu.selitem
	for i=1,#mainmenu.items do
		local m = math.abs(i - mainmenu.sely / 40)*10
		local M = i==I and 0 or (100+ math.sqrt(math.abs(i-I))*50)
		if math.floor((love.mouse.getY()  - 300 + 30 + mainmenu.sely)/40) == i then
			love.graphics.setColor(i==I and 20 or (255-M),255,255)
		else
			love.graphics.setColor(255-M,255-M,255-M)
		end
		love.graphics.print(mainmenu.items[i], 300 - m, 300 + i * 40 - mainmenu.sely)
	end
end

function states.mainmenu.keypressed.down()
	if mainmenu.selitem < #mainmenu.items then
		mainmenu.selitem = mainmenu.selitem + 1
	end
end

function states.mainmenu.keypressed.up()
	if mainmenu.selitem > 1 then
		mainmenu.selitem = mainmenu.selitem - 1
	end
end

states.mainmenu.keypressed['return'] = function()
	mainmenu.actions[mainmenu.selitem]()
end
