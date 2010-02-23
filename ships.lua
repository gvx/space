ships = {}

function ships.load()
	ships.beginner = {mass = 20, hull = 40, acc = 50, rot=1, revengine = 1, attack = 10, cargospace = 10, size = 20}
	ships.vessel = {mass = 100, hull = 170, acc = 15, rot=.7, revengine = 1, attack = 5, cargospace = 100, size = 30}
	ships.fighter = {mass = 15, hull = 40, acc = 50, rot=2, revengine = 2, attack = 70, cargospace = 5, size = 15}
	ships.bomber = {mass = 70, hull = 120, acc = 20, rot=.7, revengine = 1, attack = 120, cargospace = 10, size = 25}
	ships.speeder = {mass = 30, hull = 30, acc = 90, rot=2, revengine = 3, attack = 5, cargospace = 3, size = 20}
	ships.bettervessel = {mass = 105, hull = 180, acc = 10, rot=.7, revengine = 1, attack = 5, cargospace = 150, size = 35}
	ships.betterfighter = {mass = 20, hull = 45, acc = 55, rot=2.1, revengine = 2.1, attack = 100, cargospace = 1, size = 18}
	ships.betterbomber = {mass = 100, hull = 150, acc = 20, rot=.7, revengine = 1, attack = 200, cargospace = 15, size = 30}
	ships.betterspeeder = {mass = 25, hull = 25, acc = 110, rot=3, revengine = 5, attack = 3, cargospace = 1, size = 19}
	ships.supervessel = {mass = 125, hull = 190, acc = 15, rot=.8, revengine = 1.1, attack = 10, cargospace = 250, size = 40}
	ships.superfighter = {mass = 25, hull = 50, acc = 70, rot=2.5, revengine = 2.5, attack = 150, cargospace = 2, size = 19}
	ships.superbomber = {mass = 120, hull = 200, acc = 25, rot=.8, revengine = 1.1, attack = 400, cargospace = 10, size = 35}
	ships.superspeeder = {mass = 20, hull = 20, acc = 200, rot=5, revengine = 7, attack = 2, cargospace = 1, size = 18}
	ships.cyanoxspeeder = {mass = 30 , hull = 30, acc = 250, rot=1, revengine = 2, attack = 30, cargospace = 10, size = 30}
	ships.cyanoxbomber = {mass = 30 , hull = 30, acc = 50, rot=1, revengine = 2, attack = 30, cargospace = 10, size = 40}
	ships.cyanoxfighter = {mass = 30 , hull = 30, acc = 50, rot=1, revengine = 2, attack = 30, cargospace = 10, size = 30}
	ships.cyanoxscout = {mass = 30 , hull = 30, acc = 50, rot=1, revengine = 2, attack = 30, cargospace = 10, size = 30}
	
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
	ships.cyanoxspeeder.description = 'CyaNox\'s speeder\n\nWill probably replace the speeder.'
	ships.cyanoxbomber.description = 'CyaNox\'s bomber\n\nWill probably replace the bomber.'
	ships.cyanoxfighter.description = 'CyaNox\'s fighter\n\nWill probably replace the fighter.'
	ships.cyanoxscout.description = 'CyaNox\'s scout.'
	
	table.insert(map.objects, {type = 'ship', x = 0, y = 300, dx = 80, dy = 0, angle = 0, ship= 'fighter',fleet={}, targetx=800, targety=-400, nexttarget = function (self) return map.objects.blackhole.x, map.objects.blackhole.y end})
	table.insert(map.objects, {type = 'ship', x = -200, y = 300, dx = 100, dy = 0, angle = 0, ship= 'bomber', following = map.objects[#map.objects]})
	
	for k,v in pairs(ships) do
		if type(v) == 'table' and v.hull then
			table.insert(map.objects.hostilebase.shipsselling, k)
		end
	end
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
