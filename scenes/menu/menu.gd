extends Control


func _ready():
	if OS.has_feature('HTML5'):
		$VBoxContainer/ExitButton.queue_free()


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
