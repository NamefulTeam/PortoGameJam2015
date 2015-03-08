placeable_utils = require 'placeables'
exports = {}

function exports.setup(grid_state)
	assert(not grid_state.is_setup)

	grid_state:add_object(watcher(math.random(1, grid_state.width), math.random(1, grid_state.height), directions.DOWN))

	grid_state.is_setup = true

	local placeable = {}
	placeable_utils.add_placeableblock(placeable, 1,1,100,100)
	--placeable_utils.add_placeableblock(placeable, 5,5,2,4)
	grid_state.placeable = placeable_utils.get_single_cell_list(placeable)
end

exports.number_of_rounds = 5

return exports
