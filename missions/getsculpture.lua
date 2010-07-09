return {
	id='getsculpture',
	name='Get sculpture from Bzadoria',
	commissionedby='a',
	description = [[
Hey, sport.

The Bzadorian Cultural Historic Museum has borrowed a classic sculpture from our empire. They would return it some time ago.

It is your job to go to the Bzadorian capital and request the sculpture back in time. If you don't manage to do so within time, our lose the sculpture under way...
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
				-- should probably show a message here somewhere
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
