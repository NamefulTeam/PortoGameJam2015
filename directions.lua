local exports = {}

exports.UP = 'up'
exports.DOWN = 'down'
exports.LEFT = 'left'
exports.RIGHT = 'right'

function exports.is_direction(direction)
	return direction == exports.UP or
		direction == exports.DOWN or
		direction == exports.LEFT or
		direction == exports.RIGHT
end

function exports.get_x_diff(direction)
	if direction == exports.LEFT then
		return -1
	elseif direction == exports.RIGHT then
		return 1
	else
		return 0
	end
end

function exports.get_y_diff(direction)
	if direction == exports.UP then
		return -1
	elseif direction == exports.DOWN then
		return 1
	else
		return 0
	end
end

return exports
