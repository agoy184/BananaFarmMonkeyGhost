extends Node
#just a prototype, simulating how a single banana tree should behave

#the basic idea is that the farmer must tend the trees at night
#or they will wither and he will not be able to harvest on the following nights
enum status {Withered, Ailing, Healthy, Flourishing}
@export var tree_status : status

#we keep track of how much water and care the plant has recently received
@export var water := 100.0
#and we keep track of the plant's long term health
@export var health := 40.0
#helath slowly drifts to the water level
@export var health_step := 0.05
func health_drift():
	if tree_status == status.Withered:
		return
	if health > water:
		health -= health_step
	elif health < water: 
		health += health_step
	update_status()

#this signal tells the graphics manager when it has to update the sprite
signal status_signal
#and we need to update the plant's status accordingly
func update_status():
	if health >= 80.0:
		tree_status = status.Flourishing
	elif health >= 50.0:
		tree_status = status.Healthy
	elif health >= 15.0:
		tree_status = status.Ailing
	else:
		tree_status = status.Withered
		bananas = 0
	status_signal.emit()

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

#when the rancher tend to the plant
func watering():
	water = 100.0
#the plant loses water over time
@export var water_step = 0.15
func waterloss():
	water -= water_step
#maybe we hould add another function to simulate water loss due to the morning heat, but I whink we're fine for now

#this is, of course, the number of bananas on the tree
@export var bananas := 0
#and this is the function that should be called at the start of each game day to replenish them
func grow_bananas():
	if tree_status == status.Flourishing:
		bananas = randi()%6+4
	elif tree_status == status.Healthy:
		bananas = randi()%6+1
	elif tree_status == status.Ailing:
		bananas = randi()%6-1
		if bananas <= 0:
			bananas = 0
	elif tree_status == status.Withered:
		bananas = 0
#a small function that returns that checks if there are bananas and harvests them
func harvest_bananas():
	var harvest = bananas
	if harvest == 0:
		return 0
	else:
		bananas = 0
		update_status()
		return harvest

#just a helper function doing all the plant should as the time goes on
func lifecycle():
	waterloss()
	health_drift()
	update_status()

#setting up the Area2D function
@export var player : CharacterBody2D
@export var area : Area2D

#function to tell if the player is close to the plant
func is_close():
	return area.is_close

#to randomize plant status at game start
func random_bananas():
	health = randi()%60+30.0
	water = randi()%60+30.0
	update_status()
	grow_bananas()
	lifecycle()
