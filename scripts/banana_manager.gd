extends Node
#manages the different plants and makes them talk to the time_manager

@export var plants : Array[Node]
@export var time : Node


func _on_time_manager_min_signal():
	for i in plants:
		i.lifecycle()
