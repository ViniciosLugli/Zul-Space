extends Node

func _ready():
	pass

func _process(delta):
	if(Input.is_action_pressed("escape_game") and not(get_node("/root/Main/Game").is_game_over)):
		get_tree().paused = not(get_tree().paused)
		if(get_tree().paused):
			$VisualPause.visible = true
		else:
			$VisualPause.visible = false
