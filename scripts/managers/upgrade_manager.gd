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
	setuplabel2()
	setuplabel3()
	checkbutton1()
	checkbutton2()
	checkbutton3()
	shopmanager.moneysignal.emit()

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
var boots = upgrade.new(0, "Sturdy Boots", "Makes the rancher faster on rough terrain", 10)
var watch = upgrade.new(1, "Stopwatch", "Makes movement faster", 15)
var machete = upgrade.new(2, "Shiny Machete", "Makes harvesting faster", 15)

#Simple function that determines what the boots do. In this case, increase player on ground and mud
@export var ground_manager : Node
func activate_boots():
	ground_manager.groundspeed = 1.10
	ground_manager.mudspeed = 1.0

#Simple function to increase player overall speed when buying the stopwatch
@export var rancher_movement : Node
func activate_watch():
	rancher_movement.rancher_speed *= 1.15

@export var harvest_manager : Node
func activate_machete():
	harvest_manager.cut_speed = 0.6
	harvest_manager.strain_rate = 0.7
	harvest_manager.cool_rate = 0.5

#Minimal label setup
@export var label1 : RichTextLabel
func setuplabel1():
	label1.text = "[center]" + boots.name + " , " + shopmanager.money_tag(boots.price) + "[/center]"
@export var label2 : RichTextLabel
func setuplabel2():
	label2.text = "[center]" + watch.name + " , " + shopmanager.money_tag(watch.price) + "[/center]"
@export var label3 : RichTextLabel
func setuplabel3():
	label3.text = "[center]" + machete.name + " , " + shopmanager.money_tag(machete.price) + "[/center]"

@export var tooltip : Label
func _on_upgrade_1_mouse_entered():
	tooltip.text = boots.desc
func _on_upgrade_2_mouse_entered():
	tooltip.text = watch.desc
func _on_upgrade_3_mouse_entered():
	tooltip.text = machete.desc
func _on_upgrade_1_mouse_exited():
	tooltip.text = ""

#Minimal button setup
@export var button1 : Button
func checkbutton1():
	if getmoney() < boots.price or boots.purchased:
		button1.disabled = true
	else:
		button1.disabled = false

@export var button2 : Button
func checkbutton2():
	if getmoney() < watch.price or watch.purchased:
		button2.disabled = true
	else:
		button2.disabled = false

@export var button3 : Button
func checkbutton3():
	if getmoney() < machete.price or machete.purchased:
		button3.disabled = true
	else:
		button3.disabled = false

func _on_button_1_pressed():
	buy(boots)
	activate_boots()
	update_panel()
func _on_button_2_pressed():
	buy(watch)
	activate_watch()
	update_panel()
func _on_button_3_pressed() -> void:
	buy(machete)
	activate_machete()
	update_panel()
