extends Node
#manages the different plants and makes them talk to the time_manager
#also manages the harvesting and watering of plants

@export var plants : Array[Node]
@export var time : Node
#putting the inventory in here to manage the harvesting
@export var inventory : Node

func _on_time_manager_min_signal():
	pass

#harvesting function to be called to actually harvest the bananas
func gardening(i):
	if i.is_close():
		i.watering()
		var harvest = i.harvest_bananas()
		if harvest != 0:
			inventory.add_bananas(harvest)

#randomize plant condition at game start
func _ready():
	for i in plants:
		i.random_bananas()

func _input(event):
	if event.is_action_pressed("Interact"):
		for i in plants:
			gardening(i)


func _on_time_manager_daysignal():
	for i in plants:
		i.lifecycle()
