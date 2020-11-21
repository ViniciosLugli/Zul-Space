extends Node

const Version = "1.2.0"

var Menu_Scene = load("res://mainScenes/Menu.tscn")
var ConfigMenu_Scene = load("res://mainScenes/ConfigMenu.tscn")
var Game_Scene = load("res://mainScenes/Game.tscn")
var Login_Scene = load("res://mainScenes/LoginPage.tscn")

var musicOn = false
var inOn = null
var ServerVersion = ""
var Version_verified = false
var Config_verified = false

#User variables
var User_account = ""
var User_zulcoins = 0
var User_Name = ""
var User_HighScore = 0
#config
var Volume_master = 1
var Quality_select = "low"
#

func _ready():
	OS.set_window_size(Vector2(OS.get_window_size()))
	var screen_size = OS.get_screen_size(OS.get_current_screen())
	var window_size = OS.get_window_size()
	var centered_pos = (screen_size - window_size) / 2
	OS.set_window_position(centered_pos)
	OS.window_maximized = true
	GoToLogin()

func GoToMenu():
	if(not(musicOn)):
		musicOn = true
		$BackgroundSong.play()
	if(inOn == "menu"): return
	inOn = "menu"
	self.add_child(Menu_Scene.instance())

func GoToConfigMenu():
	if(not(musicOn)):
		musicOn = true
		$BackgroundSong.play()
	if(inOn == "configmenu"): return
	inOn = "configmenu"
	self.add_child(ConfigMenu_Scene.instance())

func GoToGame():
	if(musicOn):
		musicOn = false
		$BackgroundSong.stop()
	if(inOn == "game"): return
	inOn = "game"
	self.add_child(Game_Scene.instance())

func GoToLogin():
	if(musicOn):
		musicOn = false
		$BackgroundSong.stop()
	if(inOn == "Login"): return
	inOn = "Login"
	self.add_child(Login_Scene.instance())

func msgexit(msg, title):
	OS.alert(msg, title)
	get_tree().quit()
