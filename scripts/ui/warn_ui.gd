extends Node
#simple script to nag the rancher on-screen when the sun is coming

@export var label : Label
@export var manager : Node
#how quickly the label pulses during overtime
@export var flash_time := 0.4

var tw

func update_label():
	label.text = manager.warn_str()
	flashing(manager.overtime)

#makes the label pulse while the rancher is on borrowed time
func flashing(urgent):
	if urgent and tw == null:
		tw = create_tween().set_loops()
		tw.tween_property(label, "modulate:a", 0.3, flash_time)
		tw.tween_property(label, "modulate:a", 1.0, flash_time)
	elif not urgent and tw != null:
		tw.kill()
		tw = null
		label.modulate.a = 1.0

func _ready():
	update_label()
func _on_time_manager_min_signal() -> void:
	update_label()
