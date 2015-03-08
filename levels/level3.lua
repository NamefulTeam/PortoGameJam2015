placeable_utils = require 'placeables'
watcher = require 'watcher'
wall = require 'wall'
exports = {}

function exports.setup(grid_state)
	assert(not grid_state.is_setup)

	grid_state:add_object(watcher(6, 10, directions.UP))
	grid_state:add_object(glider(14, 1, directions.LEFT))
	grid_state:add_object(watcher(14, 6, directions.RIGHT))
	grid_state.is_setup = true

	local placeable = {}
	placeable_utils.add_placeableblock(placeable, 1,6,3,5)
	grid_state.placeable = placeable_utils.get_single_cell_list(placeable)
end

exports.grid_width = 15
exports.grid_height = 15
exports.number_of_rounds = 4

return exports
