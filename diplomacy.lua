diplomacy = {}
-- relation values range from -100 to 100
-- anything below -50 is enemy
-- anything below -20 is unstable
-- anything between -20 and 20 is neutral
-- anything above 20 is stable
-- anything above 50 is friendly

function diplomacy.getplayerrelation(entity)
	local n = mission.credit[entity]
	for k,v in pairs(diplomacy.relation) do
		if v[entity] then
			n = n + mission.credit[k] * v[entity]^2 / 100
		end
	end
	for k,v in pairs(diplomacy.relation[entity]) do
		n = n + mission.credit[k] * v^2 / 100
	end
	return n
end

function diplomacy.getrelation(one, other)
	if one > other then one, other = other, one end
	return diplomacy.relation[one][other]
end

function diplomacy.load()
	diplomacy.relation = {}
	local r = diplomacy.relation
	r.a = {b = 70, c = -5, d = -80, spacecorp = 40}
	r.b = {c = -90, d = 2, spacecorp = 30}
	r.c = {d = 60, spacecorp = 55}
	r.d = {spacecorp = 38}
end

function diplomacy.update(dt)
end

function diplomacy.draw()
end
