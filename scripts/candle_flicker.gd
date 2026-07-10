extends Node
#makes the menu candle flicker like a real flame

@export var candle : PointLight2D

#the resting brightness and size of the flame
@export var base_energy := 1.2
@export var base_scale := 10.0
#how far the flicker can wander from the base values
@export var flicker_amount := 0.15
#how often the flame picks a new flicker target, per second
@export var flicker_speed := 8.0

var target := 1.0
var current := 1.0

func _process(delta):
	#sometimes we pick a new target, and every frame we drift toward it
	if randf() < flicker_speed * delta:
		target = 1.0 + randf_range(-flicker_amount, flicker_amount)
	current = lerpf(current, target, 10.0 * delta)
	candle.energy = base_energy * current
	candle.texture_scale = base_scale * current
