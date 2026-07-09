extends Node
#a small script to detect when the monkey catches the player
@export var rancher_body : CharacterBody2D
@export var gmanager : Node

func _on_monkey_area_body_entered(body: Node2D):
	if body == rancher_body:
		print("Oh no, il rancher è stato preso dalla scimmia!")
		gmanager.game_over()
