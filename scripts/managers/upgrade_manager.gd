extends Node
#to manage upgrades purchased through the store
@export var storepanel : Control
@export var upgradepanel : Control

func _on_upgrade_button_pressed():
	storepanel.visible = false
	update_panel()
	upgradepanel.visible = true

func _on_back_button_pressed():
	upgradepanel.visible = false
	storepanel.visible = true

#could easily be expanded
func update_panel():
	setuplabel1()
	checkbutton1()

@export var shopmanager : Node
func getmoney():
	return shopmanager.money

class upgrade:
	var id: int
	var name: String
	var desc: String
	var price: int
	var purchased: bool
	
	func _init(i, n, d, p):
		id = i
		name = n
		desc = d
		price = p
		purchased = false

func buy(upgrade):
	#the check should not be necessary, because the button should be disabled, but better safe...
	if upgrade.purchased == true:
		return
	shopmanager.money -= upgrade.price
	upgrade.purchased = true

#Let's create a sample upgrade: magic boots to make the rancher faster
var boots = upgrade.new(0, "Magic Boots", "Increase the rancher's speed", 10)

#Simple function that determines what the boots do. In this case, increase player speed by 15%
@export var rancher_movement : Node
func activate_boots():
	print("Starting speed : " + str(rancher_movement.rancher_speed))
	rancher_movement.rancher_speed *= 1.15
	print("Final speed : " + str(rancher_movement.rancher_speed))

#Minimal label setup
@export var label1 : RichTextLabel
func setuplabel1():
	label1.text = "[center]" + boots.name + " , " + shopmanager.money_tag(boots.price) + "[/center]"

@export var tooltip : Label
func _on_upgrade_1_mouse_entered():
	tooltip.text = boots.desc
func _on_upgrade_1_mouse_exited():
	tooltip.text = ""

#Minimal button setup
@export var button1 : Button
func checkbutton1():
	if getmoney() < boots.price or boots.purchased:
		button1.disabled = true
	else:
		button1.disabled = false

func _on_button_1_pressed():
	buy(boots)
	activate_boots()
	update_panel()

#All this could easily be rationalized and expanded to accomodate several upgrades, and even progressive upgrades.
#But for now it is merely a proof of concept with minimal functionality.
