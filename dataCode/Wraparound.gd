extends Node

export (Rect2) var wrapArea = null

export (bool) var horizontalWrapping = true
export (bool) var verticalWrapping = true

var AXIS = {
	HORIZONTAL = "x",
	VERTICAL = "y"
}

func initWrapArea():
	if wrapArea == null:
		wrapArea = Rect2(Vector2(), Vector2(1920, 1080))
func recalculate_wrap_area():
	wrapArea = Rect2(Vector2(), Vector2(1920, 1080))

func _ready():
	initWrapArea()
	add_to_group("wrap_around")

func _process(_delta):
	if !wrapArea.has_point(get_parent().global_position):
		wrap()

func wrap():
	if horizontalWrapping:
		wrapBy(AXIS.HORIZONTAL)

func getAxisWrapDirection(axis):
	if get_parent().global_position[axis] < wrapArea.position[axis]:
		return 1
	elif get_parent().global_position[axis] > wrapArea.size[axis]:
		return -1
	return 0

func wrapBy(axis):
	var adjust = getAxisWrapDirection(axis) * wrapArea.size[axis]
	get_parent().position[axis] += adjust
