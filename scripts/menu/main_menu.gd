extends Node2D
#the main menu, handles the buttons and the two small panels

@export var options_panel : PanelContainer
@export var credits_panel : PanelContainer

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")

func _on_options_button_pressed():
	credits_panel.hide()
	options_panel.visible = !options_panel.visible

func _on_credits_button_pressed():
	options_panel.hide()
	credits_panel.visible = !credits_panel.visible

func _on_quit_button_pressed():
	get_tree().quit()

#the slider goes from 0 to 1
func _on_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_fullscreen_check_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

#both panels share the same back button behaviour
func _on_back_button_pressed():
	options_panel.hide()
	credits_panel.hide()
