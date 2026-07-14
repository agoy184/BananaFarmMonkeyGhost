extends Node2D
#little lights and wiggles so the trees feel alive

@export var glow : PointLight2D
@export var sprite : AnimatedSprite2D
@export var burst : GPUParticles2D
#the tree brain, so the idle sway can tell a lush tree from a dying one
@export var plant : Node
#how bright the welcome glow gets when the rancher is close
@export var glow_energy := 0.6
#how far the tree leans while the rancher strains at it
@export var wiggle_amount := 0.07
@export var wiggle_speed := 30.0
#the lazy breeze the tree leans into when nobody is bothering it
@export var sway_amount := 0.02
@export var sway_speed := 1.1
#and the slow breathing that goes with it
@export var breathe_amount := 0.02
@export var breathe_speed := 0.85
#how much life is left in the sway, per status: Withered, Ailing, Healthy, Flourishing
@export var sway_by_status := [0.15, 0.45, 0.8, 1.0]

var glow_tween
var pop_tween
var strain_amount := 0.0
#every tree gets its own place in the breeze, so the grove doesn't sway in lockstep
var phase := 0.0

func _ready():
	phase = randf() * TAU

#fades the tree's little light in and out as the rancher comes and goes
func _on_banana_area_proximity_signal(close):
	if glow_tween:
		glow_tween.kill()
	glow_tween = create_tween()
	var target = 0.0
	if close:
		target = glow_energy
	glow_tween.tween_property(glow, "energy", target, 0.25)

func _on_banana_tree_harvest_signal(_n):
	burst.modulate = Color(1, 1, 1)
	burst.restart()
	pop(Vector2(1.25, 0.75), 0.28)

func _on_banana_tree_watered_signal():
	pop(Vector2(0.94, 1.06), 0.18)

#the harvest manager reports how hard the rancher is sawing
func _on_banana_tree_strain_signal(x):
	strain_amount = x

#a botched cut: a big angry shiver and a green burst instead of the golden one
func _on_banana_tree_snap_signal():
	strain_amount = 0.0
	sprite.rotation = 0.0
	burst.modulate = Color(0.5, 1, 0.4)
	burst.restart()
	pop(Vector2(1.35, 0.7), 0.35)

#a withered tree hardly stirs, a flourishing one is full of breeze
func sway_strength():
	if plant == null:
		return 1.0
	return sway_by_status[plant.mystatus()]

#the sawing wobble when the rancher is pulling, the lazy breeze when he isn't
func _process(_delta):
	var t = Time.get_ticks_msec() * 0.001
	var life = sway_strength()
	if strain_amount > 0.0:
		sprite.rotation = sin(t * wiggle_speed) * wiggle_amount * strain_amount
	else:
		sprite.rotation = sin(t * sway_speed + phase) * sway_amount * life
	#the pop owns the scale while it runs, so the breathing waits its turn
	if pop_tween == null or not pop_tween.is_running():
		var o = sin(t * breathe_speed + phase * 1.3) * breathe_amount * life
		sprite.scale = Vector2(1.0 - o, 1.0 + o)

#a quick squash and stretch on the tree sprite
func pop(squash, dur):
	pop_tween = create_tween()
	pop_tween.tween_property(sprite, "scale", squash, dur * 0.4).set_trans(Tween.TRANS_BACK)
	pop_tween.tween_property(sprite, "scale", Vector2.ONE, dur * 0.6).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
