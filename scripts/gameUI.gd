extends CanvasLayer

onready var scoreLabel := $UI/VBoxContainer/HBoxContainer2/grid/Score
onready var highScoreLable := $UI/VBoxContainer/HBoxContainer2/grid2/HighScore

# save data
onready var fileManager := preload("res://scripts/FileManager.gd").new()
var my_data = {"highScore": 0}

func _ready():
	my_data = fileManager.load_data("score_file", my_data, "user")
	highScoreLable.text = str(my_data.highScore)

func _on_ScoreManager_set_score(score):
	scoreLabel.text = str(score)


func _on_grid_game_ended():
	$UI/EndGame_Panel.show()
	checkHighScore()
	pass # Replace with function body.


func _on_grid_game_started():
	$UI/EndGame_Panel.hide()
	pass # Replace with function body.

func checkHighScore():
	var newScore = int(scoreLabel.text)
	var currentHighscore = int(highScoreLable.text)
	
	if newScore > currentHighscore:
		save_highscore(newScore)
		highScoreLable.text = str(newScore)
		pass

func save_highscore(score):
	
	my_data["highScore"] = score
	fileManager.save_data(my_data, "score_file", "user")





func _on_SoundManager_SoundChanged(turnedOn):
	$UI/VBoxContainer/HBoxContainer3/Sound.pressed = !turnedOn
	
	pass # Replace with function body.
