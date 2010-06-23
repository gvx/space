diplomacy = {}
-- relation values range from -100 to 100
-- anything below -50 is enemy
-- anything below -20 is unstable
-- anything between -20 and 20 is neutral
-- anything above 20 is stable
-- anything above 50 is friendly

function diplomacy.getrelation(one, other)
	return diplomacy.relation[one][other]
end

function diplomacy.load()
	diplomacy.relation = {}
	local r = diplomacy.relation
	r.player = {friend = 70, neutral = -5, enemy = -80, spacecorp = 40}
	r.friend = {neutral = -90, enemy = 2, spacecorp = 30}
	r.neutral = {enemy = 60, spacecorp = 55}
	r.enemy = {spacecorp = 38}
end

function diplomacy.update(dt)
end

function diplomacy.draw()
end
