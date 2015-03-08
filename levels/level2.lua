placeable_utils = require 'placeables'
exports = {}

function exports.setup(grid_state)
	assert(not grid_state.is_setup)

	grid_state:add_object(watcher(14, 1, directions.DOWN))
	grid_state.is_setup = true

	local placeable = {}
	placeable_utils.add_placeableblock(placeable, 1,4,2,4)
	placeable_utils.add_placeableblock(placeable, 19,4,2,4)
	grid_state.placeable = placeable_utils.get_single_cell_list(placeable)
end

exports.grid_width = 20
exports.grid_height = 10
exports.number_of_rounds = 3

return exports
