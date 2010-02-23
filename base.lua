base = {buyship = {scrolly = 0, maxscrolly = 520, scrolling = false}}
registerstate'base_mission'
registerstate'base_trade'
registerstate'base_buyship'
registerstate'base_talk'
registerstate'base_visit'

function base.load()
end

function base.update(dt)
	if state.current == 'base_buyship' then
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
		love.graphics.print('There is no mission available for you at the moment. Come back later.', 20, 20)
		love.graphics.print('(maybe next version ;)', 20, 40)
	elseif state.current == 'base_trade' then
		love.graphics.print('There is nothing to trade at the moment. Come back later.', 20, 20)
		love.graphics.print('(maybe next version ;)', 20, 40)
	elseif state.current == 'base_buyship' then
		local dispos = math.max(0,#player.landed.shipsselling-4)*150 * base.buyship.scrolly / base.buyship.maxscrolly
		for i,ship in ipairs(player.landed.shipsselling) do
			love.graphics.setColor(25,25,25)
			love.graphics.roundrect('fill', 20, 20 + i * 150 - 150 - dispos, 700, 120, 20, 20)
			love.graphics.setColor(255,255,255)
			love.graphics.setLineWidth(3)
			love.graphics.roundrect('line', 20, 20 + i * 150 - 150 - dispos, 700, 120, 20, 20)
			graphics.drawshape(graphics.vector[ship], 80, 20 + i * 150 - 150 + 60 - dispos, math.min(ships[ship].size, 15), 0)
			love.graphics.printf(ships[ship].description, 140, 20 + i * 150 - 150 + 20 - dispos, 700 - 120 - 20)
		end
		love.graphics.setColor(70,70,70)
		love.graphics.roundrect('fill', 780, 20, 15, 560, 5,5)
		love.graphics.roundrect('line', 780, 20, 15, 560, 5,5)
		love.graphics.setColor(200,200,200)
		love.graphics.roundrect('fill', 780, 20+base.buyship.scrolly, 15, 40, 5, 5)
		love.graphics.roundrect('line', 780, 20+base.buyship.scrolly, 15, 40, 5, 5)
	elseif state.current == 'base_talk' then
		love.graphics.print('There is no talking to do at the moment. Come back later.', 20, 20)
		love.graphics.print('(maybe next version ;)', 20, 40)
	elseif state.current == 'base_visit' then
		love.graphics.print('There is nothing to visit at the moment. Come back later.', 20, 20)
		love.graphics.print('(maybe next version ;)', 20, 40)
	end
end

function states.base_mission.keypressed.escape()
	state.current = 'base'
end
states.base_trade.keypressed.escape = states.base_mission.keypressed.escape
states.base_buyship.keypressed.escape = states.base_mission.keypressed.escape
states.base_talk.keypressed.escape = states.base_mission.keypressed.escape
states.base_visit.keypressed.escape = states.base_mission.keypressed.escape
