return {
	id='diplomacy',
	name='Broker a ceasefire',
	commissionedby='b',
	description = [[
The tensions between $b and $c are rising. If we do not resolve this, it might be the end of both empires. We would like to see a ceasefire with $c. Unfortunately, their fleet has orders to shoot any of our ships on sight. We cannot send a diplomatic delegate that way.

You have a good standing with both empires. If you would go in our stead, we would be much obliged.
]],
	debrief = [[
]],
	canrefuse=true,
	available = function()
		return -- player must be on good standing with b and c, b and c must be at war...
	end,
	accept = function()
	end,
	refuse = function()
	end,
	checkcompleted = function() -- I'll think of something
	end,
	completed = false,
}
