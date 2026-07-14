extends Node
#for high-level management stuff, such as starting and ending the game
#for making different important scripts talk to each other

@export var time : Node
@export var shop : Node
@export var win_panel : Control
@export var end_panel : Control
@export var endui : Node
@export var endmanager : Node

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
	shop.open_shop()

#rolls the world into the next night, called by the shop's sleep button
func start_night():
	night_active = true
	time.new_night()

func game_over():
	#pause survives scene reloads, so always clear it first
	get_tree().paused = false
	get_tree().reload_current_scene()

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

func new_day():
	pass
