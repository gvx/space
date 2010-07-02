help = {index = 1}
registerstate'help'

function help.load()
	help.pages = {
		{
			title = 'Game controls',
			{'Arrow keys, W/A/D', 'Steering'},
			{'Shift+Arrow keys/W/A/D', 'Turbo (drains oil)'},
			{'Escape', 'Open menu'},
			{'Enter', '(when on a base) Enter base'},
			{'S', 'Autopilot'},
			{'Shift+S', 'Autopilot with larger cruise speed'},
			{'B', 'Automatic braking'},
			{'C', 'Toggle cargo view'},
			{'J/K', '(when cargo view is enabled) Go through cargo list'},
			{'P', 'Pause'},
			{'PgUp/PgDown', 'zoom in/out'},
			{';', 'Open command prompt, for more advanced commands. Press backspace to close'},
			{'F7', 'Toggle UI visibility'},
		},
	}
end

function help.update(dt)
end

function help.draw()
	local p = help.pages[help.index]
	love.graphics.print(p.title, 10, 40)
	for i=1,#p do
		love.graphics.print(p[i][1], 35, 60 + 30 * i)
		love.graphics.print(p[i][2], 135, 60 + 30 * i)
	end
end
