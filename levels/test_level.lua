placeable_utils = require 'placeables'
exports = {}

function exports.setup(grid_state)
	for watcherI=1, 5 do
		grid_state:add_object(watcher(math.random(1, grid_state.width), math.random(1, grid_state.height), directions.DOWN))
	end

	local placeable = {}
	placeable_utils.add_placeableblock(placeable, 2,2,4,3)
	placeable_utils.add_placeableblock(placeable, 5,5,2,4)
	grid_state.placeable = placeable_utils.get_single_cell_list(placeable)
end

exports.number_of_rounds = 5

return exports
