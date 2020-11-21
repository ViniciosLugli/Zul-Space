extends Node

var rng = RandomNumberGenerator.new()
var PowerUp = load("res://Objects/AttackSpeedPowerUp.tscn")
var PowerUp1 = load("res://Objects/MoreAttackPowerUp.tscn")
var PowerUp2 = load("res://Objects/LifePowerUp.tscn")

func _ready():
	$AttackSpeedTimer.connect("timeout", self, "on_time_powerup_attackspeed")
	$MoreAttackTimer.connect("timeout", self, "on_time_powerup_moreattack")
	$LifeTimer.connect("timeout", self, "on_time_powerup_life")
	_reset_timer()
	_reset_timer1()
	_reset_timer2()

func _reset_timer():
	$AttackSpeedTimer.set_one_shot(false)
	rng.randomize()
	$AttackSpeedTimer.set_wait_time(rng.randi_range(12, 14))
	$AttackSpeedTimer.start()

func _reset_timer1():
	$MoreAttackTimer.set_one_shot(false)
	rng.randomize()
	$MoreAttackTimer.set_wait_time(rng.randi_range(16, 18))
	$MoreAttackTimer.start()

func _reset_timer2():
	$LifeTimer.set_one_shot(false)
	rng.randomize()
	$LifeTimer.set_wait_time(rng.randi_range(20, 25))
	$LifeTimer.start()

func on_time_powerup_attackspeed():
	var temp_zul = get_parent().get_node_or_null("Zul")
	if(temp_zul != null):
		if(not(temp_zul.is_max_attackSpeed)):
			var temp_power = PowerUp.instance()
			self.call_deferred("add_child", temp_power)
			randomize()
			var rect = get_viewport().size
			randomize()
			temp_power.position = Vector2(rand_range(50, rect.x - 50), -100)
			temp_power.linear_velocity = Vector2(0, 180)
			temp_power.angular_velocity = 0
			temp_power.angular_damp = 0
			temp_power.linear_damp = 0
	_reset_timer()

func on_time_powerup_moreattack():
	var temp_power = PowerUp1.instance()
	self.call_deferred("add_child", temp_power)
	var rect = get_viewport().size
	randomize()
	temp_power.position = Vector2(rand_range(50, rect.x - 50), -100)
	temp_power.linear_velocity = Vector2(0, 180)
	temp_power.angular_velocity = 0
	temp_power.angular_damp = 0
	temp_power.linear_damp = 0
	_reset_timer1()

func on_time_powerup_life():
	var temp_zul = get_parent().get_node_or_null("Zul")
	if(temp_zul != null):
		if(not(temp_zul.is_max_lifes)):
			var temp_power = PowerUp2.instance()
			self.call_deferred("add_child", temp_power)
			var rect = get_viewport().size
			randomize()
			temp_power.position = Vector2(rand_range(50, rect.x - 50), -100)
			temp_power.linear_velocity = Vector2(0, 180)
			temp_power.angular_velocity = 0
			temp_power.angular_damp = 0
			temp_power.linear_damp = 0
	_reset_timer2()
