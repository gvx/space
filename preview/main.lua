vector = require "light_bomber" --change this line for other previews
local vlen = #vector
local llen = 0
for i=1,vlen do
	llen = llen + #vector[i]
end
vlen = 'Lines: ' .. vlen
llen = 'Line pieces: ' .. llen

function drawlines(lines, x, y, s, ax, ay)
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
function drawshape(shape, x, y, s, a)
	a = a - hp
	local ax, ay = math.cos(a), math.sin(a)
	for i,lines in ipairs(shape) do
		drawlines(lines, x, y, s, ax, ay)
	end
end

totaltime = 0
D = love.keyboard.isDown
function love.update(dt)
	totaltime = totaltime + (D' ' and 4*dt or dt)
	love.timer.sleep(22)
end

local w, h = love.graphics.getWidth()/2, love.graphics.getHeight()/2
function love.draw()
	love.graphics.print(love.timer.getFPS(), 20, 10)
	love.graphics.print(vlen, 20, 30)
	love.graphics.print(llen, 20, 50)
	love.graphics.push()
	love.graphics.translate(w, h)
	love.graphics.scale(1, -1)
	love.graphics.setColor(100, 100, 100)
	love.graphics.circle('line', 0, 0, 290, 60)
	love.graphics.setColor(255, 255, 255)
	drawshape(vector, 0 , 0, 290, totaltime*.5)
	if vector.collision then
		love.graphics.setColor(0, 0, 255)
		love.graphics.polygon('line', unpack(vector.collision))
	end
	love.graphics.pop()
end
