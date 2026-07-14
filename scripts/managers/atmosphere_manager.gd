extends Node
#drives the tv static overlay from the state of the night
#the picture gets grainier as the wax runs out, and the border closes in when the monkey stalks close

@export var overlay : ColorRect
@export var candle : Node
@export var monkey : Node

#the grain of a calm night, with a full candle and no monkey around
@export var base_static := 0.08
#how much extra grain a dying candle adds
@export var wax_static := 0.12
#and how much the monkey adds when it is breathing down your neck
@export var dread_static := 0.18

#how wide the border sits on a calm night
@export var base_border := 0.45
#and how far it closes in when the monkey is on top of you
@export var dread_border := 0.15

#the monkey is only scary from this close, and forgotten from this far
@export var dread_near := 80.0
@export var dread_far := 400.0
#how lazily the picture reacts, so it creeps instead of snapping
@export var smooth := 3.0

var current_static := 0.08
var current_border := 0.45

#how close the monkey is to catching the rancher, from 0 (gone) to 1 (right there)
func dread_level():
	if monkey == null or not monkey.going_bananas:
		return 0.0
	var dist = monkey.monkey_body.global_position.distance_to(monkey.rancher_body.global_position)
	return clampf(inverse_lerp(dread_far, dread_near, dist), 0.0, 1.0)

#how far the candle has burned down, from 0 (full) to 1 (dark)
func wax_level():
	if candle == null:
		return 0.0
	return clampf(1.0 - candle.wax / candle.maxwax, 0.0, 1.0)

func _process(delta):
	if overlay == null or overlay.material == null:
		return
	var dread = dread_level()
	var target_static = base_static + wax_static * wax_level() + dread_static * dread
	var target_border = base_border - dread_border * dread
	current_static = lerpf(current_static, target_static, smooth * delta)
	current_border = lerpf(current_border, target_border, smooth * delta)
	overlay.material.set_shader_parameter("static_alpha", current_static)
	overlay.material.set_shader_parameter("border_size", current_border)
