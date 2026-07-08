extends Node

@export var rancher_body : CharacterBody2D
@export var monkey_body : CharacterBody2D
#the monkkey speed should be lower than the rancher's by default
@export var monkey_speed := 70.0
#but it should be able to increase, in order to become a true threat
#maybe based on the bananas carried, the day, or the plantation status
@export var rage_speed := 0.0

func _physics_process(delta: float):
	enrage()
	if going_bananas():
		haunting()
	else:
		pursuit()
	rage_speed = 0.0
	#we reset the rage_speed at the end

#the pursuit function should be called when the monkey decides to pursue the rancher
func pursuit():
	var speed = monkey_speed + rage_speed
	var dir = rancher_body.global_position - monkey_body.global_position
	dir = dir.normalized()
	monkey_body.velocity = dir * speed
	monkey_body.move_and_slide()

#this function to be done should determine the monkey's behaviour when haunting the plantation
#for now, it just passes though
func haunting():
	pass

#the going bananas function should determine whether the monkey will go for bananas or for the rancher
#as bananas are not currently implemented, it always return false, thus the monkey always pursues
func going_bananas():
	return false

#last but not least, the enrage function should determine how much bonus speed the monkey has, if any
#but this is to be discussed at a later time
func enrage():
	pass
