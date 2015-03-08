exports = {}

function exports.setup(grid_state)
	for watcherI=1, 5 do
		grid_state:add_object(watcher(math.random(1, grid_state.width), math.random(1, grid_state.height), directions.DOWN))
	end
end

exports.number_of_rounds = 5

return exports
