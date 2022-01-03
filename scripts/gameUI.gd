extends CanvasLayer

onready var scoreLabel := $UI/VBoxContainer/HBoxContainer2/grid/Score


func _on_ScoreManager_set_score(score):
	scoreLabel.text = str(score)


func _on_grid_game_ended():
	$UI/EndGame_Panel.show()
	pass # Replace with function body.


func _on_grid_game_started():
	$UI/EndGame_Panel.hide()
	pass # Replace with function body.
