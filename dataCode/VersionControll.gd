extends Control

var server_version = ""
var local_verf = false
func _ready():
	if(not get_node("/root/Main").Version_verified):
		get_node("/root/Main").get_child(0).GetVersion()
	else:
		$InfoLabel.text = get_node("/root/Main").Version
		$InfoLabel.set("custom_colors/font_color", Color(0, 1, 0))

func _process(delta):
	if(not get_node("/root/Main").Version_verified and not local_verf):
		if(not get_node("/root/Main").get_child(0).requesting_version):
			if(get_node("/root/Main").ServerVersion == get_node("/root/Main").Version):
				get_node("/root/Main").Version_verified = true
				Updated()
				local_verf = true
			else:
				get_node("/root/Main").Version_verified = true
				Outdated()

func Outdated():
	$InfoLabelOutdate.text = "Zul space desatualizado!"
	$InfoLabelOutdate.set("custom_colors/font_color", Color(1, 0, 0))
	$InfoLabel.text = get_node("/root/Main").ServerVersion
	$InfoLabel.set("custom_colors/font_color", Color(1, 0, 0))
	OS.shell_open("https://drive.google.com/drive/folders/1kUwjapTRimUuqljYZ3CBLz04-qrYaSPO")
	get_node("/root/Main/Menu").get_child(0).get_child(0).disabled = true
	get_node("/root/Main/Menu").get_child(0).get_child(1).disabled = true

func Updated():
	$InfoLabel.text = get_node("/root/Main").Version
	$InfoLabel.set("custom_colors/font_color", Color(0, 1, 0))
	get_node("/root/Main/Menu").get_child(0).get_child(0).disabled = false
	get_node("/root/Main/Menu").get_child(0).get_child(1).disabled = false
