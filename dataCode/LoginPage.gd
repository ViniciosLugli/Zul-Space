extends Control

var User_ID = 0
var request_att = false

var default_path = "user://ZSLocalData.dat"
var default_dict = {"local_ID":"0"}

func _ready():
	var localdata = load_temp()
	if((localdata).length() == 18):
		$IdBox.text = localdata
	$AnimationPlayer.play("InLoginMenu")

func _process(delta):
	if(request_att and not(get_node("/root/Main").get_child(0).requesting_user)):
		request_att = false
		var temp_result = get_node("/root/Main").get_child(0).UserData_Result
		if(typeof(temp_result) == TYPE_DICTIONARY):
			aproved_login()
		else:
			reproved_login()

func load_temp():
	var file = File.new()
	if(file.file_exists(default_path)):
		var error = file.open(default_path, File.READ)
		if(error == OK):
			var temp_data_ID = file.get_var()
			file.close()
			return temp_data_ID["local_ID"]
	else:
		var error = file.open(default_path, File.WRITE)
		if(error == OK):
			file.store_var(default_dict)
			file.close()

func save_temp():
	var file = File.new()
	var error = file.open(default_path, File.WRITE)
	if(error == OK):
		default_dict["local_ID"] = $IdBox.text
		file.store_var(default_dict)
		file.close()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		enter_login($IdBox.text)

func _on_LoginButton_pressed():
	enter_login($IdBox.text)

func enter_login(Value_ID):
	if(request_att):
		return
	if((Value_ID).length() == 18):
		get_node("/root/Main").get_child(0).requesting_user = true
		request_att = true
		get_node("/root/Main").get_child(0).Verify_login(Value_ID)
	elif((Value_ID).length() > 0):
		$MessageLabel.set("custom_colors/font_color", Color(1, 0, 0))
		$MessageLabel.text = "Tamanho de ID não correspondido ao padrão"
	else:
		$MessageLabel.set("custom_colors/font_color", Color(1, 0, 0))
		$MessageLabel.text = "Campo de preenchimento de ID vazio"

func reproved_login():
	$MessageLabel.set("custom_colors/font_color", Color(1, 0, 0))
	$MessageLabel.text = "Login recusado! Verifique o ID inserido, caso persistir, contate um administrador"

func aproved_login():
	save_temp()
	$MessageLabel.set("custom_colors/font_color", Color(0, 1, 0))
	$MessageLabel.text = "Login aprovado!"
	var temp_result = get_node("/root/Main").get_child(0).UserData_Result
	var User_zulcoins = 0
	var User_Name = ""
	var User_HighScore = 0
	get_node("/root/Main").get_child(0).trying = 1
	get_node("/root/Main").User_account = $IdBox.text
	get_node("/root/Main").User_zulcoins = temp_result["Zulcoins"]
	get_node("/root/Main").User_Name = temp_result["Name"]
	get_node("/root/Main").User_HighScore = temp_result["HighValues"]["Zulcoins"]
	if(not(get_node("/root/Main").Config_verified)):
			get_node("/root/Main").Config_verified = true
			get_node("/root/Main").Quality_select = temp_result["config"]["Quality"]#config
			get_node("/root/Main").Volume_master = temp_result["config"]["Volume"]#config
			if(get_node("/root/Main").Volume_master == -10):
				AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
			else:
				AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), get_node("/root/Main").Volume_master)
			if(get_node("/root/Main").Quality_select == "low"):
				if(get_node_or_null("/root/Main/WorldEnvironment") != null):
					get_node("/root/Main/WorldEnvironment").call_deferred('free')
			elif(get_node("/root/Main").Quality_select == "medium"):
				if(get_node_or_null("/root/Main/WorldEnvironment") == null):
					get_node("/root/Main").call_deferred("add_child", load("res://WorldEnvironment.tscn").instance())
	$AnimationPlayer.play("OutLoginMenu")
	$OutTimer.start()
	get_node("/root/Main").GoToMenu()

func _on_OutTimer_timeout():
	self.call_deferred('free')
