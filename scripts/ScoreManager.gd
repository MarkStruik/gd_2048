extends Node2D

var current_score :=0

signal set_score

func _ready():
	current_score = 0
	emit_signal("set_score", current_score)

func increase_score(amount):
	current_score += amount
	emit_signal("set_score", current_score)



func _on_grid_change_score(value):
	increase_score(value)
	pass # Replace with function body.


func _on_grid_game_started():
	current_score = 0
	emit_signal("set_score", current_score)
	pass # Replace with function body.
