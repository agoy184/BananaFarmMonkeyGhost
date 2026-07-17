extends Node2D
@export var flare : CharacterBody2D
@export var rancher : CharacterBody2D
@export var sprite : AnimatedSprite2D
@export var light : PointLight2D
@export var audio : AudioStreamPlayer

#extra exports needed for the initial check
@export var wax_manager : Node
@export var rancher_manager : Node

func _ready():
	deactivate()

func _input(event):
	if event.is_action_pressed("Flare"):
		toss()

var waxcost := 5.0
func initial_check():
	if rancher_manager.locked == true:
		return false
	if wax_manager.wax < waxcost:
		return false
	wax_manager.wax -= waxcost
	wax_manager.waxsignal.emit()
	return true

var flareon := false
var flying := false
var target := Vector2.ZERO
func toss():
	if !initial_check():
		return
	if flareon:
		return
	audio.play()
	target = get_global_mouse_position()
	flare.global_position = rancher.global_position
	activate()
	rotation()
	flying = true

#basic function for movement, it is called by process and stopped by explode()
@export var flarespeed := 200.0
func fly():
	var dir = (target - flare.global_position).normalized()
	flare.velocity = dir * flarespeed
	flare.move_and_slide()
	if flare.get_slide_collision_count() >= 1:
		explode()
	if flare.global_position.distance_to(target) <= 2.0:
		explode()

func explode():
	flying = false
	explosion()
	lights_on()

#expand the light on explosion, with variable scale and duration
var light_sc := 2.0
var light_tm := 1.0
var light_dr := 3.0
func lights_on():
	var tween = create_tween()
	tween.tween_property(light, "scale", Vector2(light_sc, light_sc), light_tm)
	await get_tree().create_timer(light_dr).timeout
	lights_off()

func lights_off():
	var tween = create_tween()
	tween.tween_property(light, "scale", Vector2(1.0, 1.0), light_tm)
	await tween.finished
	deactivate()

func _physics_process(_delta):
	if flying:
		fly()

#simple functions to activate/deactivate the flare
func activate():
	flare.visible = true
	flare.process_mode = Node.PROCESS_MODE_INHERIT
	flareon = true
func deactivate():
	flare.visible = false
	flare.process_mode = Node.PROCESS_MODE_DISABLED
	flareon = false

#simple functions to call animations
func rotation():
	sprite.play("rotation")
func explosion():
	sprite.play("explosion")

@export var monkey_area : Area2D
@export var monkey_manager : Node
func _on_area_2d_area_entered(area: Area2D):
	if area == monkey_area:
		monkey_manager.banish()
