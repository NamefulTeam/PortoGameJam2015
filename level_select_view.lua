-- imports
local active_screen = require 'active_screen'
local game_view = require 'game_view'
local level_list = require 'level_list'

function exports()
	local instance = {}

	local backButton = love.graphics.newImage('level_select/back.png')
	local backX = 20
	local backY = 600
	local backWidth = 300
	local backHeight = 100

	function instance:update()
		local mouse_x, mouse_y = love.mouse.getPosition()
		
		if love.mouse.isDown('l') then
			if mouse_x >= backX and mouse_y >= backY and mouse_x < backX + backWidth and mouse_y < backY + backHeight then
				active_screen.set(require('initial_menu_view')())
			end
		end
	end

	function instance:draw()
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle('fill', 0, 0, 1280, 720)

		love.graphics.draw(backButton, backX, backY)
	end

	return instance
end

return exports
