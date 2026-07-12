extends Node
#just to play the idle animation

@export var sprite : AnimatedSprite2D

func _process(_delta):
	sprite.play("default")
