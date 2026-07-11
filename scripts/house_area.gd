extends Area2D
#this is a tiny script keeping track of the rancher's proximity to the house

@export var is_close := false
@export var house : Node

func _on_body_entered(body):
	if body == house.player:
		is_close = true

func _on_body_exited(body):
	if body == house.player:
		is_close = false
