extends Control


func _ready():
	if OS.has_feature('HTML5'):
		$VBoxContainer/ExitButton.queue_free()
	print("Oh hello fellow developer!")
	print("Follow me at https://twitter.com/mashumafi")
	print("Find the source code here: https://github.com/mashumafi/lt1gt")

func _on_ExitButton_pressed() -> void:
	# gently shutdown the game
	var transitions = get_node_or_null("/root/Transitions")
	if transitions:
		transitions.fade_in({
			'show_progress_bar': false
		})
		yield(transitions.anim, "animation_finished")
		yield(get_tree().create_timer(0.3), "timeout")
	get_tree().quit()


func _basic_pressed():
	var params = {
		show_progress_bar = false
	}
	Game.change_scene("res://basic/game.tscn", params)


func _updown_pressed():
	var params = {
		show_progress_bar = false
	}
	Game.change_scene("res://updown/game.tscn", params)


func _match_pressed():
	var params = {
		show_progress_bar = false
	}
	Game.change_scene("res://match3/game.tscn", params)
