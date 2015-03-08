placeable_utils = require 'placeables'
watcher = require 'watcher'
glider = require 'glider'
diverter = require 'diverter'

exports = {}

function exports.setup(grid_state)
	assert(not grid_state.is_setup)

	grid_state:add_tile(diverter(1, 1, directions.DOWN))
	grid_state:add_tile(diverter(2, 2, directions.DOWN))
	grid_state:add_tile(diverter(3, 3, directions.DOWN))

	grid_state:add_object(watcher(2, 4, directions.LEFT))

	grid_state.is_setup = true

	local placeable = {}
	placeable_utils.add_placeableblock(placeable, 5, 1, 2, 3)
	placeable_utils.add_placeableblock(placeable, 1, 9, 3, 1)
	grid_state.placeable = placeable_utils.get_single_cell_list(placeable)
end

exports.grid_width = 10
exports.grid_height = 10
exports.number_of_rounds = 3

return exports
