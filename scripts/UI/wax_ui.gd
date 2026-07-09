extends Node
#simple script to print the remaining wax on screen

@export var label : Label
@export var manager : Node

func update_label():
	label.text = manager.wax_str()

func _ready():
	update_label()

func _on_candle_manager_waxsignal():
	update_label()
