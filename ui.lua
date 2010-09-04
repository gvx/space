ui = {
	show = true,
	showcargoindex = 1,
	base = {
		items = {'Mission', 'Trade', 'Buy a ship', 'Talk', 'Visit'},
		enabled = {true, true, true, true, true},
		posses = {x = 20, y = 80, dx = 140, w = 120, h = 120, r = 20},
		vector = {'arrow', 'trade', 'beginner', 'transmission', 'planet'},
		states = {'mission', 'trade', 'buyship', 'talk', 'visit'},
		rot = {0, 0, 0, 0, 0},
		usedmouse = true,
	},
	cmdlist = {''},
	cmdlistindex = 1,
}
registerstate'paused'
registerstate'base'

states.game.cmdkeys = {}

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
			player.targetx = (love.mouse.getX()-400)/graphics.zoom + graphics.viewx
			player.targety = (love.mouse.getY()-300)/-graphics.zoom + graphics.viewy
			player.hyperspeed = D'lshift' or D'rshift'
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
	elseif state.current:sub(1,4) == 'base' then
		if button == 'wu' then
			base.info.scrolly = math.max(math.min(base.info.scrolly - 20, base.info.maxscrolly),0)
		elseif button == 'wd' then
			base.info.scrolly = math.max(math.min(base.info.scrolly + 20, base.info.maxscrolly),0)
		end
	end
end

local abs, cos, sqrt, atan2 = math.abs, math.cos, math.sqrt, math.atan2
function ui.draw()
	if ui.show then
		love.graphics.setColor(0,0,0,90)
		love.graphics.rectangle('fill', 36, 24, 300, 84-20)
		love.graphics.setColor(255,255,255,255)
		love.graphics.print(("Speed: %02d km/s"):format(sqrt(player.dx^2 + player.dy^2)/5), 40, 40)
		love.graphics.print("Rank: "..ranks[player.rank], 40, 60)
		if mission.mission then
			love.graphics.print("Mission: "..mission.mission.name, 40, 80)
		end
		graphics.drawshape(graphics.vector.arrow, 750, 40, 15, -player.angle)
		if ui.showmotion then
			graphics.drawshape(graphics.vector.arrow, 750, 100, 15, -atan2(player.dy, player.dx))
		end
		love.graphics.setColor(255,255,255,20)
		love.graphics.rectangle('fill', 754-20, 454-20, 43, 143)
		love.graphics.setColor(0,0,0,100)
		love.graphics.rectangle('fill', 754-20+5, 454-20+5, 43-10, 143-10)
		love.graphics.setColor(255,255,255,255)
		love.graphics.polygon('fill', 754-20, 576-20, 754-20, 596-20, 796-20, 596-20, 796-20, 474-20)
		love.graphics.setLineWidth(1)
		love.graphics.line(754-20, 576-20, 796-20, 474-20)
		if state.current == 'paused' then
			love.graphics.setColor(255,255,255,abs(cos(state.frame*.1))*160+95)
			love.graphics.rectangle('fill', 400-60, 300-90, 35, 180)
			love.graphics.rectangle('fill', 400+30, 300-90, 35, 180)
			love.graphics.setColor(255,255,255,255)
		end
		love.graphics.setColor(0,0,0,255)
		love.graphics.print("Zoom", 756-20, 592-20)
		love.graphics.setColor(255,255,255,255)
		if ui.autopilot then
			love.graphics.setColor(0,0,0,90)
			love.graphics.rectangle('fill', 16, 578, 600, 20)
			love.graphics.setColor(255,255,255,255)
			love.graphics.print("Auto pilot: click on an area to go there.", 20, 592)
		end
		if player.landed or ui.showlanded then
			love.graphics.setColor(0,0,0,90)
			love.graphics.rectangle('fill', 16, 558, 600, 20)
			love.graphics.setColor(255,255,255,255)
			love.graphics.print("Landed on "..(ui._landed or player.landed).name..". Press Enter to open base dialog.", 20, 572)
		end
		if ui.showcargo then
			love.graphics.setColor(0,0,0,90)
			love.graphics.rectangle('fill', 36, 120, 500, 200)
			love.graphics.setColor(255,255,255,90)
			if ui.showcargoindex <= #player.ship.cargo then
				love.graphics.rectangle('fill', 36, 122+ui.showcargoindex*20, smallfont:getWidth(map.objectreserve[player.ship.cargo[ui.showcargoindex]].name)+8, 18)
			end
			love.graphics.setColor(255,255,255,255)
			love.graphics.print('Cargo:', 40, 136)
			for i=1,#player.ship.cargo do
				love.graphics.print(map.objectreserve[player.ship.cargo[i]].name, 40, 136 + 20 * i)
			end
		end
		if ui.showcargoitem then
			love.graphics.setColor(0,0,0,90)
			love.graphics.rectangle('fill', 36, 120, 500, 200)
			local citem = map.objectreserve[player.ship.cargo[ui.showcargoindex]]
			love.graphics.setColor(255,255,255,90)
			love.graphics.rectangle('fill', 36, 120, smallfont:getWidth(citem.name)+8, 22)
			love.graphics.setColor(255,255,255)
			love.graphics.print(citem.name, 40, 136)
			love.graphics.print('Weight: '..citem.weight, 40, 156)
			love.graphics.printf(citem.description, 40, 176, 500-16)
		end
	end
	if ui.cmdstring then
		love.graphics.setColor(20,20,20,180)
		love.graphics.rectangle('fill', 0, 0, 800, 600)
		love.graphics.setColor(255,255,255)
		love.graphics.print(':'..ui.cmdstring, 400, 38)
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
		if ui.base.enabled[i] then
			love.graphics.setColor(255, 255, 255)
		else
			love.graphics.setColor(128, 128, 128)
		end
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
		local s = math.floor((x - p.x)/p.dx)+1
		if ui.base.enabled[s] then
			ui.base.selected = s
			ui.base.usedmouse = true
			if love.mouse.isDown'l' then
				--change state
				states.base.keypressed.enter()
			end
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

function states.game.keypressed.f1()
	state.current = 'help'
	love.graphics.setFont(largefont)
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
		hook.call('enterbase', player.landed)
		ui.base.enabled[1] = not mission.mission or mission.mission.canrefuse
	end
end

function states.paused.keypressed.p()
	state.current = 'game'
end

function states.base.keypressed.escape()
	state.current = 'game'
	hook.call('leavebase', player.landed)
end

function states.base.keypressed.left()
	ui.base.usedmouse = false
	local nitems = #ui.base.items
	local s = ((ui.base.selected or 1) - 2) % nitems + 1
	while not ui.base.enabled[s] do
		s = (s - 2) % nitems + 1
	end
	ui.base.selected = s
end

function states.base.keypressed.right()
	ui.base.usedmouse = false
	local nitems = #ui.base.items
	local s = (ui.base.selected or nitems) % nitems + 1
	while not ui.base.enabled[s] do
		s = s % nitems + 1
	end
	ui.base.selected = s
end

function states.base.keypressed.enter()
	if ui.base.selected then
		local st = ui.base.states[ui.base.selected]
		state.current = 'base_'.. st
		if base[st].init then
			base[st].init()
		end
	end
end


function states.game.keypressed.escape()
	state.current = 'mainmenu'
	love.graphics.setFont(largefont)
end

function states.game.keypressed.c()
	ui.showcargo = not (ui.showcargo or ui.showcargoitem)
	ui.showcargoitem = false
end

function states.game.keypressed.j()
	if ui.showcargo and #player.ship.cargo > 0 then
		ui.showcargoindex = ui.showcargoindex % #player.ship.cargo + 1
	end
end

function states.game.keypressed.k()
	if ui.showcargo and #player.ship.cargo > 0 then
		ui.showcargoindex = (ui.showcargoindex-2) % #player.ship.cargo + 1
	end
end

function states.game.keypressed.l()
	if ui.showcargo and #player.ship.cargo > 0 then
		ui.showcargo = false
		ui.showcargoitem = true
		if ui.showcargoindex > #player.ship.cargo then
			ui.showcargoindex = #player.ship.cargo
		end
	end
end

function states.game.keypressed.h()
	if ui.showcargoitem then
		ui.showcargo = true
		ui.showcargoitem = false
	end
end

states.game.keypressed[';'] = function()
	states.game.keypressed, states.game.cmdkeys = states.game.cmdkeys, states.game.keypressed
	ui.cmdstring = ''
end

function states.game.cmdkeys.enter()
	states.game.keypressed, states.game.cmdkeys = states.game.cmdkeys, states.game.keypressed
	if ui.cmdstring ~= '' then
		hook.call('command', ui.cmdstring)
		ui.cmdlist[#ui.cmdlist] = ui.cmdstring
		table.insert(ui.cmdlist, '')
		ui.cmdlistindex = #ui.cmdlist
	end
	ui.cmdstring = nil
end

cmds = {}
function cmds.set(rest)
	if settinginfo[rest] == 'bool' then
		settings[rest] = true
	end
end
function cmds.unset(rest)
	if settinginfo[rest] == 'bool' then
		settings[rest] = false
	end
end
function cmds.showmotion()
	ui.showmotion = not ui.showmotion
end
cmds.sm = cmds.showmotion

hook.add('command', function(command)
	if cmds[command] then
		cmds[command]()
	else
		local sp = command:find(' ', 1, true)
		if sp then
			local cmd_name = command:sub(1, sp - 1)
			if cmds[cmd_name] then
				cmds[cmd_name](command:sub(sp + 1))
			end
		end
	end
end)

local iD = love.keyboard.isDown
function states.game.cmdkeys.backspace()
	if ui.cmdstring == '' then
		states.game.keypressed.enter()
	else
		if iD'lctrl' or iD'rctrl' then
			while ui.cmdstring:sub(-1) ~= ' ' and #ui.cmdstring > 0 do
				ui.cmdstring = ui.cmdstring:sub(1,-2)
			end
		end
		ui.cmdstring = ui.cmdstring:sub(1,-2)
	end
end

function states.game.cmdkeys.up()
	if ui.cmdlistindex > 1 then
		ui.cmdlistindex = ui.cmdlistindex - 1
		ui.cmdstring = ui.cmdlist[ui.cmdlistindex]
	end
end

function states.game.cmdkeys.down()
	if ui.cmdlistindex < #ui.cmdlist then
		ui.cmdlistindex = ui.cmdlistindex + 1
		ui.cmdstring = ui.cmdlist[ui.cmdlistindex]
	end
end

function states.game.cmdkeys.other(key, unicode)
	if #key == 1 then
		ui.cmdstring = ui.cmdstring .. key
	end
end

function ui.drawlist(list, info)
	local dispos = math.max(0,#list-4)*150 * info.scrolly / info.maxscrolly
	for i,item in ipairs(list) do
		if i==info.selected then
			love.graphics.setColor(80,80,80)
		else
			love.graphics.setColor(25,25,25)
		end
		love.graphics.roundrect('fill', 20, 20 + i * 150 - 150 - dispos, 700, 120, 20, 20)
		love.graphics.setColor(255,255,255)
		if i==info.selected then
			love.graphics.setLineWidth(4)
		else
			love.graphics.setLineWidth(3)
		end
		love.graphics.roundrect('line', 20, 20 + i * 150 - 150 - dispos, 700, 120, 20, 20)
		--graphics.drawshape(graphics.vector[ships[ship].vector], 80, 20 + i * 150 - 150 + 60 - dispos, math.min(ships[ship].size, 15), 0) --?
		love.graphics.print(item.name, 140, 20 + i * 150 - 150 + 20)
		love.graphics.printf(item.description, 140, 40 + i * 150 - 150 + 20 - dispos, 700 - 120 - 20)
	end
	if #list > 4 then
		love.graphics.setColor(70,70,70)
		love.graphics.roundrect('fill', 780, 20, 15, 560, 5,5)
		love.graphics.roundrect('line', 780, 20, 15, 560, 5,5)
		if info.scrolling then
			love.graphics.setColor(255,255,255)
		else
			love.graphics.setColor(180,180,180)
		end
		love.graphics.roundrect('fill', 780, 20+info.scrolly, 15, 40, 5, 5)
		love.graphics.roundrect('line', 780, 20+info.scrolly, 15, 40, 5, 5)
	end
end

local ufuncs = {show=true, showcargo=true, showcargoindex=true, autopilot=true, showlanded=true, _landed = true, showmotion=true}
function ui.allowsave(key)
	return ufuncs[key]
end
