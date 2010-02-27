mission = {}
registerstate'mission'
registerstate'mission_debrief'

function mission.load()
	mission.hadfirstmission = false
	mission.newmission = nil
	mission.mission = nil
	mission.list = {}
	for i,file in ipairs(love.filesystem.enumerate('missions')) do
		if file:sub(-4) == '.lua' then
			mission.list[file:sub(1,-5)] = love.filesystem.load('missions/'..file)()
		end
	end
end

function mission.update(dt)
	if not mission.hadfirstmission then
		mission.hadfirstmission = true
		mission.newmission = mission.list.first
		love.graphics.setFont(mediumfont)
		state.current = 'mission'
		return
	end
	if mission.mission then
		if mission.mission.checkcompleted() then
			mission.mission.completed = true
			love.graphics.setFont(mediumfont)
			state.current = 'mission_debrief'
		end
	end
end

function mission.missionupdate(dt)
end

function mission.missiondraw()
	love.graphics.setColor(255,255,255)
	love.graphics.printf(mission.newmission.description, 40, 50, 720)
	love.graphics.print(mission.newmission.canrefuse and 'Press Enter to accept or Escape to refuse.' or 'Press Enter or Escape to accept.', 40, 560)
end

function mission.mission_debriefdraw()
	love.graphics.setColor(255,255,255)
	love.graphics.printf(mission.mission.debrief, 40, 50, 720)
	love.graphics.print('Press Enter to continue.', 40, 560)
end


function states.mission.keypressed.escape()
	if not mission.newmission.canrefuse then
		mission.mission = mission.newmission
		if mission.mission.accept then
			mission.mission.accept()
		end
	elseif mission.newmission.refuse then
		mission.newmission.refuse()
	end
	mission.newmission = nil
	love.graphics.setFont(smallfont)
	state.current = 'game'
end

states.mission.keypressed['return'] = function()
	mission.mission = mission.newmission
	mission.newmission = nil
	love.graphics.setFont(smallfont)
	state.current = 'game'
	if mission.mission.accept then
		mission.mission.accept()
	end
end

states.mission_debrief.keypressed['return'] = function()
	mission.mission = nil
	love.graphics.setFont(smallfont)
	state.current = 'game'
end
