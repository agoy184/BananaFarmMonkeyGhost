extends Node
#every now and then the monkey ghost shows up at the edge of the light

@export var ghost : Sprite2D

#how long between two apparitions, picked at random
@export var min_wait := 4.0
@export var max_wait := 10.0
#how long the ghost takes to fade in and out, and how long it stays
@export var fade_time := 1.5
@export var stay_time := 2.0
#how transparent the ghost is at most
@export var ghost_alpha := 0.7
#how far from its starting spot the ghost is allowed to appear
@export var wander := 150.0

var timer := 0.0
var wait := 5.0
var home := Vector2.ZERO

func _ready():
	home = ghost.position
	ghost.modulate.a = 0.0
	wait = randf_range(min_wait, max_wait)

func _process(delta):
	timer += delta
	if timer >= wait:
		timer = 0.0
		#the next wait also covers the time the ghost spends on screen
		wait = randf_range(min_wait, max_wait) + fade_time * 2 + stay_time
		apparition()

func apparition():
	#move somewhere near home, then fade in, stay a bit, fade back out
	ghost.position = home + Vector2(randf_range(-wander, wander), randf_range(-wander, wander))
	var tween = create_tween()
	tween.tween_property(ghost, "modulate:a", ghost_alpha, fade_time)
	tween.tween_interval(stay_time)
	tween.tween_property(ghost, "modulate:a", 0.0, fade_time)
