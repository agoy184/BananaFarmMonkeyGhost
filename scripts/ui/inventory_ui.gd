extends Node
#simple script to update the inventory on screen

@export var label : Label
@export var manager : Node

func update_label():
	label.text = manager.str_inventory()


func _ready():
	update_label()
func _on_inventory_manager_invsignal() -> void:
	update_label()
