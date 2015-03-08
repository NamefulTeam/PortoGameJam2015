placeable_utils = require 'placeables'
watcher = require 'watcher'
glider = require 'glider'
diverter = require 'diverter'

exports = {}

function exports.setup(grid_state)
	assert(not grid_state.is_setup)

	grid_state:add_tile(diverter(10, 1, directions.DOWN))
	grid_state:add_tile(diverter(9, 2, directions.DOWN))

	grid_state:add_tile(diverter(10, 10, directions.LEFT))
	grid_state:add_tile(diverter(9, 9, directions.LEFT))

	grid_state:add_tile(diverter(1, 10, directions.UP))
	grid_state:add_tile(diverter(2, 9, directions.UP))

	grid_state:add_tile(diverter(1, 3, directions.RIGHT))
	grid_state:add_tile(diverter(2, 4, directions.RIGHT))

	grid_state:add_tile(diverter(4, 6, directions.RIGHT))
	grid_state:add_tile(diverter(6, 6, directions.LEFT))

	grid_state:add_tile(diverter(8, 3, directions.DOWN))
	grid_state:add_tile(diverter(7, 4, directions.DOWN))

	grid_state:add_object(watcher(5, 6, directions.LEFT))

	grid_state.is_setup = true

	local placeable = {}
	placeable_utils.add_placeableblock(placeable, 1, 1, 2, 2)
	grid_state.placeable = placeable_utils.get_single_cell_list(placeable)
end

exports.grid_width = 10
exports.grid_height = 10
exports.number_of_rounds = 2

return exports
