extends Node
#tells the rancher what pressing E would do right now

@export var label : Label
@export var plants : Array[Node]
@export var house_area : Area2D
@export var harvest : Node

var current = ""

func _process(_delta):
	var hint = ""
	if harvest.is_busy():
		hint = "hold E - cut gently"
	elif house_area.is_close:
		hint = "E - go home"
	else:
		for p in plants:
			if p.is_close():
				hint = "E - harvest"
				break
	#only touch the label when the hint actually changes
	if hint != current:
		current = hint
		label.text = hint
