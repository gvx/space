function love.graphics.roundrect(mode, x, y, width, height, xround, yround)
	local points = {}
	local precision = (xround + yround) * .1
	local invprec = 1/precision
	local tI, hP = table.insert, .5*math.pi
	if xround > width*.5 then xround = width*.5 end
	if yround > height*.5 then yround = height*.5 end
	local X1, Y1, X2, Y2 = x + xround, y + yround, x + width - xround, y + height - yround
	local sin, cos = math.sin, math.cos
	for i = 0, precision do
		local a = (i*invprec-1)*hP
		points[#points+1] = X2 + xround*cos(a)
		points[#points+1] = Y1 + yround*sin(a)
	end
	for i = 0, precision do
		local a = i*invprec*hP
		points[#points+1] = X2 + xround*cos(a)
		points[#points+1] = Y2 + yround*sin(a)
	end
	for i = 0, precision do
		local a = (i*invprec+1)*hP
		points[#points+1] = X1 + xround*cos(a)
		points[#points+1] = Y2 + yround*sin(a)
	end
	for i = 0, precision do
		local a = (i*invprec+2)*hP
		points[#points+1] = X1 + xround*cos(a)
		points[#points+1] = Y1 + yround*sin(a)
	end
	love.graphics.polygon(mode, unpack(points))
end
