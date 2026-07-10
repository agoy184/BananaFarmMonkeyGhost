extends Node
#script for managing the candle

signal waxsignal
#simple signal to communicate with UI

@export var gmanager : Node
@export var candle : PointLight2D
#defines the maximum scale of the light
@export var max_scale := 15.0
#defines the baseline scale value, unaffected by flickering
@export var real_scale := 15.0
#defines the base energy of the candle
@export var base_energy := 1.2
@export var flicker_speed := 8.0
@export var flicker_amount := 0.15

@export var maxwax = 100.0
@export var wax := 100.0
#to easily determine how quickly the light dies
@export var burnrate := 1.0

func set_brightness():
	real_scale = max_scale * wax / maxwax
func burning():
	wax -= burnrate
	waxsignal.emit()
	if wax <= 0:
		thedark()

var target = 1.0
var current = 1.0
func flickering(d):
	if randf() < flicker_speed * d:
		target = 1.0 + randf_range(-flicker_amount, flicker_amount)
	current = lerpf(current, target, 10.0 * d)
	candle.energy = base_energy * current
	candle.texture_scale = real_scale * current


func thedark():
	print ("Oh no, darkness swallowed the rancher!")
	gmanager.game_over()

func refill():
	wax = maxwax
	waxsignal.emit()

func _on_time_manager_min_signal():
	burning()
	set_brightness()
func _process(delta):
	flickering(delta)

func _input(event):
	if event.is_action_pressed("Debug"):
		refill()

func wax_str():
	var wint = roundi(wax)
	var wstr = "Wax : " + str(wint)
	return wstr
