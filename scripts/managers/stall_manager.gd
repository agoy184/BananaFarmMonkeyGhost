extends Node
#actually manages the physical stall

@export var store : Node
@export var upgrade : Node
@export var stall : Node2D

func _input(event):
	if event.is_action_pressed("Interact") and stall.is_close:
		store.open_shop()
