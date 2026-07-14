extends Node
#a small script to detect when the monkey catches the player
@export var rancher_body : CharacterBody2D
@export var rancher_movement : Node
@export var gmanager : Node
@export var audio : AudioStreamPlayer
@export var monkey_movement : Node

#one last jolt for the camera before the game over kicks in
signal caught_signal

func _on_monkey_area_body_entered(body: Node2D):
	if monkey_movement.stunned:
		return
	if body == rancher_body:
		audio.play()
		rancher_movement.locked = true
		await get_tree().create_timer(1.0).timeout
		caught_signal.emit()
		gmanager.game_over()
