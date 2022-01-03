extends Node2D

export var Value : int
export var MainColor: Color
export var ShadeColor: Color
export var BorderColor: Color

onready var tween := $MoveTween

func _ready():
	if Value == 0:
		$Piece/value.text = ""
	else:
		$Piece/value.text = String(Value)
	
	var new_style = StyleBoxFlat.new()
	new_style.set_bg_color(MainColor)
	new_style.border_color = BorderColor
	new_style.border_width_bottom = 20
	new_style.set_corner_radius_all(30)
	
	$Piece/inner.set('custom_styles/panel', new_style)
	
	var new_style2 = StyleBoxFlat.new()
	new_style2.set_bg_color(ShadeColor)
	new_style2.border_color = ShadeColor
	new_style2.border_width_bottom = 3
	new_style2.set_corner_radius_all(30)
	
	$Piece.set('custom_styles/panel', new_style2)
	
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
	$Piece/new.hide()


func _on_ModulateTween_tween_completed(object, key):
	if ( scale == Vector2(1.5,1.5)):
		queue_free()
	pass # Replace with function body.
