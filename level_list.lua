local exports = {}
local levels = {}

function add_level(level_name)
	assert(level_name ~= nil)

	local level = require(level_name)

	table.insert(levels, level)
	level.id = #levels
end

function exports.get_levels()
	return levels
end

function exports.first_level()
	return levels[1]
end

function exports.next_level(level)
	assert(level ~= nil)
	assert(level.id ~= nil)

	return levels[level.id + 1]
end

add_level('levels.level1')
add_level('levels.level6')
add_level('levels.level4')
add_level('levels.level3')
add_level('levels.level2')

return exports
