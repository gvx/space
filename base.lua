base = {buyship = {}, mission = {}, trade = {}, talk = {}, visit = {}, info = {scrolly = 0, maxscrolly = 520}}
registerstate'base_mission'
registerstate'base_trade'
registerstate'base_buyship'
registerstate'base_talk'
registerstate'base_visit'

function base.load()
end

function base.update(dt)
	local x, y = love.mouse.getPosition()
	local mouseDown = love.mouse.isDown'l'
	if mouseDown then
		if x >= 780 and x <= 790 then
			base.info.scrolling = true
		end
	else
		base.info.scrolling = false
	end
	if base.info.scrolling  then
		if y >= 20 and y <= 580 then
			base.info.scrolly = math.max(math.min(y - 40, base.info.maxscrolly), 0)
		end
	end
	base.info.selected = nil
	if x > 20 and x < 720 then
		local sy = y + math.max(0,#base.displist-4)*150 * base.info.scrolly / base.info.maxscrolly
		if (sy-20) % 150 < 120 then
			base.info.selected = math.ceil(sy / 150)
			if mouseDown then
				base.info.activate(base.info.selected)
			end
		end
	end
end

function base.draw()
	if state.current == 'base_trade' then
		love.graphics.print('There is nothing to trade at the moment. Come back later.', 20, 20)
		love.graphics.print('(maybe next version ;)', 20, 40)
	elseif state.current == 'base_talk' then
		love.graphics.print('There is no talking to do at the moment. Come back later.', 20, 20)
		love.graphics.print('(maybe next version ;)', 20, 40)
	elseif state.current == 'base_visit' then
		love.graphics.print('There is nothing to visit at the moment. Come back later.', 20, 20)
		love.graphics.print('(maybe next version ;)', 20, 40)
	else
		ui.drawlist(base.displist, base.info)
	end
end

function base.mission.activate(i)
	if not mission.mission or mission.mission.canrefuse and #base.mission.list > 0 then
		mission.newmission = base.mission.list[i]
		love.graphics.setFont(mediumfont)
		state.current = 'mission'
	end
end

function base.mission.init()
	base.mission.list = {}
	local l = base.mission.list
	for k,v in pairs(mission.list) do
		if not v.completed and v.available() and v ~= mission.mission then
			v.randomid = math.random() --used for sorting
			table.insert(l, v)
		end
	end
	if #l > 10 then
		table.sort(l, function(a,b) return a.randomid < b.randomid end)
		for i=#l,11,-1 do
			l[i] = nil
		end
	end
	base.displist = {}
	local dl = base.displist
	for i=1,#l do
		table.insert(dl, {name = officialnames[l[i].commissionedby], description = l[i].name})
	end
	base.info.scrolly = 0
	base.info.activate = base.mission.activate
end

function base.buyship.activate()
	-- buy a ship, yes pretty useless at this point
end

function base.buyship.init()
	local dl = {}
	base.displist = dl
	for i, v in ipairs(player.landed.shipsselling) do
		table.insert(dl, {name = '', description = ships[v].description})
	end
	base.info.scrolly = 0
	base.info.activate = base.buyship.activate
end

function states.base_mission.keypressed.escape()
	state.current = 'base'
end
function states.base_mission.keypressed.enter()
	if not mission.mission or mission.mission.canrefuse and #base.mission.list > 0 then
		mission.newmission = base.mission.list[1]
		love.graphics.setFont(mediumfont)
		state.current = 'mission'
	end
end
states.base_mission.keypressed['1'] = states.base_mission.keypressed.enter
states.base_mission.keypressed['2'] = function ()
	if not mission.mission or mission.mission.canrefuse and #base.mission.list > 2 then
		mission.newmission = base.mission.list[2]
		love.graphics.setFont(mediumfont)
		state.current = 'mission'
	end
end
states.base_mission.keypressed['3'] = function ()
	if not mission.mission or mission.mission.canrefuse and #base.mission.list > 3 then
		mission.newmission = base.mission.list[3]
		love.graphics.setFont(mediumfont)
		state.current = 'mission'
	end
end

states.base_trade.keypressed.escape = states.base_mission.keypressed.escape
states.base_buyship.keypressed.escape = states.base_mission.keypressed.escape
states.base_talk.keypressed.escape = states.base_mission.keypressed.escape
states.base_visit.keypressed.escape = states.base_mission.keypressed.escape
