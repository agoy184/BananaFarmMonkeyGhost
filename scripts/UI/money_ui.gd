extends Node
#simple script to track the rancher's money on-screen

@export var label : Label
@export var manager : Node

func update_label():
	label.text = manager.money_str()

func _ready():
	update_label()
func _on_shop_manager_moneysignal() -> void:
	update_label()
