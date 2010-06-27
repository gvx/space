return {
	id='firstmission',
	name='Your very first mission',
	commissionedby='spacecorp',
	description = [[
Hello, young spaceman. This is Guisseppe from SpaceCorp speaking. I have a mission for you.

You need to take some cargo to a neighbouring planet, called Ugumi. If you do so, you will be rewarded.

Note that you can't refuse this mission, nor accept any other mission before you complete this one.

Good luck.]],
	debrief = [[
Hello, young spaceman. This is Guiseppe from SpaceCorp again.

I want to thank you for delivering that cargo.

If you ever want to work for SpaceCorp again, just land on a planet where SpaceCorp has a division (which is nearly any planet you can find) and take on a mission there.

Of course other parties have missions for you to pick from as well, but they won't pay as much as we.

Have fun.]],
	canrefuse=false,
	available = function()
		return not mission.hadfirstmission
	end,
	accept = function()
		--put some cargo in player ship
		table.insert(player.ship.cargo, 'package')
	end,
	refuse = nil, --this one can't be refused
	checkcompleted = function()
		if player.landed and player.landed.name == 'Ugumi' then
			for i=1,#player.ship.cargo do
				if player.ship.cargo[i] == 'package' then
					table.remove(player.ship.cargo, i)
					break
				end
			end
			return true
		end
	end,
	completed = false,
}
