extends Node
#simple script to track the time on-screen

@export var label : Label
@export var manager : Node

func update_label():
	label.text = manager.time_to_str()

func _ready():
	update_label()
func _on_time_manager_min_signal() -> void:
	update_label()
