extends Node2D
#notices when the player is close and greets him

@export var rancher : CharacterBody2D
@export var area : Area2D
@export var sprite : AnimatedSprite2D
var is_close := false

func greet():
	sprite.play("default")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == rancher:
		is_close = true
		greet()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == rancher:
		is_close = false
