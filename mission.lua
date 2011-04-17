mission = {}
registerstate'mission'
registerstate'mission_debrief'
registerstate'mission_screen'

function mission.load()
	mission.hadfirstmission = false
	mission.newmission = nil
	mission.mission = nil
	mission.animx = 0
	mission.list = {}
	mission.commissions = {a = 1}
	mission.total = 1
	for i,file in ipairs(love.filesystem.enumerate('missions')) do
		if file:sub(-4) == '.lua' then
			local t = love.filesystem.load('missions/'..file)()
			mission.list[file:sub(1,-5)] = t
			t.description = printf(t.description, officialnames)
			t.debrief = printf(t.debrief, officialnames)
		end
	end
end

function mission.update(dt)
	if not mission.hadfirstmission then
		mission.hadfirstmission = true
		mission.newmission = mission.list.first
		love.graphics.setFont(mediumfont)
		mission.text = mission.newmission.description
		mission.tagline = mission.newmission.canrefuse and 'Press Enter to accept or Escape to refuse.' or 'Press Enter or Escape to accept.'
		mission.closescreen = mission.close_mission
		state.current = 'mission'
		return
	end
	if mission.mission then
		if mission.mission.checkcompleted() then
			mission.mission.completed = true
			local by = mission.mission.commissionedby
			mission.commissions[by] = mission.commissions[by] or 0 + 1
			mission.total = mission.total + 1
			love.graphics.setFont(mediumfont)
			mission.animx = 0
			mission.text = mission.mission.debrief
			mission.tagline = 'Press Enter to continue'
			mission.closescreen = mission.close_debrief
			state.current = 'mission_debrief'
		end
	end
end

function mission.close_mission()
	if mission.accepting then
		mission.mission = mission.newmission
		if mission.mission.accept then
			mission.mission.accept()
		end
	elseif mission.newmission.refuse then
		mission.newmission.refuse()
	end
	mission.newmission = nil
end

function mission.close_debrief()
	mission.mission = nil
end

function mission.close_screen()
end

function mission.updatescreen(dt)
	if not mission.finishedanim then
		mission.animx = mission.animx + dt*2
		if mission.animx > .5 then
			mission.finishedanim = true
		end
	end
	if mission.closing then
		mission.animx = mission.animx + dt*6
		if mission.animx > 2.55 then
			mission.animx = 0
			mission.finishedanim = nil
			love.graphics.setFont(smallfont)
			state.current = 'game'
			mission.closing = false
			mission.closescreen()
		end
	end
end

function mission.drawscreen()
	love.graphics.setColor(255,255,255)
	love.graphics.printf(mission.text, 40, 32, 720)
	love.graphics.print(mission.tagline, 40, 542)
	love.graphics.setColor(255,255,255,mission.animx*100)
	love.graphics.rectangle('fill', 0, 535, 800, 40)
end

function states.mission.keypressed.escape()
	mission.accepting = not mission.newmission.canrefuse
	mission.closing = true
end

function states.mission.keypressed.enter()
	mission.accepting = true
	mission.closing = true
end

function states.mission_debrief.keypressed.enter()
	mission.closing = true
end

function states.mission_screen.keypressed.enter()
	mission.closing = true
end

local mfuncs = {load=true, update=true, close_mission=true, close_debrief=true,
	close_screen=true, updatescreen=true, drawscreen=true, allowsave=true,
	mission=true, mission_debrief=true, mission_screen=true}
function mission.allowsave(key)
	return not mfuncs[key]
end
