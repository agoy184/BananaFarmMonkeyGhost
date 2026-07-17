extends Node
#a small script to detect when the monkey catches the player
@export var rancher_body : CharacterBody2D
@export var rancher_movement : Node
@export var gmanager : Node
@export var audio : AudioStreamPlayer
@export var monkey_movement : Node

#one last jolt for the camera before the game over kicks in
signal caught_signal
@export var lives := 3
func _on_monkey_area_body_entered(body: Node2D):
	if monkey_movement.stunned:
		return
	if body == rancher_body:
		lives -= 1
		if lives == 0:
			badend()
			return
		audio.play()
		rancher_movement.locked = true
		monkey_movement.scream()
		await get_tree().create_timer(1.0).timeout
		monkey_movement.disappear()
		monkey_movement.unscream()
		caught_signal.emit()
		gmanager.game_over()
		monkeywarn()

func badend():
	await monkey_movement.long_scream()
	get_tree().change_scene_to_file("res://scenes/monkeyloss.tscn")

@export var pause : Node
@export var warning : Control
func monkeywarn():
	pause.midstop()
	warning.visible = true

func _on_warn_button_pressed() -> void:
	pause.resume()
	warning.visible = false
