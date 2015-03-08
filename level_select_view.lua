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

	local levelButton = love.graphics.newImage('placeholders/watcher.png')

	local levelStartX = 50
	local levelStartY = 100
	local levels = level_list.get_levels()

	local lastFrameMouseClicked = true

	function instance:update()
		local mouse_x, mouse_y = love.mouse.getPosition()
		
		local mouseClicked = love.mouse.isDown('l')

		if mouseClicked and not lastFrameMouseClicked then
			if mouse_x >= backX and mouse_y >= backY and mouse_x < backX + backWidth and mouse_y < backY + backHeight then
				active_screen.set(require('initial_menu_view')())
			end

			local x = levelStartX
			local y = levelStartY
			for i = 1, #levels do
				x = x + 32

				if mouse_x >= x and mouse_y >= y and mouse_x < x + 32 and mouse_y < y + 32 then
					active_screen.set(game_view(levels[i]))
				end
			end
		end

		lastFrameMouseClicked = mouseClicked
	end

	function instance:draw()
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle('fill', 0, 0, 1280, 720)

		love.graphics.draw(backButton, backX, backY)

		local x = levelStartX
		local y = levelStartY
		for i = 1, #levels do
			x = x + 32

			love.graphics.draw(levelButton, x, y)
		end
	end

	return instance
end

return exports
