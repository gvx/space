diplomacy = {}
-- relation values range from -100 to 100
-- anything below -50 is enemy
-- anything below -20 is unstable
-- anything between -20 and 20 is neutral
-- anything above 20 is stable
-- anything above 50 is friendly

local abs = math.abs
function diplomacy.getplayerrelation(entity)
	local n = (mission.commissions[entity] or 0) * 100
	for k,v in pairs(diplomacy.relation) do
		if v[entity] then
			n = n + (mission.commissions[k] or 0) * v[entity]*abs(v[entity]) * .01
		end
	end
	for k,v in pairs(diplomacy.relation[entity]) do
		n = n + (mission.commissions[k] or 0) * v*abs(v) * .01
	end
	return n / mission.total
end

function diplomacy.getrelation(one, other)
	if one > other then one, other = other, one end
	return diplomacy.relation[one][other]
end

function diplomacy.load()
	diplomacy.relation = {}
	local r = diplomacy.relation
	r.a = {b = 70, c = -5, d = -80, spacecorp = 40, ar = -100, br = -40,
		cr = -5, dr = 10}
	r.b = {c = -90, d = 2, spacecorp = 30, ar = -35, br = -100, cr = 20,
		dr = 15}
	r.c = {d = 100, spacecorp = 55, ar = -45, br = 15, cr = -100, dr = -15}
	r.d = {spacecorp = 38, ar = -30, br = -35, cr = -60, dr = -100}
	r.ar = {spacecorp = 17, br = 35, cr = -25, dr = 15}
	r.br = {spacecorp = 60, cr = -10, dr = 10}
	r.cr = {spacecorp = 24, dr = 65}
	r.dr = {spacecorp = -90}
end

function diplomacy.update(dt)
end

function diplomacy.draw()
end

function diplomacy.allowsave(key)
	return key == 'relation'
end
