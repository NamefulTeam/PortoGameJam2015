placeable_utils = require 'placeables'
exports = {}

function exports.setup(grid_state)
	assert(not grid_state.is_setup)

	grid_state:add_object(watcher(2, 2, directions.DOWN))
	grid_state:add_object(glider(3, 1, directions.DOWN))

	grid_state.is_setup = true

	local placeable = {}
	placeable_utils.add_placeableblock(placeable, 5,2,1,3)
	grid_state.placeable = placeable_utils.get_single_cell_list(placeable)
end

exports.grid_width = 5
exports.grid_height = 5
exports.number_of_rounds = 1

return exports
