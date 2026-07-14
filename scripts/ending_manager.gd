extends Node
#this is a script to gather several basic stats at the end of the game, to determine which ending the player gets.

func get_all():
	get_money()
	get_plants()

#we can retrieve money
@export var money_manager : Node
var end_money := 0
func get_money():
	end_money = money_manager.money

#and the condition of the trees within the plantation
@export var banana_manager : Node
var end_flourishing := 0
var end_healthy := 0
var end_ailing := 0
var end_withered := 0

func get_plants():
	for i in banana_manager.plants:
		var s = i.mystatus()
		if s == 3:
			end_flourishing += 1
		elif s == 2:
			end_healthy += 1
		elif s == 1:
			end_ailing += 1
		elif s == 0:
			end_withered += 1

func checkending():
	if end_money >= 100:
		print("returning true")
		return true
	else :
		return false
