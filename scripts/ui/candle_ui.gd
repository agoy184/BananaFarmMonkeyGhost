extends Node
#script to manage the burning candle sprite and sounds

@export var candle : Node
@export var sprite : AnimatedSprite2D
@export var audio : AudioStreamPlayer

#basic helper functions
func play_animation(animation_name):
	if !sprite.is_playing() or sprite.animation != animation_name:
		sprite.play(animation_name)
func play_audio():
	audio.play()

var fuel_status := 100
var new_status := 0
func check_status():
	var wax = candle.wax/candle.maxwax
	if wax > 0.90:
		new_status = 100
	elif wax > 0.75:
		new_status = 75
	elif wax > 0.50:
		new_status = 50
	elif wax > 0.25:
		new_status = 25
	else:
		new_status = 0

func change_status():
	if new_status != fuel_status:
		fuel_status = new_status
		audio.play()

func play_current_animation():
	play_animation(str(fuel_status))


func _on_candle_manager_waxsignal() -> void:
	check_status()
	change_status()
	play_current_animation()
