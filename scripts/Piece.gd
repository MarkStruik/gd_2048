extends Node2D

export var Value : int
export var MainColor: Color
export var ShadeColor: Color
export var BorderColor: Color

onready var tween := $MoveTween

func _ready():
	update_data()
		
func update_data():
	if Value == 0:
		$value.text = ""
	else:
		$value.text = String(Value)
	
	$Piece.modulate = MainColor
	
func move(dest: Vector2):
	tween.interpolate_property(self,"position", position, dest, 0.3,Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	position = dest
	#maybe we can add an anitmation/tween later

func remove():
	$ScaleTween.interpolate_property(self, "scale", scale, Vector2(1.5,1.5), .2, Tween.TRANS_SINE, Tween.EASE_OUT)
	$ModulateTween.interpolate_property(self,"modulate", modulate, Color(0,0,0,0), .2, Tween.TRANS_SINE, Tween.EASE_OUT)
	$ScaleTween.start()
	$ModulateTween.start()

func hideNewStatus():
	$new.hide()


func _on_ModulateTween_tween_completed(object, key):
	if ( scale == Vector2(1.5,1.5)):
		queue_free()
	pass # Replace with function body.
