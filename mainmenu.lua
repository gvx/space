mainmenu = {
	selitem = 1,
	sely = 40,
	seldy = 0,
	items = {'New game', 'Continue', 'Settings', 'Credits', 'Quit'},
	actions = {
		function ()
			mainmenu.transition.targetfont = smallfont
			mainmenu.transition.timeout = .5
			mainmenu.transition.target = 'game'
			state.current = 'mainmenu_transition'
		end,
		function ()
			mainmenu.transition.targetfont = smallfont
			mainmenu.transition.timeout = .5
			mainmenu.transition.target = 'game'
			state.current = 'mainmenu_transition'
		end,
		function ()
			mainmenu.transition.targetfont = largefont
			mainmenu.transition.timeout = .5
			mainmenu.transition.target = 'mainmenu_settings'
			state.current = 'mainmenu_transition'
		end,
		function ()
			mainmenu.transition.targetfont = largefont
			mainmenu.credits.totaltime = 0
			mainmenu.transition.timeout = .5
			mainmenu.transition.target = 'mainmenu_credits'
			state.current = 'mainmenu_transition'
		end,
		function ()
			mainmenu.transition.targetfont = largefont
			mainmenu.credits.totaltime = 0
			mainmenu.transition.timeout = .5
			mainmenu.transition.target = 'mainmenu_quitting'
			state.current = 'mainmenu_transition'
		end
		},
	settings = {
		timeout = 0,
		selitem = 1,
		items = {
			{name='Reverse zoom keys', hint='Make scrolling up zoom out', type='bool', value='revzoom'},
			{name='Disable shaking', hint='Do not shake the camera when close to a black hole', type='bool', value='noshaking'},
			{name='Back to main menu', hint='Return to the main menu, all changes are applied', type='return'},
			},
		},
	credits = {
		totaltime = 0,
		items = {
			{'gvx', 'Robin Wellner', 'Project lead, code'},
			{'CyaNox', 'Mark Sanders', 'Spaceship design and artwork'},
			{'Thanks', 'to the LOVE CLUB', 'for the feedback and support'},
			{'', '', ''},
			}
		},
	transition = {
		timeout = 0,
		},
	quitting = {},
	}
settings = {}
registerstate 'mainmenu'
registerstate 'mainmenu_transition'
registerstate 'mainmenu_settings'
registerstate 'mainmenu_credits'
registerstate 'mainmenu_quitting'


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
			mainmenu.selitem = math.floor((y - 300 + 30 + mainmenu.sely)/40)
			states.mainmenu.keypressed.enter()
		end
	end
end

function mainmenu.draw(a)
	a = a or 255
	love.graphics.setColor(255,255,255, a)
	local sh = math.sqrt(math.abs(mainmenu.seldy))*.3
	local shx = sh > 2 and math.random(sh)-.5*sh or 0
	local shy = sh > 2 and math.random(sh)-.5*sh or 0
	love.graphics.print('Space', 20 + shx, 50 + shy)
	local I = mainmenu.selitem
	for i=1,#mainmenu.items do
		local m = math.abs(i - mainmenu.sely / 40)*10
		local M = i==I and 0 or (100+ math.sqrt(math.abs(i-I))*50)
		if math.floor((love.mouse.getY()  - 300 + 30 + mainmenu.sely)/40) == i then
			love.graphics.setColor(i==I and 20 or (255-M),255,255, a)
		else
			love.graphics.setColor(255-M,255-M,255-M, a)
		end
		love.graphics.print(mainmenu.items[i], 300 - m, 300 + i * 40 - mainmenu.sely)
	end
end

function mainmenu.settings.update(dt)
	mainmenu.settings.timeout = mainmenu.settings.timeout + dt
end
function mainmenu.settings.draw()
	for i, setting in ipairs(mainmenu.settings.items) do
		if i == mainmenu.settings.selitem then
			love.graphics.setColor(100,100,100)
			love.graphics.roundrect('fill', 15, i*30-15, 750, 30, 10, 10)
			love.graphics.roundrect('line', 15, i*30-15, 750, 30, 10, 10)
			if mainmenu.settings.timeout > .5 then
				love.graphics.setFont(smallfont)
				love.graphics.setColor(255,255,255, math.min((mainmenu.settings.timeout-.5)*255, 255))
				love.graphics.print(setting.hint, 740 - smallfont:getWidth(setting.hint), i*30+5)
				love.graphics.setFont(largefont)
			end
		end
		love.graphics.setColor(255,255,255)
		love.graphics.print(setting.name, 50, i*30+10)
		if setting.type == 'bool' then
			love.graphics.setLineWidth(2)
			love.graphics.rectangle('line', 25, i*30-10, 20, 20)
			if settings[setting.value] then
				love.graphics.rectangle('fill', 25, i*30-10, 20, 20)
			end
		end
	end
end

function mainmenu.transition.update(dt)
	mainmenu.transition.timeout = mainmenu.transition.timeout - dt
	if mainmenu.transition.timeout <= 0 then
		state.current = mainmenu.transition.target
		love.graphics.setFont(mainmenu.transition.targetfont)
		love.update(0.001)
	end
end
function mainmenu.transition.draw()
	local t = mainmenu.transition.timeout
	love.graphics.push()
	local y = 300 + mainmenu.selitem * 40 - mainmenu.sely
	love.graphics.translate(300, y)
	--love.graphics.scale(.5/t,.5/t)--mainmenu.transition.timeout*2, 1)
	love.graphics.rotate((0.707-t^.5)*8)
	love.graphics.translate(-300, -y)
	mainmenu.draw(510*t)
	love.graphics.pop()
end
function mainmenu.quitting.update(dt)
	love.event.push'q'
end
function mainmenu.quitting.draw()
end


function mainmenu.credits.update(dt)
	mainmenu.credits.totaltime = mainmenu.credits.totaltime + dt
	if mainmenu.credits.totaltime > #mainmenu.credits.items * 2 then
		states.mainmenu_credits.keypressed.escape()
	end
end
function mainmenu.credits.draw()
	local t = mainmenu.credits.totaltime
	local i = math.floor(t/2)+1
	local name = mainmenu.credits.items[i]
	if name then
		local a = 255 - (t%2-1)^2*255
		love.graphics.setColor(255,255,255, a)
		love.graphics.print(name[1], 10 + (i * 74) % 95, 50 + i)
		love.graphics.print(name[2], 130 + (i * 185) % 115, 90 + i)
		love.graphics.print(name[3], 70 + (i * 18) % 39, 120 + i)
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

function states.mainmenu.keypressed.enter()
	mainmenu.actions[mainmenu.selitem]()
end

function states.mainmenu_settings.keypressed.escape()
	love.graphics.setFont(largefont)
	state.current = 'mainmenu'
end
states.mainmenu_credits.keypressed.escape = states.mainmenu_settings.keypressed.escape

function states.mainmenu_settings.keypressed.up()
	mainmenu.settings.selitem = (mainmenu.settings.selitem - 2) % #mainmenu.settings.items + 1
	mainmenu.settings.timeout = 0
end

function states.mainmenu_settings.keypressed.down()
	mainmenu.settings.selitem = mainmenu.settings.selitem % #mainmenu.settings.items + 1
	mainmenu.settings.timeout = 0
end

function states.mainmenu_settings.keypressed.enter()
	local s = mainmenu.settings.items[mainmenu.settings.selitem]
	if s.type == 'return' then
		states.mainmenu_settings.keypressed.escape()
	elseif s.type == 'bool' then
		settings[s.value] = not settings[s.value]
	else
	end
end
