extends KinematicBody2D

signal laser_shoot_signal
signal player_died
signal hit_on_zul

var points_scored_scene := load("res://UI/PointsScored.tscn")

var timer_shoot = Timer.new()
var speed = 650
var shoot_delay = 0.30
var can_shot = true
var exploding = false
var mouse_position = null
var lifes = 20
var last_hit = OS.get_ticks_msec()
var default_face = "static"
var is_max_lifes = false
var is_max_attackSpeed = false
var last_life_powerup = OS.get_ticks_msec()
var last_attackSpeed_powerup = OS.get_ticks_msec()
var last_MoreAttack_powerup = OS.get_ticks_msec()

#Textures
export(Texture) var static_zul
export(Texture) var sick_zul
export(Texture) var mouthOpen_zul
export(Texture) var devil_zul
export(Texture) var angry_zul
#

var player_explosion_scene = load("res://Objects/ParticlesPlayerExplosion.tscn")
var player_hit_scene = load("res://Objects/ParticlesPlayerHit.tscn")

func _ready():
	_face(default_face)
	$LaserWeapon.lazer_type = 0
	var camera = get_parent().get_node("MainCamera")
	self.connect("laser_shoot_signal", camera, "on_Player_laser_shoot")
	self.connect("hit_on_zul", camera, "on_Player_hit")
	var game = get_parent()
	self.connect("player_died", game, "on_Player_player_died")

	timer_shoot.set_one_shot(true)
	update_shoot_delay(shoot_delay)
	timer_shoot.connect("timeout", self, "on_time_complete")
	self.call_deferred("add_child", timer_shoot)
	_update_lifes_gui()

func _physics_process(_delta: float) -> void:
	if(exploding):	return
	var velocity := Vector2(0,0)

	if(Input.is_action_pressed("ui_left") and not(Input.is_action_pressed("ui_right"))):
		velocity.x = -speed
	if(Input.is_action_pressed("ui_right") and not(Input.is_action_pressed("ui_left"))):
		velocity.x = speed
	if(Input.is_action_pressed("shoot") and can_shot):
		if(default_face != "devil"):
			_face("mouthOpen")
		emit_signal("laser_shoot_signal")
		$LaserWeapon.shoot()
		can_shot = false
		timer_shoot.start()
	#get_node("/root/Main/Game").last_zul_pos = self.position
	move_and_collide(velocity * _delta)

func _face(face_name):
	if(face_name == "static"):
		$Sprite.texture = static_zul
	elif(face_name == "sick"):
		$Sprite.texture = sick_zul
	elif(face_name == "mouthOpen"):
		$Sprite.texture = mouthOpen_zul
	elif(face_name == "devil"):
		$Sprite.texture = devil_zul
	elif(face_name == "angry"):
		$Sprite.texture = angry_zul

func update_shoot_delay(time_shoot):
	timer_shoot.set_wait_time(time_shoot)

func on_time_complete():
	can_shot = true
	_face(default_face)


func explode():
	exploding = true
	var explosion = player_explosion_scene.instance()
	$MusicPlayer.stop()
	explosion.position = self.position
	get_parent().add_child(explosion)
	$xfxZul.play_dead()
	explosion.emitting = true
	$Sprite.visible = false
	self.position = Vector2(-10, -10)
	get_parent().get_node("GUI/MarginContainer/Life1").visible = false
	get_parent().get_node("GUI/MarginContainer/Life2").visible = false
	get_parent().get_node("GUI/MarginContainer/Life3").visible = false
	$SlowMotionTimer.start()
	Engine.time_scale = 0.2
		
func _update_lifes_gui():
	if((20 - lifes) == 0):
		get_parent().get_node("GUI/MarginContainer/Life1").visible = false
		get_parent().get_node("GUI/MarginContainer/Life2").visible = false
		get_parent().get_node("GUI/MarginContainer/Life3").visible = false
	elif((20 - lifes) == 1):
		get_parent().get_node("GUI/MarginContainer/Life1").visible = true
		get_parent().get_node("GUI/MarginContainer/Life2").visible = false
		get_parent().get_node("GUI/MarginContainer/Life3").visible = false
	elif((20 - lifes) == 2):
		get_parent().get_node("GUI/MarginContainer/Life1").visible = true
		get_parent().get_node("GUI/MarginContainer/Life2").visible = true
		get_parent().get_node("GUI/MarginContainer/Life3").visible = false
	elif((20 - lifes) == 3):
		get_parent().get_node("GUI/MarginContainer/Life1").visible = true
		get_parent().get_node("GUI/MarginContainer/Life2").visible = true
		get_parent().get_node("GUI/MarginContainer/Life3").visible = true

func _on_SlowMotionTimer_timeout():
	Engine.time_scale = 1
	emit_signal("player_died")
	self.call_deferred('free')

func _spawn_popup_powerup(Type_name):
	var points_scored = points_scored_scene.instance()
	var temp_text = ""
	if(Type_name  == "LifePowerUp"):
		temp_text = "+1 Vida"
	elif(Type_name  == "MoreAttackPowerUp"):
		temp_text = "+ Lasers de ataque"
	elif(Type_name  == "AttackSpeedPowerUp"):
		temp_text = "+ Velocidade de ataque"
	elif(Type_name  == "DemonAttack"):
		temp_text = "Laser melhorado por 10 segundos"
	points_scored.get_node("Label").text = temp_text
	points_scored.get_node("Label").set("custom_colors/font_color", Color(0, 0.9, 0.1))
	points_scored.position = self.position
	points_scored.position.y -= 50
	points_scored.position.x -= 25 + (points_scored.get_node("Label").get_total_character_count() * 5)
	points_scored.get_node("Timer").set_wait_time(2)
	get_parent().call_deferred("add_child", points_scored)

func _check_powerup(type):
	if(type == "AttackSpeedPowerUp"):
		if(last_attackSpeed_powerup > OS.get_ticks_msec()):
			return
		shoot_delay -= 0.02
		if(shoot_delay < 0.15):
			shoot_delay = 0.15
			is_max_attackSpeed = true
		elif(shoot_delay > 0.15):
			is_max_attackSpeed = false
		elif(shoot_delay == 0.15):
			is_max_attackSpeed = true
		update_shoot_delay(shoot_delay)
		last_attackSpeed_powerup = OS.get_ticks_msec() + 1500

	elif(type == "MoreAttackPowerUp"):
		if(last_MoreAttack_powerup > OS.get_ticks_msec()):
			return
		if($LaserWeapon.shoot_type < 3):
			$LaserWeapon.shoot_type += 1
			if($LaserWeapon.shoot_type == 3):
				default_face = "devil"
				_face("devil")

		elif($LaserWeapon.shoot_type == 3):
			$LaserWeapon.lazer_type = 1
			$UpgradeLaserTimer.start()
			type = "DemonAttack"
		last_MoreAttack_powerup = OS.get_ticks_msec() + 1500

	elif(type == "LifePowerUp"):
		if(last_life_powerup > OS.get_ticks_msec()):
			return
		if(lifes > 17):
			lifes -= 1
		elif((lifes < 17) or (lifes > 20)):
			lifes = 20
			pass # cheater...
		if(lifes == 17):
			is_max_lifes = true
		else:
			is_max_lifes = false
		_update_lifes_gui()
		last_life_powerup = OS.get_ticks_msec() + 1500
	_spawn_popup_powerup(type)

func _on_Hitbox_body_shape_entered(body_id, body, body_shape, area_shape):
	if(not(self.is_queued_for_deletion()) and body.is_in_group("asteroids") and (OS.get_ticks_msec() > last_hit)):
		emit_signal("hit_on_zul")
		if((20 - lifes) > 0):
			last_hit = OS.get_ticks_msec() + 1500
			_face("sick")
			body.call_deferred("explode")
			self.set_collision_layer(2) 
			lifes += 1
			if(lifes == 17):
				is_max_lifes = true
			else:
				is_max_lifes = false
			var explosion = player_hit_scene.instance()
			explosion.position = self.position
			get_parent().add_child(explosion)
			$xfxZul.play_random_song()
			explosion.emitting = true
			$ZulAnim.play("Damaged")
			$damagedTimer.start()
			_update_lifes_gui()
		else:
			body.call_deferred("explode")
			explode()

	elif(not(self.is_queued_for_deletion()) and body.is_in_group("PowerUp")):
		body.call_deferred("gotted")
		_check_powerup(body.get_name())
		


func _on_damagedTimer_timeout():
	_face(default_face)
	self.set_collision_layer(3) 

func _on_UpgradeLaserTimer_timeout():
	$LaserWeapon.lazer_type = 0
