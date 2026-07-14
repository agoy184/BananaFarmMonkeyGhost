extends Node
#the inventory is rather simple, but we still need to know how many bananas the rancher is carrying

signal invsignal
#to better communicate with the UI

@export var bananas := 0
#adding a maximum inventory size in case we end up using it. If not, just set it at a very high value
@export var max_bananas := 999

func add_bananas(n):
	if n <= 0 || bananas == max_bananas:
		return false
	var tot = bananas + n
	if tot <= max_bananas:
		bananas += n
		invsignal.emit()
		return true
	else:
		bananas = max_bananas

#a function to subtract bananas, useful to purchase banana-themed upgrades or unload the inventory at the end of the day
func sub_bananas(n):
	if n<= 0 || n > bananas:
		return false
	else:
		bananas -= n
		invsignal.emit()
		return true

func empty_inventory():
	sub_bananas(bananas)

func str_inventory():
	var invstr = "Bananas: " + str(bananas)
	return invstr
