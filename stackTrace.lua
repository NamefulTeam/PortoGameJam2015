exports = {}
function exports.draw_stack(grid, x, y, mouse_x, mouse_y)
	love.graphics.setColor(255,0,0)
	--love.graphics.rectangle("fill",x,y, 250,20)
	--love.graphics.setColor(0,0,0)
	love.graphics.print('Unhandled InternalErrorException:', x+5, y+5)
	local index = 1
	local toReturn = nil
	local current_object = grid.first_object
	while current_object ~= nil do
		love.graphics.setColor(0,0,0)
		if mouse_y > y+index*25 and mouse_y < y+index*25 + 20
			and mouse_x > x and mouse_x < x + 250 then
			love.graphics.rectangle("line",x,y+index*25, 250,20)
			toReturn = current_object
		end

		if current_object.type == 'glider' then
			love.graphics.setColor(0,128,0)
		else
			love.graphics.setColor(64,64,255)
		end
		love.graphics.print("  at "..current_object.type..".lua: line "..current_object.x.." column "..current_object.y, x+5, y+index*25+5)
		current_object = current_object.next
		index = index + 1
	end
end

return exports