extends Node
#pretty simple, this one is for moving the rancher

@export var rancher_body : CharacterBody2D
#export movement speed for easier balancing later
@export var rancher_speed := 100.0

func _physics_process(delta: float):
	#we grab an empty 2d vector and fill it with the input
	var dir = Vector2.ZERO
	dir.x = Input.get_axis("ui_left","ui_right")
	dir.y = Input.get_axis("ui_up","ui_down")
	dir = dir.normalized()
	
	rancher_body.velocity = dir * rancher_speed
	rancher_body.move_and_slide()
