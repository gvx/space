mapview = {}

registerstate'mapview'

function mapview.load()
end

function mapview.update(dt)
end

function mapview.draw()
end
 
function mapview.allowsave(key)
	return false
end

function states.mapview.keypressed.escape()
	state.current = 'game'
end

function cmds.map()
	state.current = 'mapview'
end