extends Node
#a small script to detect when the monkey catches the player
@export var rancher_body : CharacterBody2D
@export var gmanager : Node

#one last jolt for the camera before the game over kicks in
signal caught_signal

func _on_monkey_area_body_entered(body: Node2D):
	if body == rancher_body:
		print("Oh no, il rancher è stato preso dalla scimmia!")
		caught_signal.emit()
		gmanager.game_over()
