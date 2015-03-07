function exports(round_num)

	local player = {}
	player.numberOfRounds = round_num
	player.gameOver = false

	function player:endRound()

		player.numberOfRounds = player.numberOfRounds - 1

		if player.numberOfRounds == 0 then
			player.gameOver = true
		end
	end

	return player
end

return exports