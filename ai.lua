ai = {}

function ai.load()
end

function ai.approach(ship, targetx, targety, dt)
	local d = math.sqrt((ship.x-targetx)^2 + (ship.y-targety)^2)
	local dirangle = math.atan2(targety-ship.y-ship.dy, targetx+ship.x-ship.dx)
	local a = (object.angle-dirangle)%(2*math.pi)
	local rot = ships[ship.ship].rot*dt
	local v = math.sqrt(ship.dx^2 + ship.dy^2)
end

function ai.update(dt)
	for i, object in pairs(map.objects) do
		if object.type == 'ship' then
			if object.following then -- follower in a fleet
				local master = object.following
				-- check distance
				local d = math.sqrt((object.x-master.x)^2 + (object.y-master.y)^2)
				--local angle = math.atan2(object.y-master.y, object.x-master.x)
				local dirangle = math.atan2(master.y+master.dy-object.y-object.dy, master.x+master.dx-object.x-object.dx)
				--local acc = ships[object.ship].acc*dt
				local a = (object.angle-dirangle)%(2*math.pi)
				--local vangle = math.atan2(object.dy, object.dx)
				local rot = ships[object.ship].rot*dt
				--local nextd = math.sqrt((object.x+object.dx-master.x-master.dx)^2 + (object.y+object.dy-master.y-master.dy)^2)
				--if d > 40 then 
				if a > math.pi and a < 2*math.pi-.2 then
					object.angle = object.angle + rot
				--	print(1,object.angle)
				elseif a < math.pi and a > .2 then
					object.angle = object.angle - rot 
					--print(-1,object.angle)
				else
					local v = math.sqrt(object.dx^2 + object.dy^2)
					if v < 800 then --a bit faster than master ships, to be able to catch up
						local acc = ships[object.ship].acc*dt
						object.dx = object.dx + acc*math.cos(object.angle)
						object.dy = object.dy + acc*math.sin(object.angle)
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
				local d = math.sqrt((object.targetx-object.x)^2 + (object.targety-object.y)^2)
				--local targetangle = math.atan2(object.targety-object.y, object.targetx-object.x)
				local dirangle = math.atan2(object.targety-object.y-object.dy, object.targetx-object.x-object.dx)
				local a = (object.angle-dirangle)%(2*math.pi)
				--
				local rot = ships[object.ship].rot*dt
				if a > math.pi and a < 2*math.pi-.2 then
					object.angle = object.angle + rot 
				--	print(1,object.angle)
				elseif a < math.pi and a > .2 then
					object.angle = object.angle - rot 
					--print(-1,object.angle)
				else
					local v = math.sqrt(object.dx^2 + object.dy^2)
					local vangle = math.atan2(object.dy, object.dx)
					local va = (vangle-dirangle)%(2*math.pi)
					if v < 800 then
						local acc = ships[object.ship].acc*dt
						object.dx = object.dx + acc*math.cos(object.angle)
						object.dy = object.dy + acc*math.sin(object.angle)
					elseif v > 800 then -- cheat
						object.dx = object.dx*.99
						object.dy = object.dy*.99
						--turn?
					elseif va > math.pi and va < 2*math.pi-.2 then --how the fuck am i going to do this
					
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
			--object.angle = math.atan2(object.dy, object.dx)
		end
	end
end

function ai.draw()
end
