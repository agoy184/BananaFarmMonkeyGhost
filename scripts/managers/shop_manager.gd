extends Node
#the night market: sell the night's bananas, then pay the candle-person before heading out again

signal moneysignal
#to better communicate with the UI

@export var gmanager : Node
@export var inventory : Node
@export var candle : Node
@export var time : Node

#the shop's own ui pieces
@export var panel : Control
@export var title_label : Label
@export var summary_label : RichTextLabel
@export var refuel_button : Button

@export var money := 0
@export var price_per_banana := 3
@export var refuel_cost := 8

#every $ amount in the shop is written in this colour, so money reads as money
@export var money_color := Color(0.494, 0.82, 0.478)

var last_sold = 0
var last_earned = 0

#freezes the game and opens the night market
func open_shop():
	get_tree().paused = true
	sell_bananas()
	update_panel()
	panel.visible = true

func close_shop():
	get_tree().paused = false
	panel.visible = false

@export var chaching : AudioStreamPlayer
#turns the carried bananas into money
func sell_bananas():
	last_sold = inventory.bananas
	last_earned = last_sold * price_per_banana
	if last_sold != 0:
		chaching.play()
	money += last_earned
	inventory.empty_inventory()
	moneysignal.emit()

#wraps a $ amount in the money colour, for the bbcode labels
func money_tag(amount):
	return "[color=#" + money_color.to_html(false) + "]$" + str(amount) + "[/color]"

func update_panel():
	title_label.text = "Night " + str(mini(time.night_number(), time.daylimit)) + " survived"
	summary_label.text = "[center]Sold " + str(last_sold) + " bananas for " + money_tag(last_earned) \
		+ "\nPurse: " + money_tag(money) + "   Wax: " + str(roundi(candle.wax)) + " / " + str(roundi(candle.maxwax)) \
		+ "[/center]"
	refuel_button.text = "Refuel candle - $" + str(refuel_cost)
	refuel_button.disabled = money < refuel_cost or candle.wax >= candle.maxwax

func _on_refuel_button_pressed():
	money -= refuel_cost
	candle.refill()
	moneysignal.emit()
	update_panel()

func _on_sleep_button_pressed():
	panel.visible = false
	get_tree().paused = false
	gmanager.start_night()

func money_str():
	return "$" + str(money)
