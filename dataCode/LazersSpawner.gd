extends Node

var laser_scene = load("res://Objects/LaserEnemy.tscn")
var laser_spawn_interval = 15
var difficulty_index = 0


func _ready():
	laser_spawn_interval = 15
	difficulty_index = 1.20
	
func _spawn_laser():
	var laser = laser_scene.instance()
	laser.position = Vector2(10, -100)
	self.call_deferred("add_child", laser)
	_set_laser_position(laser)
 
func _set_laser_position(_laser):
	var _zul = get_parent().get_node_or_null("Zul")
	if(_zul == null):
		_laser.position = Vector2(0, 0)
		return
	_laser.position.x = _zul.position.x
	_laser.position.y = -60

func _on_SpawnTimer_timeout():
	_spawn_laser()

func _on_DifficultyTimer_timeout():
	if((float(laser_spawn_interval) / float(difficulty_index)) < 2):
		$SpawnTimer.wait_time = 2
		$DifficultyTimer.stop()
	else:
		$SpawnTimer.wait_time = float(laser_spawn_interval) / float(difficulty_index)
		difficulty_index += 0.2
	
func _on_SpawnTimer1_timeout():
	var laser = laser_scene.instance()
	self.call_deferred("add_child", laser)
	_set_laser_position(laser)
	var rect = get_viewport().size
	randomize()
	laser.position = Vector2(rand_range(50, rect.x - 50), -60)
	laser.position.y = -60

func _on_DifficultyTimer1_timeout():
	var temp_wait = $SpawnTimer1.wait_time
	if(temp_wait - 1 < 2):
		$SpawnTimer1.wait_time = 2
		$DifficultyTimer1.stop()
	else:
		$SpawnTimer1.wait_time -= 1
