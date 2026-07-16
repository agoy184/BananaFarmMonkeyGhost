extends Node
#for high-level management stuff, such as starting and ending the game
#for making different important scripts talk to each other

@export var time : Node
@export var shop : Node
@export var win_panel : Control
@export var end_panel : Control
@export var endui : Node
@export var endmanager : Node

@export var player_movement : Node
@export var monkey_movement : Node
@export var inventory_manager : Node

@export var night_panel : Control
@export var night_ui : Node
#false while the shop is deciding what happens next, so E can't end the night twice
var night_active := true

func game_start():
	#to be done later, much later
	pass

#called by the home manager when the rancher goes home for the night
func end_night():
	if not night_active:
		return
	night_active = false
	night_ui.update_title(time.numday)
	night_panel.visible = true

#rolls the world into the next night, called by the shop's sleep button
func start_night():
	night_panel.visible = false
	night_active = true
	time.new_night()

func game_over():
	#pause survives scene reloads, so always clear it first
	get_tree().paused = false
	time.new_night()
	player_movement.locked = false
	inventory_manager.empty_inventory()
	player_movement.goback()

func game_won():
	get_tree().paused = true
	endui.update_panel()
	win_panel.visible = true

func _on_menu_button_pressed():
	win_panel.visible = false
	end_panel.visible = true

func _on_end_button_pressed():
	get_tree().paused = false
	if endmanager.checkending():
		get_tree().change_scene_to_file("res://scenes/win.tscn")
	else :
		get_tree().change_scene_to_file("res://scenes/loss.tscn")

func _on_back_button_store_pressed():
	shop.close_shop()

func new_day():
	pass
