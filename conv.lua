conv = {} --conv: {speakers = {'a', 'ar', 'player'}, {1, 'We are Amania'}, {2, 'We are rebels'}, {1, 'Amania again'}, index = 1}

registerstate'conv'

function conv.load()
end

function conv.update(dt)
end

function conv.draw()
	for i=1,conv.index do
		local speaker = officialnames[conv.speakers[conv[i][1]]]
		local text = conv[i][2]
		love.graphics.print(speaker, i%2==1 and 20 or 700, i * 60)
		love.graphics.print(text, 150, i * 60)
	end
	love.graphics.print('<Enter>', 380, conv.index * 60 + 40)
end

function states.conv.keypressed.enter()
	conv.index = conv.index + 1
	if conv.index > #conv then
		state.current = 'game'
		love.graphics.setFont(smallfont)
	end
end

local cfuncs = {load=true, update=true, draw=true, allowsave=true}
function conv.allowsave()
	return not cfuncs[key]
end
