placeable_utils = require 'placeables'
watcher = require 'watcher'
wall = require 'wall'
diverter = require 'diverter'
exports = {}

function exports.setup(grid_state)
	assert(not grid_state.is_setup)

	grid_state:add_object(watcher(8, 5, directions.UP))
	grid_state:add_object(watcher(1, 5, directions.DOWN))

	grid_state:add_tile(diverter(1, 1, directions.DOWN))
	grid_state:add_tile(diverter(1, 2, directions.DOWN))
	grid_state:add_tile(diverter(15, 1, directions.DOWN))
	grid_state:add_tile(diverter(15, 2, directions.DOWN))
	grid_state:add_tile(diverter(8, 6, directions.LEFT))
	grid_state.is_setup = true

	local placeable = {}
	placeable_utils.add_placeableblock(placeable, 6,1,5,3)
	grid_state.placeable = placeable_utils.get_single_cell_list(placeable)
end

exports.grid_width = 15
exports.grid_height = 10
exports.number_of_rounds = 3

return exports
