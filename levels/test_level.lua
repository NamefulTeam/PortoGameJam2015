local watcher = require 'watcher'
local glider = require 'glider'
local wall = require 'wall'

placeable_utils = require 'placeables'
exports = {}

function exports.setup(grid_state)
	assert(not grid_state.is_setup)

	grid_state:add_object(watcher(10, 10, directions.DOWN))
	grid_state:add_object(wall(10, 12, directions.LEFT))
	grid_state:add_object(wall(11, 12, directions.LEFT))
	grid_state:add_object(wall(12, 12, directions.LEFT))

	grid_state.is_setup = true

	local placeable = {}
	placeable_utils.add_placeableblock(placeable, 1,1,100,100)
	--placeable_utils.add_placeableblock(placeable, 5,5,2,4)
	grid_state.placeable = placeable_utils.get_single_cell_list(placeable)
end

exports.grid_width = 20
exports.grid_height = 15
exports.number_of_rounds = 5

return exports
