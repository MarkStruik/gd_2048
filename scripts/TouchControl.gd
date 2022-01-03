extends Node2D

signal move(direction)

var first_touch_position := Vector2.ZERO
var touch_release_position := Vector2.ZERO
var swiping := false

export var swipe_limit : float
export var touch_y_limit : int

func _process(delta):
	if Input.is_action_just_pressed("touch"):
		if ( get_global_mouse_position().y > touch_y_limit):
			first_touch_position = get_global_mouse_position()
			swiping = true
	if Input.is_action_just_released("touch") and swiping :
		touch_release_position = get_global_mouse_position()
		calculate_direction()
		swiping = false
		
func calculate_direction():
	var swipe_vector = touch_release_position - first_touch_position
	if swipe_vector.length() > swipe_limit:
		var temp = rad2deg(swipe_vector.angle()) + 180 # right = 0
		first_touch_position = Vector2.ZERO
		touch_release_position = Vector2.ZERO
	
		if temp > 45 and temp <= 135:
			emit_signal("move", Vector2.UP)
		elif temp > 135 and temp <= 225:
			emit_signal("move", Vector2.RIGHT)
		elif temp > 225 and temp <= 300:
			emit_signal("move", Vector2.DOWN)
		else:
			emit_signal("move", Vector2.LEFT)
	
	
