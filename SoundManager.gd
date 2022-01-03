extends Node2D

signal SoundChanged(turnedOn)

var mergeSound = preload("res://assets/sounds/drop_004.ogg") 
var Sound_On := true
onready var player := $soundPlayer

# save data
onready var fileManager := preload("res://scripts/FileManager.gd").new()
var my_data = {"sound": true}

func _ready():
	my_data = fileManager.load_data("sound_data", my_data, "user")
	Sound_On = my_data.sound
	$bgMusic.stream_paused = !my_data.sound
	emit_signal("SoundChanged", my_data.sound)

func playSound():
	if player.playing == false and Sound_On:
		player.stream = mergeSound
		player.play()


func _on_grid_change_score(score):
	playSound()
	pass # Replace with function body.


func _on_soundPlayer_finished():
	player.stop()
	pass # Replace with function body.


func _on_Sound_toggled(button_pressed):
	Sound_On = button_pressed == false
	$bgMusic.stream_paused = button_pressed
	
	my_data["sound"] = Sound_On
	fileManager.save_data(my_data, "sound_data", "user")
	
	pass # Replace with function body.
