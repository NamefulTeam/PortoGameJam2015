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
		assert(direction == exports.UP or direction == exports.DOWN)
		return 0
	end
end

function exports.get_y_diff(direction)
	if direction == exports.UP then
		return -1
	elseif direction == exports.DOWN then
		return 1
	else
		assert(direction == exports.LEFT or direction == exports.RIGHT)
		return 0
	end
end

function exports.get_angle(direction)
	if direction == exports.RIGHT then
		return 0
	elseif direction == exports.LEFT then
		return math.pi
	elseif direction == exports.UP then
		return 3 * math.pi / 2
	elseif direction == exports.DOWN then
		return math.pi / 2
	else
		assert(false)
	end
end

function exports.invert(direction)
	if direction == exports.UP then
		return exports.DOWN
	elseif direction == exports.DOWN then
		return exports.UP
	elseif direction == exports.RIGHT then
		return exports.LEFT
	elseif direction == exports.LEFT then
		return exports.RIGHT
	else
		assert(false)
	end
end

function exports.rotate_clockwise(direction)
	if direction == exports.UP then
		return exports.RIGHT
	elseif direction == exports.RIGHT then
		return exports.DOWN
	elseif direction == exports.DOWN then
		return exports.LEFT
	elseif direction == exports.LEFT then
		return exports.UP
	else
		assert(false)
	end
end

return exports
