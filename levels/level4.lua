placeable_utils = require 'placeables'
watcher = require 'watcher'
wall = require 'wall'
diverter = require 'diverter'
exports = {}

function exports.setup(grid_state)
	assert(not grid_state.is_setup)

	grid_state:add_object(watcher(5, 4, directions.DOWN))
	grid_state:add_object(watcher(10, 2, directions.RIGHT))

	grid_state:add_tile(diverter(2, 2, directions.RIGHT))
	grid_state:add_tile(diverter(10, 2, directions.LEFT))

	grid_state.is_setup = true

	local placeable = {}
	placeable_utils.add_placeableblock(placeable, 1,8,3,3)
	placeable_utils.add_placeableblock(placeable, 8,8,3,3)
	grid_state.placeable = placeable_utils.get_single_cell_list(placeable)
end

exports.grid_width = 10
exports.grid_height = 10
exports.number_of_rounds = 3

return exports
