extends Node
#manages the different plants and makes them talk to the time_manager
#also manages the watering of plants and kicks off the harvest minigame

@export var plants : Array[Node]
@export var time : Node
#putting the inventory in here to manage the harvesting
@export var inventory : Node
#the stem-cutting minigame
@export var harvest : Node

func _on_time_manager_min_signal():
	pass

#randomize plant condition at game start
func _ready():
	for i in plants:
		i.random_bananas()

#watering still happens with a single press, but fruiting trees now demand a careful cut
func _input(event):
	if event.is_action_pressed("Interact"):
		if harvest.is_busy():
			return
		var target = null
		var best = INF
		for i in plants:
			if i.is_close():
				i.watering()
				if i.bananas > 0:
					var d = i.global_position.distance_squared_to(i.player.global_position)
					if d < best:
						best = d
						target = i
		if target:
			harvest.start_cutting(target)

func _on_time_manager_daysignal():
	for i in plants:
		i.lifecycle()
