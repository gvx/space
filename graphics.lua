graphics = {vector = {}, viewx = 0, viewy = 0, zoom = 1}

function graphics.load()
	graphics.vector = {
		--[[player = {
			{width=2, closed=true, -1, -1, 0, 2, 1, -1},
			{width=1.5, -.5, -1, 0, .5, .5, -1},
			{width=1.5, -.2, -.1, .2, -.1},
		},]]
		beginner = {
			{width=2, closed=true, -1, -1, 0, 2, 1, -1},
			{width=1.5, -.5, .5, .5, .5},
		},
		vessel = {
			{width=2, closed=true, -1, -1, -.2, 1.4, .2, 1.4, 1, -1, 1.5, -2, -1.5, -2},
			{width=1.5, closed=true, -.3, -.4, 0, .5, .3, -.4},
		},
		fighter = {
			{width=2, closed=true, -1, -1, 0, 2, 1, -1},
			--[[
			{width=1.5, -.3, 1, .3, 1},
			{width=1.5, -.1, 1, -.1, 0},
			{width=1.5, .1, 1, .1, 0},
			--]]
			{width=1.5, -.5, .5, .5, .5},
			{width=1.5, -.15, .5, -.3, -.5},
			{width=1.5, .15, .5, .3, -.5},
		},
		bomber = {
			{width=2, closed=true, -1, -1, 0, 2, 1, -1},
			{width=1.5, -.7, 0, -.7, 1, -.3, 1},
			{width=1.5, .7, 0, .7, 1, .3, 1},
		},
		speeder = {
			{width=2, closed=true, -1, -1, 0, 3, 1, -1, .5, -1, .4, .5, .3, -1.2, -.3, -1.2, -.4, .5, -.5, -1},
		},
		cyanoxspeeder = {
			{width=1.5, 0.01,-1.23, -0.39,-0.96, -0.42,-0.43, -0.61,-0.55, -0.56,-0.04, -0.44,0.05, -0.5,1.19, -0.39,1.28, -0.3,1.95, -0.57,2.17, -0.22,3.03, -0.1,3.88, 0.01,4.27},
			{width=1.5, -0.5,1.02, -0.96,0.72, -1.61,1.25, -1.73,1.14, -1.57,0.05, -0.69,-0.56, -0.71,-0.75, -0.46,-0.92, -0.4,-0.8},
			{width=1.5, -0.5,1.19, -0.83,1.3, -0.88,0.78, -0.49,1.02, -0.5,1.19, closed=true},
			{width=1.5, -0.74,-1.03, -0.86,-1.14, -0.91,-1.41, -0.22,-1.51, -0.19,-1.23, -0.28,-1.13},
			{width=1.5, -0.27,-1.03, -0.3,-1.31, -0.79,-1.21, -0.66,-0.79, -0.45,-0.92, -0.4,-0.79, -0.39,-0.96, -0.27,-1.03, closed=true},
			{width=1.5, 0.01,-0.41, -0.17,-0.46, -0.28,-0.69, -0.29,-0.34, -0.42,-0.43},
			{width=1.5, -0.44,0.05, -0.33,0.12, -0.31,1.19, -0.16,2.5, -0.11,3.27, 0.01,3.47},
			{width=1.5, -0.01,-1.23, 0.39,-0.96, 0.42,-0.43, 0.61,-0.55, 0.56,-0.04, 0.44,0.05, 0.5,1.19, 0.39,1.28, 0.3,1.95, 0.57,2.17, 0.22,3.03, 0.1,3.88, -0.01,4.28},
			{width=1.5, 0.5,1.02, 0.96,0.72, 1.61,1.25, 1.73,1.14, 1.57,0.05, 0.69,-0.56, 0.71,-0.75, 0.46,-0.92, 0.4,-0.8},
			{width=1.5, 0.5,1.19, 0.83,1.3, 0.88,0.78, 0.49,1.02, 0.5,1.19, closed=true},
			{width=1.5, 0.74,-1.03, 0.86,-1.14, 0.91,-1.41, 0.22,-1.51, 0.19,-1.23, 0.28,-1.13},
			{width=1.5, 0.27,-1.03, 0.3,-1.31, 0.79,-1.21, 0.66,-0.79, 0.45,-0.92, 0.4,-0.79, 0.39,-0.96, 0.27,-1.03, closed=true},
			{width=1.5, -0.01,-0.41, 0.17,-0.46, 0.28,-0.69, 0.29,-0.34, 0.42,-0.43},
			{width=1.5, 0.44,0.05, 0.33,0.12, 0.31,1.19, 0.16,2.5, 0.11,3.27, -0.01,3.47},
		},
		cyanoxbomber = {
			{width=1.5, 0.01,-0.79, -0.11,-0.79, -0.11,0.26, -0.19,0.27, -0.2,0.48, -0.1,0.49, -0.1,1.03, 0.01,1.15},
			{width=1.5, -0.12,-0.71, -0.23,-0.71, -0.34,-0.59, -0.82,-0.57, -0.95,-0.38, -1.09,-0.37, -1.17,-0.2, -0.97,0, -1.19,0.19, -1.18,0.52, -1.63,0.69, -1.68,0.93, -1.66,1.26, -1.6,1.48, -1.39,1.4, -1.31,1.59, -1.53,1.67, -1.39,1.97, -1.18,2.21, -0.56,1.59, -0.37,1.72, -0.18,1.82, 0.01,1.83},
			{width=1.5, -1.26,0.48, -1.41,0.54, -1.88,0.56, -2.02,0.48, -2.03,-0.26, -1.89,-0.16, -1.42,-0.17, -1.28,-0.27, -1.26,0.48, closed=true},
			{width=1.5, -2.02,0.33, -2.14,0.42, -2.13,0.93, -1.99,1.03, -1.68,1.02},
			{width=1.5, -1.67,1.13, -1.98,1.28, -1.67,1.88, -1.34,2.3, -1.03,2.57, -0.7,2.79, -0.72,1.93, -0.58,1.76, -0.37,1.73, -0.36,2, -0.29,2, -0.24,1.79},
			{width=1.5, -1.26,0.15, -1.13,0.15, -1.13,-0.15},
			{width=1.5, -0.82,-0.57, -0.82,0.06, -0.71,0.06, -0.7,0.65, -0.56,0.8, -0.41,0.65, -0.42,0.04, -0.33,0.04, -0.33,-0.6},
			{width=1.5, -0.01,-0.79, 0.11,-0.79, 0.11,0.26, 0.19,0.27, 0.2,0.48, 0.1,0.49, 0.1,1.03, -0.01,1.15},
			{width=1.5, 0.12,-0.71, 0.23,-0.71, 0.34,-0.59, 0.82,-0.57, 0.95,-0.38, 1.09,-0.37, 1.17,-0.2, 0.97,0, 1.19,0.19, 1.18,0.52, 1.63,0.69, 1.68,0.93, 1.66,1.26, 1.6,1.48, 1.39,1.4, 1.31,1.59, 1.53,1.67, 1.39,1.97, 1.18,2.21, 0.56,1.59, 0.37,1.72, 0.18,1.82, -0.01,1.83},
			{width=1.5, 1.26,0.48, 1.41,0.54, 1.88,0.56, 2.02,0.48, 2.03,-0.26, 1.89,-0.16, 1.42,-0.17, 1.28,-0.27, 1.26,0.48, closed=true},
			{width=1.5, 2.02,0.33, 2.14,0.42, 2.13,0.93, 1.99,1.03, 1.68,1.02},
			{width=1.5, 1.67,1.13, 1.98,1.28, 1.67,1.88, 1.34,2.3, 1.03,2.57, 0.7,2.79, 0.72,1.93, 0.58,1.76, 0.37,1.73, 0.36,2, 0.29,2, 0.24,1.79},
			{width=1.5, 1.26,0.15, 1.13,0.15, 1.13,-0.15},
			{width=1.5, 0.82,-0.57, 0.82,0.06, 0.71,0.06, 0.7,0.65, 0.56,0.8, 0.41,0.65, 0.42,0.04, 0.33,0.04, 0.33,-0.6},
		},
		cyanoxfighter = {
			{width=1.5, 0.03,-1.31, -0.63,-1.28, -0.75,-1.15, -1.47,-1.16, -1.6,-0.91, -1.86,-0.97, -1.86,-0.84, -2.52,-0.9, -2.51,-1.23, -3.21,-0.94, -5.09,-0.73, -5.08,-0.12, -3.18,0.39, -3.18,0.57, -2.59,0.66, -1.87,1.04, -1.87,1.25, -1.46,1.26, -1.34,1.51, -0.88,1.51, -0.67,0.95, -0.67,0.15, -0.09,0.59, 0.02,0.59},
			{width=1.5, -0.8,1.29, -0.43,1.34, -0.32,1.57, -0.41,1.8, -0.4,2.27, -0.31,2.38, -0.61,2.38, -1.11,2.52, -1.11,2.67, -0.56,2.81, -0.12,3.04, -0.08,3.21, -0.06,3.64, 0.02,3.7},
			{width=1.5, -0.58,2.81, -0.59,3.21, -0.64,3.26, -0.64,3.44, -0.59,3.41, -0.54,3.44, -0.54,3.25, -0.59,3.21},
			{width=1.5, -5.1,-0.7, -5.52,-0.7, -5.51,-0.12, -5.36,0.05, -5.36,0.51, -5.19,0.51, -5.19,0.05, -5.09,-0.12, -5.1,-0.7, closed=true},
			{width=1.5, -3.18,0.41, -3.2,-0.95},
			{width=1.5, -2.52,-0.89, -2.61,0.64},
			{width=1.5, -1.87,1.05, -1.87,-0.85},
			{width=1.5, -0.67,0.17, -0.68,-1.22},
			{width=1.5, -1.43,-0.9, -1.16,-1.03, -0.9,-0.9, -0.9,-0.45, -1.06,-0.39, -1.06,-0.23, -1,-0.18, -1,0.06, -1.34,0.06, -1.34,-0.19, -1.29,-0.23, -1.29,-0.38, -1.43,-0.45, -1.43,-0.9, closed=true},
			{width=1.5, -0.03,-1.31, 0.63,-1.28, 0.75,-1.15, 1.47,-1.16, 1.6,-0.91, 1.86,-0.97, 1.86,-0.84, 2.52,-0.9, 2.51,-1.23, 3.21,-0.94, 5.09,-0.73, 5.08,-0.12, 3.18,0.39, 3.18,0.57, 2.59,0.66, 1.87,1.04, 1.87,1.25, 1.46,1.26, 1.34,1.51, 0.88,1.51, 0.67,0.95, 0.67,0.15, 0.09,0.59, -0.02,0.59},
			{width=1.5, 0.8,1.29, 0.43,1.34, 0.32,1.57, 0.41,1.8, 0.4,2.27, 0.31,2.38, 0.61,2.38, 1.11,2.52, 1.11,2.67, 0.56,2.81, 0.12,3.04, 0.08,3.21, 0.06,3.64, -0.02,3.7},
			{width=1.5, 0.58,2.81, 0.59,3.21, 0.64,3.26, 0.64,3.44, 0.59,3.41, 0.54,3.44, 0.54,3.25, 0.59,3.21},
			{width=1.5, 5.1,-0.7, 5.52,-0.7, 5.51,-0.12, 5.36,0.05, 5.36,0.51, 5.19,0.51, 5.19,0.05, 5.09,-0.12, 5.1,-0.7, closed=true},
			{width=1.5, 3.18,0.41, 3.2,-0.95},
			{width=1.5, 2.52,-0.89, 2.61,0.64},
			{width=1.5, 1.87,1.05, 1.87,-0.85},
			{width=1.5, 0.67,0.17, 0.68,-1.22},
			{width=1.5, 1.43,-0.9, 1.16,-1.03, 0.9,-0.9, 0.9,-0.45, 1.06,-0.39, 1.06,-0.23, 1,-0.18, 1,0.06, 1.34,0.06, 1.34,-0.19, 1.29,-0.23, 1.29,-0.38, 1.43,-0.45, 1.43,-0.9, closed=true},
		},
		cyanoxscout = {
			{width=1.5, 0.01,-1.42, -0.19,-1.42, -0.48,-1.28, -0.3,-0.78, -0.3,-0.61, -0.57,-0.43, -0.78,-0.05, -1.11,-0.05, -1.1,-0.53, -1.22,-0.63, -1.22,-0.79, -1.05,-1.31, -1.35,-1.45, -1.82,-1.45, -2.05,-1.29, -1.86,-0.79, -1.86,-0.62, -2.48,-0.63, -3.61,-0.31, -3.62,0.11, -2.48,0.42, -1.12,1.26},
			{width=1.5, -1.1,-0.05, -1.26,-0.04, -1.27,0.71, -1.07,1.46, -0.81,2.05, -0.42,2.7, -0.15,2.7},
			{width=1.5, -0,4.39, -0.08,4.29, -0.11,3.82, -0.52,3.52, -0.95,3.36, -0.94,3.21, -0.52,3.11, -0.18,3.11, -0.31,2.7},
			{width=1.5, 0,-0.44, -0.11,-0.44, -0.39,-0.3, -0.59,-0.05, -0.59,0.64, -0.14,1.3, -0.14,3.79},
			{width=1.5, -0,-1.03, -0.39,-1.03},
			{width=1.5, -0,-0.8, -0.3,-0.79},
			{width=1.5, -1.24,-0.81, -1.87,-0.8},
			{width=1.5, -1.15,-1.04, -1.95,-1.05},
			{width=1.5, -0.01,-1.42, 0.19,-1.42, 0.48,-1.28, 0.3,-0.78, 0.3,-0.61, 0.57,-0.43, 0.78,-0.05, 1.11,-0.05, 1.1,-0.53, 1.22,-0.63, 1.22,-0.79, 1.05,-1.31, 1.35,-1.45, 1.82,-1.45, 2.05,-1.29, 1.86,-0.79, 1.86,-0.62, 2.48,-0.63, 3.61,-0.31, 3.62,0.11, 2.48,0.42, 1.12,1.26},
			{width=1.5, 1.1,-0.05, 1.26,-0.04, 1.27,0.71, 1.07,1.46, 0.81,2.05, 0.42,2.7, 0.15,2.7},
			{width=1.5, 0,4.39, 0.08,4.29, 0.11,3.82, 0.52,3.52, 0.95,3.36, 0.94,3.21, 0.52,3.11, 0.18,3.11, 0.31,2.7},
			{width=1.5, -0,-0.44, 0.11,-0.44, 0.39,-0.3, 0.59,-0.05, 0.59,0.64, 0.14,1.3, 0.14,3.79},
			{width=1.5, 0,-1.03, 0.39,-1.03},
			{width=1.5, 0,-0.8, 0.3,-0.79},
			{width=1.5, 1.24,-0.81, 1.87,-0.8},
			{width=1.5, 1.15,-1.04, 1.95,-1.05},
		},
		
		landingstrip = {
			{width=1.5, closed=true, -1, 1, 1, 1, 1, 1.5, -1, 1.5}
		},
		arrow = {
			{width=2.5, -.5, 1.5, 0, 2, .5, 1.5},
			{width=2, -.25, 1.75, -.25, .25, -.5, 0, 0, -.5, .5, 0, .25, .25, .25, 1.75},
			{width=1.5, .25, .75, 1, 0, 0, -1, -1, 0, -.25, .75},
			--{width=1, .35, .65, .65, .65, .65, .35},
			--{width=1, -.35, .65, -.65, .65, -.65, .35},
			{width=1.5, .3, -.7, .65, -.65, .7, -.3},
			{width=1.5, -.3, -.7, -.65, -.65, -.7, -.3}
		},
		transmission = {
			{width=2.5, -2, 0, -1.5, 0},
			{width=2.5, 2, 0, 1.5, 0},
			{width=1}, -- >
			{width=1}, --  )
			{width=1}, --   }
			{width=1}, --       <
			{width=1}, --      (
			{width=1}, --     {
			           -- >)} {(< -
		},
		planet = {
			{width=2}, --autofilled with circle
			{width=2, -2, 0, -1.8, 0, -1.5, -.25, -1.25, -.5, -1.3, -.8, -1.1, -.9, --[[-1.3, -1, -1.4, -1.2,]] -1.3, -1.3, -1.41, -1.41},
			{width=2, -0.14, -1.99, -.24, -1.3, .09, -.8, .29, -.75, .3, -.5, -.04, .4, .2, .45, .3, .7, .8, .73, 1.1, .65, 1.3, .64, 1.35, .8, 1.39, .92, 1.7, 1.05},
			{width=2, 0, 2, 0, 1.79, -.3, 1.63, -.34, 1.49, -.62, 1.56, -.83, 1.72, -1.1, 1.67}
		},
		trade = {
			{width=3, -2, .25, -.5, 1.75},
			{width=3, 2, -.25, .5, -1.75},
			{width=2, -2, .25, 2, .25, 2, .75, -1.5, .75},
			{width=2, 2, -.25, -2, -.25, -2, -.75, 1.5, -.75},
		}
	}
	for i,sname in ipairs{'vessel', 'fighter', 'bomber', 'speeder'} do
		graphics.vector['better'..sname] = graphics.vector[sname]
		graphics.vector['super'..sname] = graphics.vector[sname]
	end
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


function graphics.drawlines(lines, x, y, s, ax, ay)
	love.graphics.setLineWidth(lines.width)
	for i=1,#lines-3,2 do
		love.graphics.line(lines[i]*s*ax - lines[i+1]*s*ay + x,
		                   lines[i]*s*ay + lines[i+1]*s*ax + y,
		                   lines[i+2]*s*ax - lines[i+3]*s*ay + x,
		                   lines[i+2]*s*ay + lines[i+3]*s*ax + y)
	end
	if lines.closed then 
		local i = #lines-1
		love.graphics.line(lines[i]*s*ax - lines[i+1]*s*ay + x,
		                   lines[i]*s*ay + lines[i+1]*s*ax + y,
		                   lines[1]*s*ax - lines[2]*s*ay + x,
		                   lines[1]*s*ay + lines[2]*s*ax + y)
		if lines.fill then
		end
	end
end

local hp = .5*math.pi
function graphics.drawshape(shape, x, y, s, a)
	a = a - hp
	local ax, ay = math.cos(a), math.sin(a)
	for i,lines in ipairs(shape) do
		graphics.drawlines(lines, x, y, s, ax, ay)
	end
end

local w, h = love.graphics.getWidth()/2, love.graphics.getHeight()/2
function graphics.draw()
	love.graphics.print(love.timer.getFPS(), 20, 10)
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
				local n = 50 * math.sqrt(graphics.zoom)
				love.graphics.circle('fill', object.x, object.y, object.radius, n)
				love.graphics.circle('line', object.x, object.y, object.radius, n)
				local a = object.landingstripangle
				if a then
					graphics.drawshape(graphics.vector.landingstrip, object.x + object.radius*math.cos(a), object.y + object.radius*math.sin(a), 40, a)
				end
			elseif object.type == 'ship' then
				--[[if object.spaghetti_amount then
					love.graphics.push()
					love.graphics.rotate(object.spaghetti_angle)
					love.graphics.scale(object.spaghetti_amount, 1)
					love.graphics.rotate(-object.spaghetti_angle)
				end]]
				graphics.drawshape(graphics.vector[object.ship], object.x, object.y, ships[object.ship].size, object.angle)
				--[[if object.spaghetti_amount then
					love.graphics.pop()
				end]]
			elseif object.type == 'black hole' then
				for i=0,359,5 do
					local st = ((i*1.43 + state.totaltime) % 10)/10
					local r = (1 - st) * object.radius + 200
					love.graphics.setColor(255,255,255,st*255)
					love.graphics.line(object.x + 200*math.cos(math.rad(i)), object.y + 200*math.sin(math.rad(i)), object.x + r*math.cos(math.rad(i)), object.y + r*math.sin(math.rad(i)))
					love.graphics.setColor(255,255,255,255)
				end
			end
		end
	end
	--[[if player.spaghetti_amount then
		love.graphics.push()
		love.graphics.translate(-w, -h)
		love.graphics.rotate(player.spaghetti_angle)
		love.graphics.scale(player.spaghetti_amount, 1)
		love.graphics.rotate(-player.spaghetti_angle)
		love.graphics.translate(w, h)
	end]]
	graphics.drawshape(graphics.vector[player.ship], player.x, player.y, ships[player.ship].size, player.angle)
	--[[if player.spaghetti_amount then
		love.graphics.pop()
	end]]
	love.graphics.pop()
end
