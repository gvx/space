map = {}

function map.load()
	map.new()
end

function sectortopixels(s)
	return s*200
end

function map.new()
	map.objects = {}
	--first, we define four sectors: own, friendly, neutral and hostile
	--they are supposed to be dynamic when the game's finished, but this is just for the setup
	--[[local ownx, owny = 0, 0
	local friendlyx, friendlyy
	local neutralx, neutraly
	local hostilex, hostiley
	repeat
		friendlyx = math.random(-70, 70)
		friendlyy = math.random(-70, 70)
	until math.sqrt((friendlyx-ownx)^2 + (friendlyy-owny)^2) > 20 + math.random(5)
	repeat
		neutralx = math.random(-100, 100)
		neutraly = math.random(-100, 100)
	until (math.sqrt((neutralx-ownx)^2 + (neutraly-owny)^2) > 50 + math.random(10) and
	       math.sqrt((neutralx-friendlyx)^2 + (neutraly-friendlyy)^2) > 60)
	repeat
		hostilex = math.random(-200, 200)
		hostiley = math.random(-200, 200)
	until (math.sqrt((hostilex-ownx)^2 + (hostiley-owny)^2) > 100 + math.random(30) and
	       math.sqrt((hostilex-friendlyx)^2 + (hostiley-friendlyy)^2) > 80 and
	       math.sqrt((hostilex-neutralx)^2 + (hostiley-neutraly)^2) > 80)]]

	local s2p = sectortopixels
	map.objects.homebase = {type='base', owner='a', x = s2p(-200), y = s2p(-200), radius = 300, landingstripangle = 0--[[math.random()*2*math.pi]], name='Amania capital', shipsselling = {'speeder', 'fighter'}, products = {rock = 16, pizza = 5}}
	table.insert(map.objects, {type='planet', x = s2p(-205), y = s2p(-190), radius = 200, })
	table.insert(map.objects, {type='base', owner='a', x = s2p(-188), y = s2p(-203), radius = 250, landingstripangle = math.random()*2*math.pi, name='Ugumi', shipsselling = {}, products = {altdollar = 318, pizza = 4}})
	map.objects.friendbase = {type='base', owner='b', x = s2p(200), y = s2p(-200), radius = 300, landingstripangle = math.random()*2*math.pi, name='Bzadoria capital', shipsselling = {'speeder', 'fighter', 'fighter', 'beginner', 'fighter', 'speeder'}, products = {rock = 409}}
	map.objects.neutralbase = {type='base', owner='c', x = s2p(-200), y = s2p(200), radius = 300, landingstripangle = math.random()*2*math.pi, name='Cadadonia capital', shipsselling = {'speeder', 'fighter'}, products = {}}
	map.objects.hostilebase = {type='base', owner='d', x = s2p(200), y = s2p(200), radius = 300, landingstripangle = math.random()*2*math.pi, name='Darzamin capital', shipsselling = {}, products = {}}
	map.objects.blackhole = {type='black hole', x = 0, y = 0, radius = 7000}
	map.objectreserve = {
		package = {type='special', name='A curious package', description='A simple package, contents unknown.', weight=1},
		sculpture = {type='special', name='A classic sculpture', description="You usually don't care for art, but the nudity makes it all worthwhile.", weight=5},
		loot = {type='special', name='You are afraid to see what it is', description="Don't look. Just deliver it and shut up about it.", weight=3},
		altdollar = {type='currency', name='Altairian dollars', description="It's money, but not worth much. It might lighten you up if you get the reference, though.", weight=1},
		rock = {type='normal', name='Rocks', description='Just rocks. Heavy rocks.', weight=5},
		pizza = {type='normal', name='Pizza', description='Mmm. Pizza.', weight=1},
	}
	local r = {}
	local r_mt = {__index= function () return r end }
	
	local function make_raster()
		map.raster = {}

		for k,v in pairs(map.objects) do
			if v.type == 'planet' or v.type == 'base' then
				local X = math.floor(v.x*.001)
				local Y = math.floor(v.y*.001)
				if not map.raster[X] then
					map.raster[X] = setmetatable({}, r_mt)
				end
				if not rawget(map.raster[X], Y) then
					map.raster[X][Y] = {}
				end
				table.insert(map.raster[X][Y], v)
			end
		end

		setmetatable(map.raster, r_mt)
	end

	hook.add('load_game', make_raster)
	make_raster()
end

function map.update(dt)
end

function map.draw()
end

local mfuncs = {load=true, new=true, update=true, draw=true, allowsave=true, raster=true}
function map.allowsave(key)
	return not mfuncs[key]
end
