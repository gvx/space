base = {buyship = {scrolly = 0, maxscrolly = 520, scrolling = false}, mission = {}, trade = {}, talk = {}, visit = {}}
registerstate'base_mission'
registerstate'base_trade'
registerstate'base_buyship'
registerstate'base_talk'
registerstate'base_visit'

function base.load()
end

function base.update(dt)
	if state.current == 'base_mission' then
	elseif state.current == 'base_buyship' then
		local x, y = love.mouse.getPosition()
		if love.mouse.isDown'l' then
			if x >= 780 and x <= 790 then
				base.buyship.scrolling = true
			end
		else
			base.buyship.scrolling = false
		end
		if base.buyship.scrolling  then
			if y >= 20 and y <= 580 then
				base.buyship.scrolly = math.max(math.min(y - 40, base.buyship.maxscrolly), 0)
			end
		end
	end
end

function base.draw()
	if state.current == 'base_mission' then
		ui.drawlist(base.mission.displist, base.mission.info)
	elseif state.current == 'base_trade' then
		love.graphics.print('There is nothing to trade at the moment. Come back later.', 20, 20)
		love.graphics.print('(maybe next version ;)', 20, 40)
	elseif state.current == 'base_buyship' then
		ui.drawlist(base.buyship.displist, base.buyship)
	elseif state.current == 'base_talk' then
		love.graphics.print('There is no talking to do at the moment. Come back later.', 20, 20)
		love.graphics.print('(maybe next version ;)', 20, 40)
	elseif state.current == 'base_visit' then
		love.graphics.print('There is nothing to visit at the moment. Come back later.', 20, 20)
		love.graphics.print('(maybe next version ;)', 20, 40)
	end
end

function base.mission.init()
	base.mission.list = {}
	local l = base.mission.list
	for k,v in pairs(mission.list) do
		if not v.completed and v.available() then
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
	base.mission.displist = {}
	local dl = base.mission.displist
	for i=1,#l do
		table.insert(dl, {name = officialnames[l[i].commissionedby], description = l[i].name})
	end
	base.mission.info = {scrolly = 0, maxscrolly = 520}
end

function base.buyship.init()
	local dl = {}
	base.buyship.displist = dl
	for i, v in ipairs(player.landed.shipsselling) do
		table.insert(dl, {name = '', description = ships[v].description})
	end
end

function states.base_mission.keypressed.escape()
	state.current = 'base'
end
function states.base_mission.keypressed.enter()
	if not mission.mission or mission.mission.canrefuse then
		mission.newmission = base.mission.list[1]
		love.graphics.setFont(mediumfont)
		state.current = 'mission'
	end
end
states.base_trade.keypressed.escape = states.base_mission.keypressed.escape
states.base_buyship.keypressed.escape = states.base_mission.keypressed.escape
states.base_talk.keypressed.escape = states.base_mission.keypressed.escape
states.base_visit.keypressed.escape = states.base_mission.keypressed.escape
