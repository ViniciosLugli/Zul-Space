extends RigidBody2D
var is_exploded = false
var used = false

func _ready():
	pass

func explode():
	if(is_exploded):
		return
	is_exploded = true
	self.call_deferred('free')

func gotted():
	if(used):
		return
	self.set_collision_layer(0)
	used = true
	$Sprite.visible = false
	$AudioEffect.play_random_song()

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	if(not used):
		explode()

func _on_AudioEffect_finished():
	explode()

func _physics_process(delta):
	self.rotation_degrees = 0
