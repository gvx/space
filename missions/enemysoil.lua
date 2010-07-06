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
		local i
		hook.add('enterbase', function()
			if player.landed.owner == 'd' then
				mission.mission.completed = true
				table.remove(hook.hooks.enterbase, i)
			end
		end)
		i = #hook.hooks.enterbase
	end,
	checkcompleted = function()
		return mission.mission.completed -- cheap trick
	end,
	completed = false,
}
