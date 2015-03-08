exports = {}

function exports.setup(grid_state)
	assert(not grid_state.is_setup)

	grid_state:add_object(watcher(math.random(1, grid_state.width), math.random(1, grid_state.height), directions.DOWN))

	grid_state.is_setup = true
end

exports.number_of_rounds = 5

return exports
