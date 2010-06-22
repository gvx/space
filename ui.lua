ui = {
	show = true,
	base = {
		items = {'Mission', 'Trade', 'Buy a ship', 'Talk', 'Visit'},
		posses = {x = 20, y = 80, dx = 140, w = 120, h = 120, r = 20},
		vector = {'arrow', 'trade', 'beginner', 'transmission', 'planet'},
		states = {'mission', 'trade', 'buyship', 'talk', 'visit'},
		rot = {0, 0, 0, 0, 0},
		usedmouse = true,
	}
}
registerstate'paused'
registerstate'base'

function ui.load()
end

local function zoomout(n)
	graphics.zoom = graphics.zoom/(1 + .01*n)
end
local function zoomin(n)
	graphics.zoom = graphics.zoom*(1 + .01*n)
end

function ui.update(dt)
	local D = love.keyboard.isDown
	if D'pageup' then
		if settings.revzoom then
			zoomout(1)
		else
			zoomin(1)
		end
	elseif D'pagedown' then
		if settings.revzoom then
			zoomin(1)
		else
			zoomout(1)
		end
	end
	local x = love.mouse.getX()
	if x > 750-20 and x < 800-20 then
		local y, z = love.mouse.getY(), graphics.zoom
		if y > 470-20 then
			if y < 570-20 then
				z = 1/1.05^((570-love.mouse.getY()-20)*1.3)
			else
				z = 1
			end
		elseif y > 450-20 then
			z = 1/1.05^130
		end
		if x > 740 and x < 790 then
			graphics.zoom = (graphics.zoom*3 + z)*.25
		else
			graphics.zoom = (graphics.zoom*19 + z)*.05
		end
	end
	if D's' then
		ui.autopilot = true
		if love.mouse.isDown'l' then
			player.autopilot = true
			player.hyperspeed = false
			player.targetx = (love.mouse.getX()-400)/graphics.zoom + graphics.viewx
			player.targety = (love.mouse.getY()-300)/-graphics.zoom + graphics.viewy
		end
	elseif D'k' then
		ui.autopilot = true
		if love.mouse.isDown'l' then
			player.autopilot = true
			player.hyperspeed = true
			player.targetx = (love.mouse.getX()-400)/graphics.zoom + graphics.viewx
			player.targety = (love.mouse.getY()-300)/-graphics.zoom + graphics.viewy
		end
	else
		ui.autopilot = false
	end
	if D'b' then
		player.braking = true
	end
	if player.landed and not ui.showlanded then
		ui.showlanded = 1
		ui._landed = player.landed
	elseif not player.landed and ui.showlanded then
		ui.showlanded = ui.showlanded - dt
		if ui.showlanded <= 0 then
			ui.showlanded = false
		end
	end
end

function love.mousepressed(x,y,button) --oh god this can't be right
	if state.current == 'game' then	   --a love callback implemented for occasional use?
		if button == 'wu' then
			if settings.revzoom then
				zoomout(3)
			else
				zoomin(3)
			end
		elseif button == 'wd' then
			if settings.revzoom then
				zoomin(3)
			else
				zoomout(3)
			end
		end
	elseif state.current == 'base_buyship' then
		if button == 'wu' then
			base.buyship.scrolly = math.max(math.min(base.buyship.scrolly - 4, base.buyship.maxscrolly),0)
		elseif button == 'wd' then
			base.buyship.scrolly = math.max(math.min(base.buyship.scrolly + 4, base.buyship.maxscrolly),0)
		end
	end
end

function ui.draw()
	if ui.show then
		love.graphics.setColor(0,0,0,50)
		love.graphics.rectangle('fill', 36, 24, 300, 84-20)
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(("Speed: %02d km/s"):format(math.sqrt(player.dx^2 + player.dy^2)/5), 40, 40)
		love.graphics.print("Rank: "..ranks[player.rank], 40, 60)
		if mission.mission then
			love.graphics.print("Mission: "..mission.mission.name, 40, 80)
		end
		graphics.drawshape(graphics.vector.arrow, 750, 40, 15, -player.angle)
		love.graphics.setColor(255,255,255,20)
		love.graphics.rectangle('fill', 754-20, 454-20, 43, 143)
		love.graphics.setColor(0,0,0,100)
		love.graphics.rectangle('fill', 754-20+5, 454-20+5, 43-10, 143-10)
		love.graphics.setColor(255,255,255,255)
		love.graphics.polygon('fill', 754-20, 576-20, 754-20, 596-20, 796-20, 596-20, 796-20, 474-20)
		love.graphics.setLineWidth(1)
		love.graphics.line(754-20, 576-20, 796-20, 474-20)
		if state.current == 'paused' then
			love.graphics.print("GAME PAUSED", 40, 80)
		end
		love.graphics.setColor(0,0,0,255)
		love.graphics.print("Zoom", 756-20, 592-20)
		love.graphics.setColor(255,255,255,255)
		if ui.autopilot then
			love.graphics.print("Auto pilot: click on an area to go there.", 20, 592)
		end
		if player.landed or ui.showlanded then
			love.graphics.print("Landed on "..(ui._landed or player.landed).name..". Press Enter to open base dialog.", 20, 572)
		end
	end
end

function ui.drawbase()
	love.graphics.setColor(255,255,255)
	love.graphics.print("You are now on "..player.landed.name, 40, 60)
	local x, y = love.mouse.getX(), love.mouse.getY()
	
	local p = ui.base.posses
	for i = 1,#ui.base.items do
		local startx = p.x + p.dx*(i-1)
		local mover = ui.base.selected == i--x > startx and x < startx + p.w and y > p.y and y < p.y + p.h
		if mover then
			love.graphics.setColor(80, 80, 80)
		else
			love.graphics.setColor(20, 20, 20)
		end
		love.graphics.roundrect('fill', startx, p.y, p.w, p.h, p.r, p.r)
		love.graphics.setColor(255, 255, 255)
		if mover then
			love.graphics.setLineWidth(4)
		else
			love.graphics.setLineWidth(3)
		end
		love.graphics.roundrect('line', startx, p.y, p.w, p.h, p.r, p.r)
		local txt = ui.base.items[i]
		love.graphics.print(txt, startx + p.w *.5 - smallfont:getWidth(txt)*.5, p.y + p.h + 20 - (mover and 6 or 0))
		if ui.base.vector[i] then
			--graphics.drawshape(graphics.vector.arrow, 750, 40, 15, -player.angle)
			graphics.drawshape(graphics.vector[ui.base.vector[i]], startx + p.w *.5, p.y + p.h * .5, 20, ui.base.rot[i])
		end
	end
end

function ui.base.update(dt)
	local x, y = love.mouse.getX(), love.mouse.getY()
	local p = ui.base.posses
	if y > p.y + p.h or y < p.y or (x - p.x)%p.dx > p.w then
		--if ui.base.usedmouse then
		--	ui.base.selected = nil
		--end
	else
		ui.base.selected = math.floor((x - p.x)/p.dx)+1
		ui.base.usedmouse = true
		if love.mouse.isDown'l' then
			--change state
			states.base.keypressed.enter()
		end
	end
	for i=1,#ui.base.rot do
		if ui.base.selected == i then
			ui.base.rot[i] = ui.base.rot[i] + 2*dt
		else
			ui.base.rot[i] = ui.base.rot[i] - .5*dt
		end
	end
end

function states.game.keypressed.f7()
	ui.show = not ui.show
end

function states.game.keypressed.p()
	state.current = 'paused'
end

function states.game.keypressed.enter ()
	if player.landed then
		state.current = 'base'
	end
end

function states.paused.keypressed.p()
	state.current = 'game'
end

function states.base.keypressed.escape()
	state.current = 'game'
end

function states.base.keypressed.left()
	ui.base.usedmouse = false
	local nitems = #ui.base.items
	ui.base.selected = ((ui.base.selected or 1) - 2) % nitems + 1
end

function states.base.keypressed.right()
	ui.base.usedmouse = false
	local nitems = #ui.base.items
	ui.base.selected = (ui.base.selected or nitems) % nitems + 1
end

function states.base.keypressed.enter()
	if ui.base.selected then
		state.current = 'base_'.. ui.base.states[ui.base.selected]
		if base[ui.base.states[ui.base.selected]].init then
			base[ui.base.states[ui.base.selected]].init()
		end
	end
end


function states.game.keypressed.escape()
	state.current = 'mainmenu'
	love.graphics.setFont(largefont)
end
