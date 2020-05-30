extends CanvasLayer

signal start_game

func show_message(text):
    $Message.text = text
    $Message.show()
    $MessageTimer.start()

func show_game_over():
    $Leaderboard.add_score(int($ScoreLabel.text))

    show_message("Game Over")

    yield($MessageTimer, "timeout")

    $Message.text = "Dodge the\nCreeps!"
    $Leaderboard.show()
    $LeaderboardTimer.start()

    yield(get_tree().create_timer(1), "timeout")
    $StartButton.show()

func update_score(score):
    $ScoreLabel.text = str(score)


func _on_StartButton_pressed():
    $StartButton.hide()
    emit_signal("start_game")

    $Leaderboard.hide()
    $LeaderboardTimer.stop()


func _on_MessageTimer_timeout():
    $Message.hide()


func _on_LeaderboardTimer_timeout():
    $Message.visible = !$Message.visible
    $Leaderboard.visible = !$Leaderboard.visible
