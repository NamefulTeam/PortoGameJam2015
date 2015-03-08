placeable_utils = require 'placeables'
watcher = require 'watcher'
wall = require 'wall'
diverter = require 'diverter'
exports = {}

function exports.setup(grid_state)
	assert(not grid_state.is_setup)

	grid_state:add_object(watcher(6, 3, directions.DOWN))
	grid_state:add_object(glider(13, 4, directions.LEFT))
	grid_state:add_object(glider(15, 4, directions.DOWN))
	grid_state:add_object(watcher(15, 3, directions.DOWN))

	grid_state:add_tile(diverter(3, 1, directions.RIGHT))
	grid_state:add_tile(diverter(4, 1, directions.DOWN))
	grid_state:add_tile(diverter(1, 5, directions.DOWN))
	grid_state:add_tile(diverter(1, 10, directions.RIGHT))
	grid_state:add_tile(diverter(15, 10, directions.LEFT))

	grid_state.is_setup = true

	local placeable = {}
	placeable_utils.add_placeableblock(placeable, 2,6,2,5)
	grid_state.placeable = placeable_utils.get_single_cell_list(placeable)
end

exports.grid_width = 15
exports.grid_height = 10
exports.number_of_rounds = 4

return exports
