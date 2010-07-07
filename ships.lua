ships = {}

function ships.load()
	ships.beginner = {mass = 20, hull = 40, acc = 50, rot=1, revengine = 1, attack = 10, cargospace = 10, size = 20, vector = 'beginner'}
	ships.vessel = {mass = 100, hull = 170, acc = 15, rot=.7, revengine = 1, attack = 5, cargospace = 100, size = 30, vector = 'vessel'}
	ships.fighter = {mass = 15, hull = 40, acc = 50, rot=2, revengine = 2, attack = 70, cargospace = 5, size = 60, vector = 'medium_fighter'}
	ships.bomber = {mass = 70, hull = 120, acc = 20, rot=.7, revengine = 1, attack = 120, cargospace = 10, size = 80, vector = 'light_bomber'}
	ships.speeder = {mass = 30, hull = 30, acc = 90, rot=2, revengine = 3, attack = 5, cargospace = 3, size = 70, vector = 'speeder'}
	ships.bettervessel = {mass = 105, hull = 180, acc = 10, rot=.7, revengine = 1, attack = 5, cargospace = 150, size = 35, vector = 'vessel'}
	ships.betterfighter = {mass = 20, hull = 45, acc = 55, rot=2.1, revengine = 2.1, attack = 100, cargospace = 1, size = 18, vector = 'medium_fighter'}
	ships.betterbomber = {mass = 100, hull = 150, acc = 20, rot=.7, revengine = 1, attack = 200, cargospace = 15, size = 30, vector = 'light_bomber'}
	ships.betterspeeder = {mass = 25, hull = 25, acc = 110, rot=3, revengine = 5, attack = 3, cargospace = 1, size = 65, vector = 'speeder'}
	ships.supervessel = {mass = 125, hull = 190, acc = 15, rot=.8, revengine = 1.1, attack = 10, cargospace = 250, size = 40, vector = 'vessel'}
	ships.superfighter = {mass = 25, hull = 50, acc = 70, rot=2.5, revengine = 2.5, attack = 150, cargospace = 2, size = 19, vector = 'medium_fighter'}
	ships.superbomber = {mass = 120, hull = 200, acc = 25, rot=.8, revengine = 1.1, attack = 400, cargospace = 10, size = 35, vector = 'light_bomber'}
	ships.superspeeder = {mass = 20, hull = 20, acc = 200, rot=5, revengine = 7, attack = 2, cargospace = 1, size = 60, vector = 'speeder'}
	
	ships.beginner.description = 'Beginners\' ship.\n\nA smallish ship. Not very noteworthy.'
	ships.vessel.description = 'Vessel\n\nA large spaceship, with plenty of cargo space. Not very fast, and practically defenceless in battle.'
	ships.fighter.description = 'Fighter\n\nA smallish ship. It is pretty useful for attacking and quick maneuvering.'
	ships.bomber.description = 'Bomber\n\nLarge, slow, but very powerful.'
	ships.speeder.description = 'Speeder\n\nFast, agile. Very useful for quick getaways -- or approaching deadlines.'
	ships.bettervessel.description = 'Better vessel\n\nA very large spaceship, with plenty of cargo space. Quite slow, and practically defenceless in battle.'
	ships.betterfighter.description = 'Better fighter\n\nA smallish ship. It is rather useful for attacking and quick maneuvering.'
	ships.betterbomber.description = 'Better bomber\n\nLarge, very slow, but very powerful.'
	ships.betterspeeder.description = 'Better speeder\n\nVery fast, agile and nimble. Useful for quick getaways -- or outmaneuvering approaching black holes.'
	ships.supervessel.description = 'Super vessel\n\nA very large spaceship, with a huge amount of cargo space. A bit slow, and hard to defend in battle.'
	ships.superfighter.description = 'Super fighter\n\nA smallish ship. It is the best you can get for attacking and quick maneuvering.'
	ships.superbomber.description = 'Super bomber\n\nVery large, very slow, but near undefeatable.'
	ships.superspeeder.description = 'Super speeder\n\nVery fast, agile and quite nimble. Useful to lose anyone tailing you -- or outmaneuvering black holes too close for comfort.'
	
	local s2p = sectortopixels
	table.insert(map.objects, {type = 'ship', x = s2p(-200), y = s2p(-200)+300, dx = 80, dy = 0, angle = 0, ship= newship'fighter',fleet={}, targetx=s2p(-200)+800, targety=s2p(-200)-400, nexttarget = function (self) return map.objects.blackhole.x, map.objects.blackhole.y end})
	table.insert(map.objects, {type = 'ship', x = s2p(-200)-200, y = s2p(-200)+300, dx = 100, dy = 0, angle = 0, ship= newship'bomber', following = map.objects[#map.objects]})
	
	for k,v in pairs(ships) do
		if type(v) == 'table' and v.hull then
			table.insert(map.objects.hostilebase.shipsselling, k)
		end
	end
end

function newship(ship)
	local s = {}
	for k,v in pairs(ships[ship]) do
		s[k] = v
	end
	s.cargo = {}
	s.name = ship
	return s
end

function ships.update(dt)
	for i, obj in pairs(map.objects) do
		if obj.type == 'ship' and obj.remove then
			map.objects[i] = nil
		end
	end
end

function ships.draw()
end
