return {
	id='crushrebellion',
	name='Crush the rebellion',
	commissionedby='b',
	description = [[
Those $br keep pestering us. They have recently attacked another outpost. You understand it can't go on like this. These barbarian rebels need to be crushed.

That looks like a job for... you!

Of course, there is a reward. Not only an improved reputation with our government, but also a reasonable amount of monetary assets. It looks like you could use some improvement for your ships.
]],
	altdescription = [[
You have nowhere to go. You have two choices: getting defeated by our forces, or joining our cause by destroying a small $b$n outpost nearby. We can't do anything about it ourselves, because they'd ask for backup as soon as they would spot us. But they wouldn't expect you to do something like that.

So what do you say? Which fate do you prefer? Do you accept our offer or not?
]]
	debrief = [[
Thank you for exterminating those pests. Here is your reward. 
]],
	altdebrief = [[
Thank you for helping us oppose those evil oppressors. We have not much to reward you with, but you can always count on us if you're in trouble, on account of $b or otherwise.
]]
	canrefuse=true,
	available = function()
		return player.rank > 2 and player.rank < 6
	end,
	accept = function()
		-- this gets wrapped in a giant 'if', of course
		-- or a hook or something
		local m = mission.mission
		mission.newmission = m
		mission.text = m.altdescription
		mission.tagline = 'Press Enter to accept or Escape to refuse'
		mission.closescreen = function ()
			if mission.accepting then
				m.commissionedby = 'br'
				m.name = 'Destroy outpost'
				m.debrief = m.altdebrief
			end
		end
		love.graphics.setFont(mediumfont)
		state.current = 'mission'
	end,
	checkcompleted = function()
	end,
	completed = false,
}
