return {
	id='diplomacy',
	name='Broker a ceasefire',
	commissionedby='b',
	description = [[
The tensions between $b and $c are rising. If we do not resolve this, it might be the end of both empires. We would like to see a ceasefire with $c. Unfortunately, their fleet has orders to shoot any of our ships on sight. We cannot send a diplomatic delegate that way.

You have a good standing with both empires. If you would go in our stead, we would be much obliged.
]],
	debrief = [[
Thank you, for preventing further escalation between $b and $c. Please accept some of the money which would have been used to support the war otherwise.
]],
	canrefuse=true,
	available = function()
		-- player must be on good standing with b and c, b and c must be at war...
		return diplomacy.getplayerrelation'b' > 15 and diplomacy.getplayerrelation'c' > 15 and diplomacy.getrelation('b', 'c') < -50
	end,
	accept = function()
	end,
	refuse = function()
	end,
	checkcompleted = function() -- I'll think of something
	end,
	completed = false,
}
