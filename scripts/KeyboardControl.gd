extends Node2D

signal move(direction)

func _unhandled_key_input(event):
	if ( Input.is_action_just_pressed("ui_up")):
		emit_signal("move", Vector2.UP)
	if ( Input.is_action_just_pressed("ui_down")):
		emit_signal("move", Vector2.DOWN)
	if ( Input.is_action_just_pressed("ui_left")):
		emit_signal("move", Vector2.LEFT)
	if ( Input.is_action_just_pressed("ui_right")):
		emit_signal("move", Vector2.RIGHT)
		
