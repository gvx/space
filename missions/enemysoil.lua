return {
	id='enemysoil',
	name='Land on enemy soil',
	commissionedby='a',
	description = [[
Soldier, you are expected to land on enemy soil. <Blabla>
]],
	debrief = [[
Congrats, you made it.
]],
	canrefuse=true,
	available = function()
		return player.rank < 3 and player.landed.owner == 'a'
	end,
	accept = function()
		mission.mission.i = hook.add('visitbase', function()
			if not mission.mission or mission.mission.id ~= 'enemysoil' then
				return table.remove(hook.hooks.visitbase, mission.list.enemysoil.i)
			end
			if player.landed.owner == 'd' then
				mission.mission.completed = true
				table.remove(hook.hooks.visitbase, mission.mission.i)
				mission.update()
			end
		end)
	end,
	checkcompleted = function()
		return mission.mission.completed -- cheap trick
	end,
	completed = false,
}
