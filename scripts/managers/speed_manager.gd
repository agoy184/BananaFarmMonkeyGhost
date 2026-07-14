extends Node
#move forward time and allows to control the speed of the game

signal speedsignal

#simple speed multiplier
@export var speedfactor := 1.0
#how many real time seconds and in-game minute lasts
@export var minutelength := 2.0
var timer := 0.0

func _process(delta):
	#this node always processes, so the clock stops itself when the game is paused
	if get_tree().paused:
		return
	timer += delta * speedfactor
	if timer >= minutelength:
		timer = 0.0
		speedsignal.emit()
