help = {index = 1}
registerstate'help'

function help.load()
	help.pages = {
		{
			title = 'Game controls',
			{'Up/W', 'Accelerate'},
			{'Left/A', 'Turn left'},
			{'Right/D', 'Turn right'},
			{'Hold Shift', 'Turbo (drains oil)'},
			{'Escape', 'Open menu'},
			{'Enter', 'Enter base'},
			{'S', 'Autopilot'},
			{'Shift+S', 'Autopilot with larger cruise speed'},
			{'B', 'Automatic braking'},
			{'C', 'Toggle cargo view'},
			{'J/K', 'Go through cargo list'},
			{'P', 'Pause'},
			{'PgUp', 'Zoom in'},
			{'PgDown', 'Zoom out'},
			{';', 'Open command prompt, press backspace to close'},
			{'F7', 'Toggle UI visibility'},
		},
	}
end

function help.update(dt)
end

function help.draw()
	local p = help.pages[help.index]
	love.graphics.print(p.title, 10, 40)
	love.graphics.setFont(mediumfont)
	for i=1,#p do
		love.graphics.print(p[i][1], 35, 60 + 30 * i)
		love.graphics.print(p[i][2], 155, 60 + 30 * i)
	end
	love.graphics.setFont(largefont)
end

function states.help.keypressed.escape()
	state.current = 'game'
	love.graphics.setFont(smallfont)
end
