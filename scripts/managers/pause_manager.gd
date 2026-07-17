extends Node
@export var speedmanager : Node
@export var optionpanel : Control
var pauseflag := false


func fullstop():
	speedmanager.speedfactor = 0.0
	optionpanel.visible = true
	get_tree().paused = true
	pauseflag = true

func resume():
	speedmanager.speedfactor = 1.0
	optionpanel.visible = false
	get_tree().paused = false
	pauseflag = false

func _input(event):
	if event.is_action_pressed("Pause"):
		if !pauseflag:
			fullstop()
		else:
			resume()

func _on_volume_slider_value_changed(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))


func _on_fullscreen_check_toggled(toggled_on: bool):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_options_back_pressed():
	resume()
