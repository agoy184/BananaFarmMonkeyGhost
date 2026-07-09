extends Node
#script for managing the candle

signal waxsignal
#simple signal to communicate with UI

@export var gmanager : Node
@export var candle : PointLight2D
#defines the maximum scale of the light
@export var max_scale := 15.0
@export var wax := 100.0

#to easily determine how quickly the light dies
@export var burnrate := 1.0

func set_brightness():
	candle.texture_scale = max_scale * wax / 100.0
func burning():
	wax -= burnrate
	waxsignal.emit()
	if wax <= 0:
		thedark()

func thedark():
	print ("Oh no, darkness swallowed the rancher!")
	gmanager.game_over()

func refill():
	wax = 100.0
	waxsignal.emit()

func _on_time_manager_min_signal():
	burning()
	set_brightness()

func _input(event):
	if event.is_action_pressed("Debug"):
		refill()

func wax_str():
	var wint = roundi(wax)
	var wstr = "Wax : " + str(wint)
	return wstr
