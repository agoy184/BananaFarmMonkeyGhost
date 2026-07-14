extends Node
#lets the rancher call it a night at the house

@export var area : Area2D
@export var gmanager : Node
#so going home can't happen mid-cut
@export var harvest : Node

func _input(event):
	if event.is_action_pressed("Interact") and area.is_close and not harvest.is_busy():
		gmanager.end_night()
