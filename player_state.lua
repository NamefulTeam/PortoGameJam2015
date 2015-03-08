function exports(glider_num)

	local player = {}
	player.numberOfGliders = glider_num
	player.gameOver = false
	player.won = false
	player.noMoreGliders = false

	function player:placeGlider()

		player.numberOfGliders = player.numberOfGliders - 1

		if player.numberOfGliders == 0 then
			player.noMoreGliders = true
		end
	end

	return player
end

return exports