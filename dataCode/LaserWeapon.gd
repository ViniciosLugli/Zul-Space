extends Node2D
var laser_scene = load("res://Objects/Laser.tscn")
var shoot_type = 0
var lazer_type = 0

func _ready():
	pass
func shoot():
	if(shoot_type == 0):
		var laser1 = laser_scene.instance()
		laser1.color_type = lazer_type
		laser1.global_position = Vector2(self.global_position.x, self.global_position.y - 15)
		get_node("/root/Main/Game").add_child(laser1)
	elif(shoot_type == 1):
		var laser1 = laser_scene.instance()
		var laser2 = laser_scene.instance()
		laser1.global_position = Vector2(self.global_position.x - 15, self.global_position.y - 15)
		laser2.global_position = Vector2(self.global_position.x + 15, self.global_position.y - 15)
		laser1.color_type = lazer_type
		laser2.color_type = lazer_type
		get_node("/root/Main/Game").add_child(laser1)
		get_node("/root/Main/Game").add_child(laser2)
	elif(shoot_type == 2):
		var laser1 = laser_scene.instance()
		var laser2 = laser_scene.instance()
		var laser3 = laser_scene.instance()
		laser1.global_position = Vector2(self.global_position.x - 10, self.global_position.y - 10)
		laser2.global_position = Vector2(self.global_position.x, self.global_position.y - 15)
		laser3.global_position = Vector2(self.global_position.x + 10, self.global_position.y - 10)
		laser1.rotation_degrees = -10
		laser2.rotation_degrees = 0
		laser3.rotation_degrees = 10
		laser1.direction = Vector2(-0.2, -1)
		laser3.direction = Vector2(0.2, -1)

		laser1.color_type = lazer_type
		laser2.color_type = lazer_type
		laser3.color_type = lazer_type
		get_node("/root/Main/Game").add_child(laser1)
		get_node("/root/Main/Game").add_child(laser2)
		get_node("/root/Main/Game").add_child(laser3)
	elif(shoot_type == 3):
		var laser1 = laser_scene.instance()
		var laser2 = laser_scene.instance()
		var laser3 = laser_scene.instance()
		var laser4 = laser_scene.instance()
		laser1.global_position = Vector2(self.global_position.x - 15, self.global_position.y - 15)
		laser2.global_position = Vector2(self.global_position.x + 15, self.global_position.y - 15)
		laser3.global_position = Vector2(self.global_position.x - 15, self.global_position.y - 10)
		laser4.global_position = Vector2(self.global_position.x + 15, self.global_position.y - 10)
		laser3.rotation_degrees = -10
		laser4.rotation_degrees = 10
		laser3.direction = Vector2(-0.2, -1)
		laser4.direction = Vector2(0.2, -1)
		laser1.color_type = lazer_type
		laser2.color_type = lazer_type
		laser3.color_type = lazer_type
		laser4.color_type = lazer_type
		get_node("/root/Main/Game").add_child(laser1)
		get_node("/root/Main/Game").add_child(laser2)
		get_node("/root/Main/Game").add_child(laser3)
		get_node("/root/Main/Game").add_child(laser4)
