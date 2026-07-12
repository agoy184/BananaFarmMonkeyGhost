extends Node2D
#script to manage the flare that we use to scare the monkey away
#must be node2d to get the mouse position

#we need the candle manager to spend wax when we flare
@export var candle : Node

#and we also need the lights that we will manage
@export var circle : PointLight2D
@export var triangle : PointLight2D

func _ready():
	triangle.enabled = false

#we need the rancher to lock movement during the animation
@export var rancher : Node
@export var waxcost := 10.0
var target : Vector2
func _input(event):
	if event.is_action_pressed("Flare"):
		#checks that you actually have the wax
		if candle.wax <= waxcost:
			return
		#remove the wax and immediately update the UI
		candle.wax -= waxcost
		candle.waxsignal.emit()
		rancher.locked = true
		await candle.shrink()
		await emit_flare()
		rancher.locked = false
		candle.unshrink()

func emit_flare():
	target = get_global_mouse_position()
	triangle.enabled = true
	triangle.look_at(target)
	#I should have put the triangle in horizontal, so I have to rotate it manually
	triangle.rotation += deg_to_rad(90)
	await get_tree().create_timer(0.5).timeout
	triangle.enabled = false

@export var area : Area2D
@export var monkey : Node
@export var monkey_area : Area2D

func _on_flarea_area_entered(area: Area2D):
	if area == monkey_area:
		monkey.banish()
