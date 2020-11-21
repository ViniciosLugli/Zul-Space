extends Control

var InTradeConfig = false
var glow_all_scene = load("res://WorldEnvironment.tscn")
var glowon = false

func _ready():
	$All/AnimationPlayer.play("InText")
	if($All/VolumeSlider.value == -10):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), $All/VolumeSlider.value)
	$All/VolumeSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	if(get_node_or_null("/root/Main/WorldEnvironment") != null):
		$All/MediumOptionButton.pressed = true
		$All/LowOptionButton.pressed = false
	else:
		$All/MediumOptionButton.pressed = false
		$All/LowOptionButton.pressed = true

func _on_ReturnButton_pressed():
	if(InTradeConfig): return
	get_node("/root/Main").get_child(0).SetterConfig()
	InTradeConfig = true
	$All/AnimationPlayer.play("OutText")
	$OutTimer.start()
	get_node("/root/Main").GoToMenu()

func _on_OutTimer_timeout():
	self.call_deferred('free')

func _on_VolumeSlider_value_changed(value):
	if(value == -10):
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	get_node("/root/Main").Volume_master = value

func _on_LowOptionButton_pressed():
	$All/MediumOptionButton.pressed = false
	$All/LowOptionButton.pressed = true
	if(get_node_or_null("/root/Main/WorldEnvironment") != null):
		get_node("/root/Main/WorldEnvironment").call_deferred('free')
	get_node("/root/Main").Quality_select = "low"

func _on_MediumOptionButton_pressed():
	$All/MediumOptionButton.pressed = true
	$All/LowOptionButton.pressed = false
	if(get_node_or_null("/root/Main/WorldEnvironment") == null):
		get_node("/root/Main").call_deferred("add_child", glow_all_scene.instance())
	get_node("/root/Main").Quality_select = "medium"
