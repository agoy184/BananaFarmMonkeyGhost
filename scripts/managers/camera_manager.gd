extends Node
#drives the camera: follows the rancher, peeks ahead while walking, shakes for scares, zoom-punches for harvests
#the camera lives under GameScene (not under the rancher, whose 0.3 scale would warp the view)

@export var camera : Camera2D
@export var rancher_body : CharacterBody2D

#how far the camera peeks ahead of the rancher while walking
@export var lead_distance := 40.0
#how quickly the peek eases in (bigger = snappier)
@export var lead_smooth := 3.0
#how hard the strongest shake pushes the view, in pixels
@export var max_offset := 14.0
#how fast a shake calms down, per second
@export var decay := 1.2
#how much the harvest punch squeezes the zoom, and for how long
@export var punch_scale := 0.05
@export var punch_time := 0.18

var trauma := 0.0
var lead := Vector2.ZERO
var base_zoom := Vector2.ONE
var punch_tween = null

func _ready():
	base_zoom = camera.zoom
	camera.global_position = rancher_body.global_position
	camera.reset_smoothing()

func _process(delta):
	#the built-in smoothing trails this target, so we can just pin it to the rancher
	camera.global_position = rancher_body.global_position
	#ease the look-ahead toward where the rancher is walking
	lead = lead.lerp(rancher_body.velocity.normalized() * lead_distance, minf(lead_smooth * delta, 1.0))
	#the shake fades on its own, squared so small trauma barely tickles
	trauma = maxf(trauma - decay * delta, 0.0)
	var shake_offset = Vector2.ZERO
	if trauma > 0.0:
		shake_offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * trauma * trauma * max_offset
	camera.offset = lead + shake_offset

#pile scares on top of each other, capped so the view never goes wild
func shake(amount):
	trauma = minf(trauma + amount, 1.0)

#a quick zoom kiss for satisfying moments
func punch(strength := 1.0):
	if punch_tween:
		punch_tween.kill()
	camera.zoom = base_zoom
	punch_tween = camera.create_tween()
	punch_tween.tween_property(camera, "zoom", base_zoom * (1.0 + punch_scale * strength), punch_time * 0.4)
	punch_tween.tween_property(camera, "zoom", base_zoom, punch_time * 0.6)

#the monkey shows itself: a good rattle, doubles as a warning when it spawns off screen
func _on_monkey_movement_appear_signal():
	shake(0.7)

#caught! rattle hard for the last frames before the reload
func _on_monkey_catches_caught_signal():
	shake(1.0)

#bananas in the bag: a soft punch, a bit prouder when the cut was perfect
func _on_harvest_manager_harvested_signal(perfect):
	punch(1.6 if perfect else 1.0)

#the stem snapped: a mid shake to sell the mistake
func _on_harvest_manager_snap_signal():
	shake(0.35)
