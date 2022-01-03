extends CanvasLayer

onready var scoreLabel := $UI/VBoxContainer/HBoxContainer2/grid/Score




func _on_ScoreManager_set_score(score):
	scoreLabel.text = str(score)
