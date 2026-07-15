extends Node
#tells the rancher what pressing E would do right now

@export var label : Label
@export var plants : Array[Node]
@export var house_area : Area2D
@export var market_stall : Node2D
@export var harvest : Node

#putting this here so we don't have to manually adjust the plant array twice
@export var bananamanager : Node
func _ready():
	plants = bananamanager.plants.duplicate()

var current = ""

func _process(_delta):
	var hint = ""
	if harvest.is_busy():
		hint = "hold E - cut gently"
	elif house_area.is_close:
		hint = "E - go home"
	elif market_stall.is_close:
		hint = "E - check store"
	else:
		for p in plants:
			if p.is_close():
				hint = "E - harvest"
				break
	#only touch the label when the hint actually changes
	if hint != current:
		current = hint
		label.text = hint
