mission = {}
registerstate'mission'

function mission.load()
	mission.hadfirstmission = false
	mission.newmission = nil
	mission.mission = nil
end

function mission.update(dt)
	if not mission.hadfirstmission then
		mission.hadfirstmission = true
		mission.newmission = {id='firstmission', name='Your very first mission', owner='spacecorp', description= [[Hello, young spaceman. This is Guisseppe from SpaceCorp speaking. I have a mission for you.

You need to take some cargo to a neighbouring planet, called Ugumi. If you do so, you will be rewarded.

Note that you can't refuse this mission, nor accept any other mission before you complete this one.

Good luck.]], canrefuse=false}
		love.graphics.setFont(mediumfont)
		state.current = 'mission'
		return
	end
end

function mission.missionupdate(dt)
end

function mission.missiondraw()
	love.graphics.setColor(255,255,255)
	love.graphics.printf(mission.newmission.description, 40, 50, 720)
	love.graphics.print(mission.newmission.canrefuse and 'Press Enter to accept or Escape to refuse.' or 'Press Enter or Escape to accept.', 40, 560)
end

function states.mission.keypressed.escape()
	if not mission.newmission.canrefuse then
		mission.mission = mission.newmission
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
end
