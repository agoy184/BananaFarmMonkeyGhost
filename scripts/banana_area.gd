extends Area2D
#this is a tiny script keeping track of the rancher's proximity

@export var is_close := false
@export var b_tree : Node

#tells the tree's juice manager to greet the rancher
signal proximity_signal(close)

func _on_body_entered(body):
	if body == b_tree.player:
		is_close = true
		proximity_signal.emit(true)

func _on_body_exited(body):
	if body == b_tree.player:
		is_close = false
		proximity_signal.emit(false)
