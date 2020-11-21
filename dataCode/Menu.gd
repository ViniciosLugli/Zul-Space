extends Control

var InTrade = false

func _ready():
	$MenuAnimation.play("InTextMenu")
	$TittlesAnimation/TittleAnimation.play("TittleAnim")

func _process(delta):
	$RPC/ZulcoinsLabel.text =  str(get_node("/root/Main").User_zulcoins) + "\n " +str(get_node("/root/Main").User_HighScore)
	$RPC/RPCLabel.text = "Olá " + get_node("/root/Main").User_Name + " :)"
	$RPC/RPCColorRect.color = Color(0, 0.701961, 0.109804)#Color(131, 228, 42, 255)

func _on_PlayButton_pressed():
	if(InTrade): return
	InTrade = true
	get_node("/root/Main").Version_verified = false
	$TittlesAnimation/TittleAnimation.stop()
	$MenuAnimation.play("OutTextMenu")
	$OutTimer.start()
	get_node("/root/Main").GoToGame()

func _on_Timer_timeout():
	self.call_deferred('free')

func _on_ConfigButton_pressed():
	if(InTrade): return
	InTrade = true
	$TittlesAnimation/TittleAnimation.stop()
	$MenuAnimation.play("OutTextMenu")
	$OutTimer.start()
	get_node("/root/Main").GoToConfigMenu()
	
func _on_ExitButton_pressed():
	get_tree().quit()

func _on_ReloadRPCButton_pressed():
	if(InTrade): return
	InTrade = true
	$TittlesAnimation/TittleAnimation.stop()
	$MenuAnimation.play("OutTextMenu")
	$OutTimer.start()
	get_node("/root/Main").GoToLogin()
