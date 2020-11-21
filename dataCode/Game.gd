extends Node

var is_game_over := false
var player_scene = load("res://Characters/Zul.tscn")
var asteroid_spawner_scene = load("res://Entities/AsteroidSpawner.tscn")
var powerups_spawner_scene = load("res://Entities/PowerUpsSpawner.tscn")
var laser_spawner_scene = load("res://Entities/LaserSpawner.tscn")

func remove_child_by_node(node, child, force = true):
	if force:
		call('_remove_child_by_node', node, child, force)
	else:
		call_deferred('_remove_child_by_node', node, child, force)
	
func _ready() -> void:
	$GameOverLabel.visible = false
	$Zul.visible = true
	$AnimationPlayer.play("InPlayer")
	$MenuSFX.play()
	get_tree().get_root().connect("size_changed", self, "call_wrap_around")

func _on_DelayTimer_timeout():
	$GUI/MarginContainer/HBoxContainer/VBoxContainer/TimeCounter.run = true
	$GUI/MarginContainer/HBoxContainer/VBoxContainer/TimeCounter.reset()
	self.call_deferred("add_child", asteroid_spawner_scene.instance())
	self.call_deferred("add_child", powerups_spawner_scene.instance())
	self.call_deferred("add_child", laser_spawner_scene.instance())

func call_wrap_around():
	get_tree().call_group("wrap_around", "recalculate_wrap_area")

func on_Player_player_died():
	$GUI/MarginContainer/HBoxContainer/VBoxContainer/TimeCounter.run = false
	$GameOverTimer.start()

func _on_GameOverTimer_timeout():
	for TODelet in get_tree().get_nodes_in_group("asteroids"):
		if(not(TODelet.is_queued_for_deletion())):
			TODelet.call_deferred('free')
	for TODelet in get_tree().get_nodes_in_group("PowerUp"):
		if(not(TODelet.is_queued_for_deletion())):
			TODelet.call_deferred('free')
	$AsteroidSpawner.call_deferred('free')
	$PowerUpsSpawner.call_deferred('free')
	$LaserSpawner.call_deferred('free')
	if(($GUI/MarginContainer/HBoxContainer/VBoxContainer/Score.score_1 * 50) > get_node("/root/Main").User_HighScore):
		$GameOverLabel/ScoreLabel.text = "Novo record de " + $GUI/MarginContainer/HBoxContainer/VBoxContainer/Score.text + " Zulcoins lucrados!"
	else:
		$GameOverLabel/ScoreLabel.text = "Você ganhou " + $GUI/MarginContainer/HBoxContainer/VBoxContainer/Score.text + " Zulcoins"
	get_node("/root/Main").get_child(0).PutValuesPlayer($GUI/MarginContainer/HBoxContainer/VBoxContainer/Score.score_1 * 50)
	$GameOverLabel/IfSaveLabel.set("custom_colors/font_color", Color(0,1,0))
	$GameOverLabel/IfSaveLabel.text = "Seu score foi salvo na sua conta"
	$GameOverLabel.visible = true
	is_game_over = true

func _unhandled_input(_event):
	if(is_game_over and _event.is_action_released("restart_game")):
		$MenuSFX.play()
		restart_game()
		$GUI/MarginContainer/HBoxContainer/VBoxContainer/TimeCounter.run = true
		$GUI/MarginContainer/HBoxContainer/VBoxContainer/TimeCounter.reset()
	elif(is_game_over and _event.is_action_released("escape_game")):
		$MenuSFX.play()
		get_node("/root/Main").GoToMenu()
		$AnimationPlayer.play("OutGame")
		$OutTime.start()
	else:
		pass
	
func restart_game():
	_undo_game_over()
	_respawn_player()
	$GUI/MarginContainer/HBoxContainer/VBoxContainer/Score.reset()
	self.call_deferred("add_child", asteroid_spawner_scene.instance())
	self.call_deferred("add_child", powerups_spawner_scene.instance())
	self.call_deferred("add_child", laser_spawner_scene.instance())
	is_game_over = false

func _undo_game_over():
	$GameOverLabel.visible = false 
	$GameOverLabel/ScoreLabel.text = ""

func _respawn_player():
	if(not(is_game_over)): return
	var player = player_scene.instance()
	player.position = Vector2(960, 1020)
	self.call_deferred("add_child", player)


func _on_OutTime_timeout():
	self.call_deferred('free')
