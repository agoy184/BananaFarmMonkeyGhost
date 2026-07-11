extends Node
#simple script to keep the wax bar in sync with the candle

@export var bar : Range
@export var manager : Node

func update_bar():
	#max first, so the bigger candle upgrade rescales the bar correctly
	bar.max_value = manager.maxwax
	bar.value = manager.wax

func _ready():
	update_bar()
func _on_candle_manager_waxsignal() -> void:
	update_bar()
