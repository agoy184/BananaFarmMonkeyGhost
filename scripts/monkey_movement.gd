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

#lets the camera (or anyone else) flinch when the monkey shows up
signal appear_signal

func _physics_process(_delta):
	if going_bananas:
		enrage()
		pursuit()
	else:
		haunting()

#the pursuit function should be called when the monkey decides to pursue the rancher
func pursuit():
	var speed = rage_speed
	var dir = rancher_body.global_position - monkey_body.global_position
	dir = dir.normalized()
	monkey_body.velocity = dir * speed
	monkey_body.move_and_slide()

#in the end, the poor little haunting function does nothing. We could remove it, if we have no ideas for the monkey's idle time.
func haunting():
	pass

#the going bananas function should determine whether the monkey will go for bananas or for the rancher
#as bananas are not currently implemented, it always return false, thus the monkey always pursues
#as the funcion is NOT to be called in _process, its output is actually stored in a variable
@export var going_bananas := false
func is_going_bananas():
	timerage += 0.1
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

#chenage how it works, now monkey is twice at fast at speed 100
func enrage():
	rage_speed = monkey_speed * (1.00 + rage/100.0)

#the monkey appears when it is angry enough
func appear():
	monkey_body.visible = true
	monkey_body.process_mode = Node.PROCESS_MODE_INHERIT
	new_position()
	appear_signal.emit()

#the monkey disappears when the candle's power grows
func disappear():
	monkey_body.visible = false
	monkey_body.process_mode = Node.PROCESS_MODE_DISABLED

@export var mindis := 200
@export var maxdis := 250
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
	rage = 0.0

func _ready():
	is_going_bananas()
