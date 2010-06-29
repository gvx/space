return {
	id='daredevil',
	name='Daredevil: living on the edge',
	commissionedby='spacecorp',
	description = [[
Hello!

Are you interested in doing something dangerous and XTREME? Are you interested in doing that for shiploads of money?

Seek no further! $spacecorp has a new reality show, in which contestants have to fly within the danger-zone of the black hole.

Accept this mission for the ride of your life! ($spacecorp is not responsible for injuries or death.)]],
	debrief = [[
Oh, you actually flew this close to the black hole?

I'm sorry we forgot to tell you, but the show's been cancelled. Something about being illegal. Can you imagine?

Anyway, here is your money.]],
	canrefuse=true,
	available = function()
		return player.rank < 4
	end,
	accept = function()
		--
	end,
	refuse = function()
	end,
	checkcompleted = function()
		if math.sqrt((player.x-map.objects.blackhole.x)^2+(player.y-map.objects.blackhole.y)^2) < map.objects.blackhole.radius then
			return true
		end
	end,
	completed = false,
}
