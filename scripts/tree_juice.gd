extends Node2D
#little lights and wiggles so the trees feel alive

@export var glow : PointLight2D
@export var sprite : AnimatedSprite2D
@export var burst : GPUParticles2D
#how bright the welcome glow gets when the rancher is close
@export var glow_energy := 0.6
#how far the tree leans while the rancher strains at it
@export var wiggle_amount := 0.07
@export var wiggle_speed := 30.0

var glow_tween
var strain_amount := 0.0

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

#the sawing wobble, scaled by how hard the rancher is pulling
func _process(_delta):
	if strain_amount > 0.0:
		sprite.rotation = sin(Time.get_ticks_msec() * 0.001 * wiggle_speed) * wiggle_amount * strain_amount
	elif sprite.rotation != 0.0:
		sprite.rotation = 0.0

#a quick squash and stretch on the tree sprite
func pop(squash, dur):
	var t = create_tween()
	t.tween_property(sprite, "scale", squash, dur * 0.4).set_trans(Tween.TRANS_BACK)
	t.tween_property(sprite, "scale", Vector2.ONE, dur * 0.6).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
