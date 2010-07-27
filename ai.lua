ai = {}

function ai.load()
end

local sqrt, atan2, pi, pi2, abs, cos, sin = math.sqrt, math.atan2, math.pi, math.pi*2, math.abs, math.cos, math.sin
function ai.approach(ship, targetx, targety, dt)
	local d = sqrt((ship.x-targetx)^2 + (ship.y-targety)^2)
	local dirangle = atan2(targety-ship.y-ship.dy*3, targetx-ship.x-ship.dx*3)
	local movangle = atan2(ship.dy, ship.dx)
	local a = (ship.angle-dirangle)%pi2
	local a2 = (ship.angle-movangle)%pi2
	local rot = ship.ship.rot*dt
	local v = sqrt(ship.dx^2 + ship.dy^2)
	local time_needed_to_stop = v / ship.ship.acc
	local braking_distance = .5 * v^2 / ship.ship.acc
	local time_to_rotate = abs(pi - a2) / ship.ship.rot
	local maxspeed = ship.hyperspeed and 1600 or 800
	if d <= braking_distance + time_to_rotate * v * 2 then
		--slow down
		if a2 > pi+.2 then
			ship.angle = ship.angle - rot
		elseif a2 < pi-.2 then
			ship.angle = ship.angle + rot 
		elseif v > 50 then
			local acc = ship.ship.acc*dt * ship.ship.revengine
			ship.dx = ship.dx + acc*cos(ship.angle)
			ship.dy = ship.dy + acc*sin(ship.angle)
		end
	elseif v < maxspeed then
		--speed up
		if a > pi and a < pi2-.2 then
			ship.angle = ship.angle + rot
		elseif a < pi and a > .2 then
			ship.angle = ship.angle - rot 
		else
			local acc = ship.ship.acc*dt
			ship.dx = ship.dx + acc*cos(ship.angle)
			ship.dy = ship.dy + acc*sin(ship.angle)
		end
	end
	if d < 18000/ship.ship.acc then
		return true
	end
end

function ai.brake(ship, dt)
	local movangle = atan2(ship.dy, ship.dx)
	local a = (ship.angle-movangle)%pi2
	local rot = ship.ship.rot*dt
	if a > pi+.2 then
		ship.angle = ship.angle - rot
	elseif a < pi-.2 then
		ship.angle = ship.angle + rot 
	else
		local acc = ship.ship.acc*dt * ship.ship.revengine
		ship.dx = ship.dx + acc*cos(ship.angle)
		ship.dy = ship.dy + acc*sin(ship.angle)
	end
	return sqrt(ship.dx^2 + ship.dy^2) < 10
end

function ai.update(dt)
	for i, object in pairs(map.objects) do
		if object.type == 'ship' then
			if object.following then -- follower in a fleet
				local master = object.following
				-- check distance
				local d = sqrt((object.x-master.x)^2 + (object.y-master.y)^2)
				--local angle = atan2(object.y-master.y, object.x-master.x)
				local dirangle = atan2(master.y+master.dy-object.y-object.dy, master.x+master.dx-object.x-object.dx)
				--local acc = object.ship.acc*dt
				local a = (object.angle-dirangle)%pi2
				--local vangle = atan2(object.dy, object.dx)
				local rot = object.ship.rot*dt
				--local nextd = sqrt((object.x+object.dx-master.x-master.dx)^2 + (object.y+object.dy-master.y-master.dy)^2)
				--if d > 40 then 
				if a > pi and a < pi2-.2 then
					object.angle = object.angle + rot
				--	print(1,object.angle)
				elseif a < pi and a > .2 then
					object.angle = object.angle - rot 
					--print(-1,object.angle)
				else
					local v = sqrt(object.dx^2 + object.dy^2)
					if v < 800 then --a bit faster than master ships, to be able to catch up
						local acc = object.ship.acc*dt
						object.dx = object.dx + acc*cos(object.angle)
						object.dy = object.dy + acc*sin(object.angle)
					elseif v > 800 then -- cheat
						object.dx = object.dx*.99
						object.dy = object.dy*.99
						--turn?
					end
				end
				for i, buddy in ipairs(master.fleet) do
					if buddy ~= object then
						-- check distance
					end
				end
				
			else
				--??
				local d = sqrt((object.targetx-object.x)^2 + (object.targety-object.y)^2)
				--local targetangle = atan2(object.targety-object.y, object.targetx-object.x)
				local dirangle = atan2(object.targety-object.y-object.dy, object.targetx-object.x-object.dx)
				local a = (object.angle-dirangle)%pi2
				--
				local rot = object.ship.rot*dt
				if a > pi and a < pi2-.2 then
					object.angle = object.angle + rot 
				--	print(1,object.angle)
				elseif a < pi and a > .2 then
					object.angle = object.angle - rot 
					--print(-1,object.angle)
				else
					local v = sqrt(object.dx^2 + object.dy^2)
					local vangle = atan2(object.dy, object.dx)
					local va = (vangle-dirangle)%pi2
					if v < 800 then
						local acc = object.ship.acc*dt
						object.dx = object.dx + acc*cos(object.angle)
						object.dy = object.dy + acc*sin(object.angle)
					elseif v > 800 then -- cheat
						object.dx = object.dx*.99
						object.dy = object.dy*.99
						--turn?
					elseif va > pi and va < pi2-.2 then --how the fuck am i going to do this
					
					end
				end
				if d < 200 then
					if object.nexttarget then
						object.targetx, object.targety = object:nexttarget()
					else
						--idle
					end
				end
			end
			object.x = object.x + object.dx * dt
			object.y = object.y + object.dy * dt
			--object.angle = atan2(object.dy, object.dx)
		end
	end
end

function ai.draw()
end

function ai.allowsave()
	return false --that's easy
end
