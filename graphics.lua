graphics = {vector = {}, viewx = 0, viewy = 0, zoom = 1}

function graphics.load()
	graphics.vector = require "shipgraphics/all.lua"
	graphics.vector.beginner = {
			{width=2, closed=true, -1, -1, 0, 2, 1, -1},
			{width=1.5, -.5, .5, .5, .5},
		}
	graphics.vector.vessel = {
			{width=2, closed=true, -1, -1, -.2, 1.4, .2, 1.4, 1, -1, 1.5, -2, -1.5, -2},
			{width=1.5, closed=true, -.3, -.4, 0, .5, .3, -.4},
		}
	graphics.vector.landingstrip = {
			{width=1.5, closed=true, -1, 1, 1, 1, 1, 1.5, -1, 1.5}
		}
	graphics.vector.arrow = {
			{width=2.5, -.5, 1.5, 0, 2, .5, 1.5},
			{width=2, -.25, 1.75, -.25, .25, -.5, 0, 0, -.5, .5, 0, .25, .25, .25, 1.75},
			{width=1.5, .25, .75, 1, 0, 0, -1, -1, 0, -.25, .75},
			--{width=1, .35, .65, .65, .65, .65, .35},
			--{width=1, -.35, .65, -.65, .65, -.65, .35},
			{width=1.5, .3, -.7, .65, -.65, .7, -.3},
			{width=1.5, -.3, -.7, -.65, -.65, -.7, -.3}
		}
	graphics.vector.transmission = {
			{width=2.5, -2, 0, -1.5, 0},
			{width=2.5, 2, 0, 1.5, 0},
			{width=1}, -- >
			{width=1}, --  )
			{width=1}, --   }
			{width=1}, --       <
			{width=1}, --      (
			{width=1}, --     {
			           -- >)} {(< -
		}
	graphics.vector.planet = {
			{width=2}, --autofilled with circle
			{width=2, -2, 0, -1.8, 0, -1.5, -.25, -1.25, -.5, -1.3, -.8, -1.1, -.9, --[[-1.3, -1, -1.4, -1.2,]] -1.3, -1.3, -1.41, -1.41},
			{width=2, -0.14, -1.99, -.24, -1.3, .09, -.8, .29, -.75, .3, -.5, -.04, .4, .2, .45, .3, .7, .8, .73, 1.1, .65, 1.3, .64, 1.35, .8, 1.39, .92, 1.7, 1.05},
			{width=2, 0, 2, 0, 1.79, -.3, 1.63, -.34, 1.49, -.62, 1.56, -.83, 1.72, -1.1, 1.67}
		}
	graphics.vector.trade = {
			{width=3, -2, .25, -.5, 1.75},
			{width=3, 2, -.25, .5, -1.75},
			{width=2, -2, .25, 2, .25, 2, .75, -1.5, .75},
			{width=2, 2, -.25, -2, -.25, -2, -.75, 1.5, -.75},
		}
	local t = graphics.vector.transmission
	local tI = table.insert
	local sin, cos = math.sin, math.cos
	for i=-1, 1, .1 do
		local sini = sin(i)
		local cosi = cos(i)
		tI(t[3], 1.5 - .5*cosi)
		tI(t[3], .5*sini)
		tI(t[4], 1.4 - .75*cosi)
		tI(t[4], .75*sini)
		tI(t[5], 1.3 - cosi)
		tI(t[5], sini)
		tI(t[6], .5*cosi - 1.5)
		tI(t[6], .5*sini)
		tI(t[7], .75*cosi - 1.4)
		tI(t[7], .75*sini)
		tI(t[8], cosi - 1.3)
		tI(t[8], sini)
	end
	local t = graphics.vector.planet[1]
	for i=0,2*math.pi+.1,.1 do
		tI(t, 2*cos(i))
		tI(t, 2*sin(i))
	end
end

function graphics.update(dt)
	if true then
		if state.shaking and not settings.noshaking then
			local s = state.shaking
			graphics.viewx = player.x + math.random(s) - s*.5
			graphics.viewy = player.y + math.random(s) - s*.5
		else
			graphics.viewx, graphics.viewy = player.x, player.y
		end
	else
		--cut scenes?
	end
end


function graphics.drawlines(lines)
	love.graphics.setLineWidth(lines.width)
	local clr
	if lines.color then
		clr = love.graphics.getColor()
		love.graphics.setColor(unpack(lines.color))
	end
	if lines.closed then
		if lines.fill then
			love.graphics.polygon('fill', unpack(lines))
		end
		love.graphics.polygon('line', unpack(lines))
	else
		love.graphics.line(unpack(lines))
	end
	if lines.color then
		love.graphics.setColor(unpack(clr))
	end
end

local hp = .5*math.pi
function graphics.drawshape(shape, x, y, s, a)
	a = a - hp
	love.graphics.push()
	love.graphics.translate(x, y)
	love.graphics.scale(s)
	love.graphics.rotate(a)
	for i,lines in ipairs(shape) do
		graphics.drawlines(lines)
	end
	love.graphics.pop()
end

local w, h = love.graphics.getWidth()/2, love.graphics.getHeight()/2
function graphics.draw()
	local n = 70 * math.sqrt(graphics.zoom)
	love.graphics.push()
	love.graphics.translate(w, h)
	love.graphics.scale(graphics.zoom, -graphics.zoom)
	love.graphics.translate(-graphics.viewx, -graphics.viewy)
	for i,object in pairs(map.objects) do
		local rx = (400 + (object.radius or 0))/graphics.zoom
		local ry = (300 + (object.radius or 0))/graphics.zoom
		if object.x >= graphics.viewx - rx and object.x <= graphics.viewx + rx and object.y >= graphics.viewy - ry and object.y <= graphics.viewy + ry then
			if object.type == 'base' or object.type == 'planet' then
				love.graphics.setLineWidth(1.5)
				love.graphics.circle('fill', object.x, object.y, object.radius, n)
				love.graphics.circle('line', object.x, object.y, object.radius, n)
				local a = object.landingstripangle
				if a then
					graphics.drawshape(graphics.vector.landingstrip, object.x + object.radius*math.cos(a), object.y + object.radius*math.sin(a), 40, a)
				end
			elseif object.type == 'ship' then
				graphics.drawshape(graphics.vector[object.ship.vector], object.x, object.y, object.ship.size, object.angle)
			elseif object.type == 'black hole' then
				for i=0,359,5 do
					local st = ((i*1.43 + state.totaltime) % 10)/10
					local r = (1 - st) * object.radius + 200
					love.graphics.setColor(255,255,255,st*255)
					love.graphics.line(object.x + 200*math.cos(math.rad(i)), object.y + 200*math.sin(math.rad(i)), object.x + r*math.cos(math.rad(i)), object.y + r*math.sin(math.rad(i)))
					love.graphics.setColor(255,255,255)
				end
			end
		end
	end
	graphics.drawshape(graphics.vector[player.ship.vector], player.x, player.y, player.ship.size, player.angle)
	if player.autopilot then
		local r = 18000/player.ship.acc
		love.graphics.circle('line', player.targetx, player.targety, r, n)
		local x1 = r*math.cos(state.totaltime)
		local y1 = r*math.sin(state.totaltime)
		local x2 = r*math.cos(hp+state.totaltime)
		local y2 = r*math.sin(hp+state.totaltime)
		love.graphics.line(player.targetx + x1, player.targety + y1, player.targetx - x1, player.targety - y1)
		love.graphics.line(player.targetx + x2, player.targety + y2, player.targetx - x2, player.targety - y2)
	end
	love.graphics.pop()
end

function graphics.allowsave(key)
	return key == 'viewx' or key == 'viewy' or key == 'zoom'
end
