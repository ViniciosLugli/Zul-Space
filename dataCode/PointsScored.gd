extends Node2D

func _ready():
	pass

func _process(delta):
	self.position.y -= 0.5
	$Label.modulate.a -= 0.01

func _on_Timer_timeout():
	self.call_deferred('free')


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	self.call_deferred('free')
