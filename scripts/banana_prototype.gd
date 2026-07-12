extends Node
#just a prototype, simulating how a single banana tree should behave

#the basic idea is that the farmer must tend the trees at night
#or they will wither and he will not be able to harvest on the following nights
enum status {Withered, Ailing, Healthy, Flourishing}
@export var tree_status : status
@export var water := false


#I believe what's below was slightly overengineered. Let's focus on the core gameplay
#we keep track of how much water and care the plant has recently received
#@export var water := 100.0
#and we keep track of the plant's long term health
#@export var health := 40.0
#helath slowly drifts to the water level
#@export var health_step := 0.05
#func health_drift():
	#if tree_status == status.Withered:
		#return
	#if health > water:
		#health -= health_step
	#elif health < water: 
		#health += health_step

#this signal tells the graphics manager when it has to update the sprite
signal status_signal
#and we need to update the plant's status accordingly
#deprecated
#func update_status():
	#if health >= 80.0:
		#tree_status = status.Flourishing
	#elif health >= 50.0:
		#tree_status = status.Healthy
	#elif health >= 15.0:
		#tree_status = status.Ailing
	#else:
		#tree_status = status.Withered
		#bananas = 0

#gets the status as a string
func getstatus():
	if tree_status == status.Flourishing:
		return "Flourishing"
	elif tree_status == status.Healthy:
		return "Healthy"
	elif tree_status == status.Ailing:
		return "Ailing"
	elif tree_status == status.Withered:
		return "Withered"
	else:
		print("Could not fetch a proper status")
		return "Withered"

#a couple of signals so the tree can show off when something happens to it
signal harvest_signal(n)
signal watered_signal
#and a couple more so it can shiver and complain during the cut
signal strain_signal(x)
signal snap_signal

#the harvest manager reports how hard the rancher is pulling
func straining(x):
	strain_signal.emit(x)

#the harvest manager reports a botched cut
func snapped_stem():
	snap_signal.emit()

#when the rancher tend to the plant
func watering():
	water = true
	#only celebrate the watering when there was nothing to pick, a real harvest has its own signal
	if bananas == 0:
		watered_signal.emit()

#I believe what's below was slightly overengineered. Let's focus on the core gameplay
#the plant loses water over time
#@export var water_step = 0.15
#func waterloss():
	#water -= water_step
#maybe we hould add another function to simulate water loss due to the morning heat, but I whink we're fine for now

#this is, of course, the number of bananas on the tree
@export var bananas := 0
#and this is the function that should be called at the start of each game day to replenish them
func grow_bananas():
	if tree_status == status.Flourishing:
		bananas = 2
	elif tree_status == status.Healthy:
		bananas = 1
	elif tree_status == status.Ailing:
		bananas = randi()%2
	elif tree_status == status.Withered:
		bananas = 0
	status_signal.emit()
#a small function that returns that checks if there are bananas and harvests them
func harvest_bananas():
	var harvest = bananas
	if harvest == 0:
		return 0
	else:
		bananas = 0
		status_signal.emit()
		harvest_signal.emit(harvest)
		return harvest

#promoted to the major function influencing the plant's daily cycle
func lifecycle():
	if tree_status == status.Withered:
		return
	var rand = randi()%2
	if water == true:
		if tree_status != status.Flourishing:
			tree_status += rand
	elif water == false:
		tree_status -= rand
	grow_bananas()
	water = false

#setting up the Area2D function
@export var player : CharacterBody2D
@export var area : Area2D

#function to tell if the player is close to the plant
func is_close():
	return area.is_close

#to randomize plant status at game start
func random_bananas():
	tree_status = randi()%3+1 as status
	water = false
	grow_bananas()

#simple function to return the status
func mystatus():
	return tree_status
