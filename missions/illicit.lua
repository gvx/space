return {
	id='illicit',
	name='Get the package',
	commissionedby='a',
	description = [[
Hey, fella. I heard you were looking for a job? Well, look no further. I need you to get a... thing from the $b$n capital.

Now, this is off the books, right? I trust you to not tell anybody about this.

If you succeed, you might be looking at a promotion some time soon.
]],
	debrief = [[
Very well. Just remember: I was not involved here. This mission never even existed.
]],
	canrefuse=true,
	available = function()
		return player.rank < 2 and player.landed.owner == 'a'
	end,
	accept = function()
		mission.mission.i = hook.add('visitbase', function()
			if not mission.mission or mission.mission.id ~= 'illicit' then
				return table.remove(hook.hooks.visitbase, mission.list.illicit.i)
			end
			if player.landed == map.objects.friendbase then
				table.insert(player.ship.cargo, 'loot')
				table.remove(hook.hooks.visitbase, mission.mission.i)
				love.graphics.setFont(mediumfont)
				mission.animx = 0
				mission.text = 'You manage to seize the package and flee'
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
