return {
	id='getsculpture',
	name='Get sculpture from Bzadoria',
	commissionedby='a',
	description = [[
Hey, sport.

The $b$n Cultural Historic Museum has borrowed a classic sculpture from our empire. They would return it some time ago.

It is your job to go to the $b$n capital and request the sculpture back in time. If you don't manage to do so within time, our lose the sculpture under way...
]],
	debrief = [[
<cheesy remark>
<mentioning of reward>
]],
	canrefuse=true,
	available = function()
		return state.totaltime < 36000 and player.landed.owner == 'a'
	end,
	accept = function()
		mission.mission.i = hook.add('visitbase', function()
			if not mission.mission or mission.mission.id ~= 'getsculpture' then
				return table.remove(hook.hooks.visitbase, mission.list.enemysoil.i)
			end
			if player.landed == map.objects.friendbase then
				table.insert(player.ship.cargo, 'sculpture')
				table.remove(hook.hooks.visitbase, mission.mission.i)
				love.graphics.setFont(mediumfont)
				mission.animx = 0
				mission.text = 'Here is the sculpture. Go bring it to your capital.'
				mission.tagline = 'Press Enter to continue'
				mission.closescreen = mission.close_screen
				state.current = 'mission_screen'
			end
		end)
	end,
	checkcompleted = function()
		if player.landed == map.objects.homebase then
			for i=1,#player.ship.cargo do
				if player.ship.cargo[i] == 'sculpture' then
					table.remove(player.ship.cargo, i)
					return true
				end
			end
			-- oh, shit, lost sculpture!
		end
	end,
	completed = false,
}
