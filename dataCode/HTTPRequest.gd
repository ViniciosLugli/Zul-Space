extends Node

const Firebaselink = "https://***REMOVED***.firebaseio.com/"
const FirebaseAPIKey = ".json?auth=***REMOVED***"
#const Firebaselink = "https://***REMOVED***.firebaseio.com/"
#const FirebaseAPIKey = ".json?auth=***REMOVED***"
const comm = "UsersData/"
const use_ssl = true

var GeralServer_RequestCoolDown = OS.get_ticks_msec()
var User_RequestCoolDown = OS.get_ticks_msec()
var User_ConfigCoolDown = OS.get_ticks_msec()
var GeralGetData_RequestCoolDown = OS.get_ticks_msec()
var interador = ""
var UserData_Result = null
var GeralServerData_Result = null
var GeralGetData_Result = null
var GeralGetData_Result1 = null
var Value_To_Set_Zulcoins = 0
var Value_To_Set_HighScore = 0
var requesting_version = false
var requesting_user = false
var trying = 0
var Command = 0
var Command1 = 0

func Get(Keydb, _Command):
	Command = _Command
	$WEB_GeralGetData.request(Firebaselink+comm+str(get_node("/root/Main").User_account)+"/"+Keydb+FirebaseAPIKey, [], use_ssl, HTTPClient.METHOD_GET)

func Get1(Keydb, _Command):
	Command1 = _Command
	$WEB_GeralGetData1.request(Firebaselink+comm+str(get_node("/root/Main").User_account)+"/"+Keydb+FirebaseAPIKey, [], use_ssl, HTTPClient.METHOD_GET)

func Put(Keydb, value):
	$WEB_GeralPutData.request(Firebaselink+comm+str(get_node("/root/Main").User_account)+"/"+Keydb+FirebaseAPIKey, [], use_ssl, HTTPClient.METHOD_PUT, value)

func Put1(Keydb, value):
	$WEB_GeralPutData1.request(Firebaselink+comm+str(get_node("/root/Main").User_account)+"/"+Keydb+FirebaseAPIKey, [], use_ssl, HTTPClient.METHOD_PUT, value)

func Verify_Command(_Command):
	if(_Command == 0):#nada
		return
	elif(_Command == 1):#nome
		get_node("/root/Main").User_Name = GeralGetData_Result
	elif(_Command == 2):#zulcoins
		get_node("/root/Main").User_zulcoins = GeralGetData_Result
		SetterZulcoins(GeralGetData_Result)
	elif(_Command == 3):#score
		get_node("/root/Main").User_HighScore = GeralGetData_Result
		SetterHighScore(GeralGetData_Result)
	elif(_Command == 4):#user config init
		if(not(get_node("/root/Main").Config_verified)):
			get_node("/root/Main").Config_verified = true
			get_node("/root/Main").Quality_select = GeralGetData_Result["Quality"]#config
			get_node("/root/Main").Volume_master = GeralGetData_Result["Volume"]#config
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), get_node("/root/Main").Volume_master)
			if(get_node("/root/Main").Quality_select == "low"):
				if(get_node_or_null("/root/Main/WorldEnvironment") != null):
					get_node("/root/Main/WorldEnvironment").call_deferred('free')
			elif(get_node("/root/Main").Quality_select == "medium"):
				if(get_node_or_null("/root/Main/WorldEnvironment") == null):
					get_node("/root/Main").call_deferred("add_child", load("res://WorldEnvironment.tscn").instance())
	elif(_Command == 5):
		pass

func Verify_Command1(_Command):
	if(_Command == 0):#nada
		return
	elif(_Command == 1):#nome
		get_node("/root/Main").User_Name = GeralGetData_Result1
	elif(_Command == 2):#zulcoins
		get_node("/root/Main").User_zulcoins = GeralGetData_Result1
		SetterZulcoins(GeralGetData_Result1)
	elif(_Command == 3):#score
		get_node("/root/Main").User_HighScore = GeralGetData_Result1
		SetterHighScore(GeralGetData_Result1)
	elif(_Command == 4):#user config init
		if(not(get_node("/root/Main").Config_verified)):
			get_node("/root/Main").Config_verified = true
			get_node("/root/Main").Quality_select = GeralGetData_Result1["Quality"]#config
			get_node("/root/Main").Volume_master = GeralGetData_Result1["Volume"]#config
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), get_node("/root/Main").Volume_master)
			if(get_node("/root/Main").Quality_select == "low"):
				if(get_node_or_null("/root/Main/WorldEnvironment") != null):
					get_node("/root/Main/WorldEnvironment").call_deferred('free')
			elif(get_node("/root/Main").Quality_select == "medium"):
				if(get_node_or_null("/root/Main/WorldEnvironment") == null):
					get_node("/root/Main").call_deferred("add_child", load("res://WorldEnvironment.tscn").instance())
	elif(_Command == 5):
		pass

func SetterConfig():
	if(OS.get_ticks_msec() > User_ConfigCoolDown):
		var temp_json = {"Quality": get_node("/root/Main").Quality_select, "Volume": get_node("/root/Main").Volume_master}
		var query = JSON.print(temp_json, "", false)
		Put("config", query)
		User_ConfigCoolDown = OS.get_ticks_msec() + 1000

func GetConfig():
	if(get_node("/root/Main").Config_verified):
		return
	Get("config", 4)

func Verify_login(user_id):
	if(OS.get_ticks_msec() > User_RequestCoolDown):
		$WEB_UserData.request(Firebaselink+comm+str(user_id)+FirebaseAPIKey, [], use_ssl, HTTPClient.METHOD_GET)
		User_RequestCoolDown = OS.get_ticks_msec() + 1000 + (trying * 300)
		trying += 1
	else:
		requesting_user = false

func GetVersion():
	## And load config
	if(OS.get_ticks_msec() > GeralServer_RequestCoolDown):
		requesting_version = true
		$WEB_GeralServerData.request(Firebaselink+"ServerData"+FirebaseAPIKey, [], use_ssl, HTTPClient.METHOD_GET)
		GeralServer_RequestCoolDown = OS.get_ticks_msec() + 300
	else:
		requesting_version = false

func Reload_Zulcoins():
	Get("Zulcoins", 2)

func Reload_HighScore():
	Get1("HighValues/Zulcoins", 3)

func PutValuesPlayer(Value):
	Value_To_Set_Zulcoins = Value
	Value_To_Set_HighScore = Value
	Get("Zulcoins", 2)
	Get1("HighValues/Zulcoins", 3)

func SetterHighScore(Local_value):
	if(Value_To_Set_HighScore > 0):
		if(Value_To_Set_HighScore > Local_value):
			Put1("HighValues/Zulcoins", str(Value_To_Set_HighScore))
			Value_To_Set_HighScore = 0

func SetterZulcoins(Local_value):
	if(Value_To_Set_Zulcoins > 0):
		Put("Zulcoins", str(Local_value + Value_To_Set_Zulcoins))
		Value_To_Set_Zulcoins = 0

func _ready():
	$WEB_UserData.connect("request_completed", self, "UserData_Signal")
	$WEB_GeralServerData.connect("request_completed", self, "GeralServerData_Signal")
	$WEB_GeralGetData.connect("request_completed", self, "GeralGetData_Signal")
	$WEB_GeralGetData1.connect("request_completed", self, "GeralGetData_Signal1")

func offline_msg():
	get_node("/root/Main").msgexit("Verifique sua conexão com a internet, o Zul Space não conseguiu se conectar ao servidores... Caso persista, contate um administrador", "Sem conexão com a rede")

func UserData_Signal(result, response_code, headers, body):
#	print("REQUEST: UserData_Signal")
	if(response_code == 0):
		offline_msg()
	if(result == HTTPRequest.RESULT_SUCCESS):
		if(response_code == 200):
			var temp = JSON.parse(body.get_string_from_utf8())
			UserData_Result = temp.result
		else:
			UserData_Result = null
#	print("Response: ", response_code)
#	print("UserData_Result: ", UserData_Result)
	requesting_user = false

func GeralServerData_Signal(result, response_code, headers, body):
#	print("REQUEST: GeralServerData_Signal")
	if(response_code == 0):
		offline_msg()
	if(result == HTTPRequest.RESULT_SUCCESS):
		if(response_code == 200):
			var temp = JSON.parse(body.get_string_from_utf8())
			GeralServerData_Result = temp.result
		else:
			GeralServerData_Result = null
	get_node("/root/Main").ServerVersion = GeralServerData_Result["Version"]#version
#	print("Response: ", response_code)
#	print("GeralServerData_Result: ", GeralServerData_Result)
	requesting_version = false

func GeralGetData_Signal(result, response_code, headers, body):
#	print("REQUEST: GeralGetData_Signal_Signal")
	if(response_code == 0):
		offline_msg()
	if(result == HTTPRequest.RESULT_SUCCESS):
		if(response_code == 200):
			var temp = JSON.parse(body.get_string_from_utf8())
			GeralGetData_Result = temp.result 
		else:
			GeralGetData_Result = null
#	print("Response: ", response_code)
#	print("GeralGetData_Signal_Result: ", GeralGetData_Result)
	Verify_Command(Command)
	Command = 0

func GeralGetData_Signal1(result, response_code, headers, body):
#	print("REQUEST: GeralGetData_Signal_Signal")
	if(response_code == 0):
		offline_msg()
	if(result == HTTPRequest.RESULT_SUCCESS):
		if(response_code == 200):
			var temp = JSON.parse(body.get_string_from_utf8())
			GeralGetData_Result1 = temp.result 
		else:
			GeralGetData_Result1 = null
#	print("Response: ", response_code)
#	print("GeralGetData_Signal_Result: ", GeralGetData_Result1)
	Verify_Command1(Command1)
	Command1 = 0
