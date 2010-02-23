player = {}
ranks = {"Spaceman", "Leading Spaceman", "Petty Officer", "Warrant Officer";
         "Midshipman"; "Ensign", "Sub-Lieutenant", "Lieutenant";
         "Lieutenant-Commander", "Commander", "Captain"; "Commodore",
         "Rear Admiral", "Vice Admiral", "Admiral", "Admiral of the Fleet"}
--fleetsizebyrank = {0, 0, 0, 0; 1; 2, 2, 2; 3, 3, 3; 5, 7, 7, 7, 10, 15}

function player.load()
	player.x = map.objects.homebase.x + 400
	player.y = map.objects.homebase.y
	player.dx = 0
	player.dy = 0
	player.angle = 0
	--player.acc = 20
	player.rank = 1
	player.ship = 'beginner'
	player.remove = false
end

function player.update(dt)
	local mult = love.keyboard.isDown("lshift") and 3 or 1
	local ship = ships[player.ship]
	local D = love.keyboard.isDown
	if D"up" or D"w" then
		player.autopilot = false
		local ddx = dt*math.cos(player.angle) * ship.acc * mult
		local ddy = dt*math.sin(player.angle) * ship.acc * mult
		if (ddx>0) ~= (player.dx>0) then ddx = ddx * ship.revengine end
		if (ddy>0) ~= (player.dy>0) then ddy = ddy * ship.revengine end
		player.dx = player.dx + ddx
		player.dy = player.dy + ddy
	end
	if D"right" or D"d" then
		player.autopilot = false
		player.angle = player.angle - dt * mult * ship.rot
	elseif D"left" or D"a" then
		player.autopilot = false
		player.angle = player.angle + dt * mult * ship.rot
	end
	if player.autopilot then
		local d = math.sqrt((player.targetx-player.x)^2 + (player.targety-player.y)^2)
		--local targetangle = math.atan2(player.targety-player.y, player.targetx-player.x)
		local dirangle = math.atan2(player.targety-player.y-player.dy, player.targetx-player.x-player.dx)
		local a = (player.angle-dirangle)%(2*math.pi)
		local vangle = math.atan2(player.dy, player.dx)
		local v = math.sqrt(player.dx^2 + player.dy^2)
		local rot = ships[player.ship].rot*dt
		if d > 1500 or (v < 100 and vangle > math.pi) then
			if a > math.pi and a < 2*math.pi-.2 then
				player.angle = player.angle + rot 
			--	print(1,player.angle)
			elseif a < math.pi and a > .2 then
				player.angle = player.angle - rot 
				--print(-1,player.angle)
			else
				local v = math.sqrt(player.dx^2 + player.dy^2)
				if v < (player.hyperspeed and 2500 or 600) then
					local acc = ships[player.ship].acc*dt
					player.dx = player.dx + acc*math.cos(player.angle)
					player.dy = player.dy + acc*math.sin(player.angle)
				elseif v > 300 then -- cheat
					player.dx = player.dx*.99
					player.dy = player.dy*.99
					--turn?
				end
			end
		elseif d < 200 then
			player.autopilot = false
		else -- we're close
			if a > math.pi + .2 and a < 2*math.pi then
				player.angle = player.angle - rot 
			--	print(1,player.angle)
			elseif a < math.pi - .2 and a > 0 then
				player.angle = player.angle + rot 
				--print(-1,player.angle)
			else
				--local v = math.sqrt(player.dx^2 + player.dy^2)
				if d < 400 then
					local acc = ships[player.ship].acc*dt
					player.dx = player.dx + acc*math.cos(player.angle)
					player.dy = player.dy + acc*math.sin(player.angle)
				end
			end
		end
	end
	player.x = player.x + player.dx * dt
	player.y = player.y + player.dy * dt
	if player.remove then
		--player died
		state.current = 'dead'
	end
end

local nextship = {beginner = 'cyanoxscout', cyanoxscout = 'cyanoxfighter', cyanoxfighter = 'cyanoxspeeder', cyanoxspeeder = 'cyanoxbomber', cyanoxbomber = 'cyanoxscout', vessel = 'fighter', fighter='bomber', bomber='speeder', speeder = 'betterspeeder', betterspeeder = 'superspeeder', superspeeder = 'beginner'}
function states.game.keypressed.tab()
	player.ship = nextship[player.ship]
end
function states.dead.keypressed.r()
	restart()
	state.current = 'game'
end

function player.draw()
end
