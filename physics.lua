physics = {}

function physics.load()
end

local p2 = 2*math.pi
local p = math.pi
local sqrt, atan2, cos, sin, abs = math.sqrt, math.atan2, math.cos, math.sin, math.abs
function gravitate(ship, dt)
	ship.spaghetti_amount = false
	for i,object in pairs(map.objects) do
		if object.type == 'base' or object.type == 'planet' then
			local d = sqrt((object.x-ship.x)^2 + (object.y-ship.y)^2)
			if d < 500 then
				local a = 100*object.radius*object.radius/d/d
				local angle = atan2(ship.y-object.y, ship.x-object.x)
				if (d < object.radius + ship.ship.size + 60 and
				   object.landingstripangle and
				   abs(p-(object.landingstripangle - angle)%p2) > p-.2) then
					local r = object.radius + ship.ship.size + 60
					local ship_x = object.x + r*cos(angle)
					local ship_y = object.y + r*sin(angle)
					--ship.dx = ship.dx + (ship_x - ship.x)*dt
					--ship.dy = ship.dy + (ship_y - ship.y)*dt
					ship.x = ship_x
					ship.y = ship_y
					ship.dx = ship.dx * .1^dt
					ship.dy = ship.dy * .1^dt
					if ship == player then
						player.landed = object
					end
				elseif d < object.radius + ship.ship.size then
					local r = object.radius + ship.ship.size
					local ship_x = object.x + r*cos(angle)
					local ship_y = object.y + r*sin(angle)
					--ship.dx = ship.dx + (ship_x - ship.x)*dt
					--ship.dy = ship.dy + (ship_y - ship.y)*dt
					ship.x = ship_x
					ship.y = ship_y
					ship.dx = ship.dx * .5^dt
					ship.dy = ship.dy * .5^dt
				else
					ship.dx = ship.dx - a*cos(angle)*dt
					ship.dy = ship.dy - a*sin(angle)*dt
				end
			end
		elseif object.type == 'black hole' then
			local d = sqrt((object.x-ship.x)^2 + (object.y-ship.y)^2)
			if d < 200 then
				--remove ship
				ship.remove = true
			elseif d < object.radius*3 then
				local a = 150*object.radius*object.radius/d/d
				local angle = atan2(ship.y-object.y, ship.x-object.x)
				ship.dx = ship.dx - a*cos(angle)*dt
				ship.dy = ship.dy - a*sin(angle)*dt
				if ship==player then state.shaking = object.radius*10/d end
				if d < object.radius then
					ship.spaghetti_angle = angle --not worky :(
					ship.spaghetti_amount = object.radius/d
				end
			end
		end
	end
end

function physics.update(dt)
	state.shaking = false
	player.landed = false
	gravitate(player, dt)
	for i,object in pairs(map.objects) do
		if object.type == 'ship' then
			gravitate(object, dt)
		end
	end
end

function physics.draw()
end
