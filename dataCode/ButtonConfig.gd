extends Control

func _ready():
	if(get_node("/root/Main").Version_verified):
		$PlayButton.disabled = false
		$ConfigButton.disabled = false
