extends Node

@export var rancher_body : CharacterBody2D
@export var monkey_body : CharacterBody2D
#the monkkey speed should be lower than the rancher's by default
@export var monkey_speed := 70.0
#but it should be able to increase, in order to become a true threat
#maybe based on the bananas carried, the day, or the plantation status
@export var rage_speed := 0.0
#the rage of the monkey is compared to the candle's protective wax to determine if the monkey will pursue
@export var rage := 0.0
#as the night goes on, the spirit becomes more irritable
@export var timerage := 0.0
#as you harvet more and more bananas, the spirit grows angrier
@export var bananarage := 0.0
@export var rage_per_banana := 10.0

@export var inventory : Node
@export var candle : Node
@export var sprite : AnimatedSprite2D

#lets the camera (or anyone else) flinch when the monkey shows up
signal appear_signal

func _physics_process(_delta):
	if stunned:
		return
	if going_bananas:
		enrage()
		pursuit()
	else:
		haunting()

@export var farmer_breath : AudioStreamPlayer
#audio of the farmer breathing when pursued
@export var move_audio : AudioStreamPlayer

#the pursuit function should be called when the monkey decides to pursue the rancher
func pursuit():
	var speed = rage_speed
	var dir = rancher_body.global_position - monkey_body.global_position
	dir = dir.normalized()
	move_audio.spooky()
	farmer_breath.breathe()
	monkey_body.velocity = dir * speed
	monkey_body.move_and_slide()

#in the end, the poor little haunting function does nothing. We could remove it, if we have no ideas for the monkey's idle time.
func haunting():
	pass

#the going bananas function should determine whether the monkey will go for bananas or for the rancher
#as the funcion is NOT to be called in _process, its output is actually stored in a variable
@export var going_bananas := false
func is_going_bananas():
	if is_safe():
		going_bananas = false
		return
	if stunned:
		going_bananas = false
		return
	timerage += 1.0
	bananarage = inventory.bananas * rage_per_banana
	rage = timerage + bananarage
	if rage < candle.wax:
		disappear()
		going_bananas = false
	else:
		if going_bananas == true:
			return
		else:
			appear()
			going_bananas = true

@export var irritated_audio : AudioStreamPlayer

#chenage how it works, now monkey is twice at fast at speed 100
func enrage():
	if rage >= 50.0:
		irritated_audio.grr()
		sprite.bouncy()
	else:
		sprite.spooky()
	rage_speed = monkey_speed * (1.00 + rage/100.0)

@export var appear_audio : AudioStreamPlayer
@export var violin : AudioStreamPlayer
#the monkey appears when it is angry enough
func appear():
	appear_audio.play()
	violin.play()
	monkey_body.visible = true
	monkey_body.process_mode = Node.PROCESS_MODE_INHERIT
	new_position()
	appear_signal.emit()

#the monkey disappears when the candle's power grows
func disappear():
	monkey_body.visible = false
	monkey_body.process_mode = Node.PROCESS_MODE_DISABLED

@export var mindis := 300
@export var maxdis := 400
#the monkey must appear close to the rancher
func new_position():
	#get a random angle in RAD
	var angle = randf()*TAU
	var distance = randf_range(mindis, maxdis)
	var offset = Vector2(cos(angle), sin(angle)) * distance
	monkey_body.global_position = rancher_body.global_position + offset

func _on_time_manager_min_signal():
	is_going_bananas()
func _on_time_manager_daysignal():
	timerage = 0.0
	rage = 0.0

#Additional functions to banish the monkey with light and to prevent it from respawning immediately.
@export var mad_audio : AudioStreamPlayer
func banish():
	mad_audio.play()
	stun()
	await sprite.screaming()
	disappear()

var stuntime := 5.0
var stunned := false
func stun():
	stunned = true
	await get_tree().create_timer(stuntime).timeout
	stunned = false
	appear()

@export var monkey_scream : AnimatedSprite2D
func scream():
	monkey_scream.visible = true

func long_scream():
	monkey_scream.visible = true
	monkey_scream.play("eat")
	var tween = create_tween()
	tween.tween_property(monkey_scream, "scale", Vector2(20.0,20.0), 2.1)
	await tween.finished

func unscream():
	monkey_scream.visible = false

@export var safezone : Area2D
func is_safe():
	if safezone.overlaps_body(rancher_body) or safezone.overlaps_body(monkey_body):
		disappear()
		return true
	else:
		return false


func _ready():
	is_going_bananas()
