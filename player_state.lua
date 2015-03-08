function exports(round_num)

	local player = {}
	player.numberOfRounds = round_num
	player.gameOver = false
	player.won = false
	player.noMoreRounds = false

	function player:endRound()

		player.numberOfRounds = player.numberOfRounds - 1

		if player.numberOfRounds == 0 then
			player.noMoreRounds = true
		end
	end

	return player
end

return exports