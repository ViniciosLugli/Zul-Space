extends RigidBody2D

var direction = Vector2(0, 1)
var projectile_speed = 1200
var color_type = 2
var is_exploded = false
var internal_lifes = 1

#Textures
export(Texture) var Blue_laser
export(Texture) var Red_laser
export(Texture) var Green_laser
#

func _ready():
	if(color_type == 0):
		$Sprite.texture = Blue_laser
		$Particles2D.process_material.color = Color("1eb1be")
		internal_lifes = 1
	elif(color_type == 1):
		$Sprite.texture = Red_laser
		$Particles2D.process_material.color = Color("913333")
		internal_lifes = 2
	elif(color_type == 2):
		$Sprite.texture = Green_laser
		$Particles2D.process_material.color = Color("5B9C2F")
		internal_lifes = 2

func _process(_delta):
	self.position += direction * projectile_speed * _delta

func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
	if((self.position.y > 1) and not(is_exploded)):
		is_exploded = true
		self.call_deferred('free')

func explode():
	if(is_exploded):
		return
	is_exploded = true
	self.call_deferred('free')
