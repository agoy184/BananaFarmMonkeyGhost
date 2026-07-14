extends Node
#pretty simple, this one is for moving the rancher

@export var rancher_body : CharacterBody2D
@export var rancher_sprite : AnimatedSprite2D
#export movement speed for easier balancing later
@export var rancher_speed := 100.0
#the harvest manager flips this while the rancher is busy sawing at a stem
@export var locked := false

func _physics_process(_delta):
	#we grab an empty 2d vector and fill it with the input
	var dir = Vector2.ZERO
	dir.x = Input.get_axis("ui_left","ui_right")
	dir.y = Input.get_axis("ui_up","ui_down")
	dir = dir.normalized()
	if locked:
		dir = Vector2.ZERO

	rancher_body.velocity = dir * rancher_speed
	rancher_body.move_and_slide()
	rancher_animation()

#a simple function: if velocity is zero, play idle, otherwise, play walk.
func rancher_animation():
	if rancher_body.velocity == Vector2.ZERO :
		rancher_sprite.play("idle")
	else :
		rancher_sprite.play("walk")
