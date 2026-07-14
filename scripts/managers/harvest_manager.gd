extends Node
#the stem-cutting minigame: hold E to saw the bunch loose, ease off before the stem snaps
@export var banana_audio : AudioStreamPlayer


@export var movement : Node
@export var inventory : Node
@export var floats : Node

#a couple of signals so the camera can celebrate or wince along
signal harvested_signal(perfect)
signal snap_signal

#the little bars that live above the tree being cut
@export var widget : Control
@export var cut_bar : ProgressBar
@export var strain_bar : ProgressBar

#how fast the saw gets through the stem while holding E
@export var cut_speed := 0.4
#how fast the stem stresses while sawing
@export var strain_rate := 0.5
#how fast the stem settles while resting
@export var cool_rate := 0.6
#past this much strain the gentle-hands bonus is gone
@export var danger := 0.75
#where the bars sit relative to the tree, in screen pixels (the tree art hugs the bottom of its frame)
@export var widget_offset := Vector2(-32, -130)
#strain bar goes from calm amber to angry red
@export var strain_ok := Color(1, 0.75, 0.3)
@export var strain_hot := Color(1, 0.25, 0.15)

var active := false
var plant = null
var progress := 0.0
var strain := 0.0
var perfect := true

#so the other managers know to leave E alone
func is_busy():
	return active

#called by the banana manager when the rancher starts on a fruiting tree
func start_cutting(p):
	active = true
	plant = p
	progress = 0.0
	strain = 0.0
	perfect = true
	movement.locked = true
	place_widget()
	update_bars()
	widget.visible = true

func _process(delta):
	if not active:
		return
	if Input.is_action_pressed("Interact"):
		progress += cut_speed * delta
		strain += strain_rate * delta
		if strain >= danger:
			perfect = false
		if strain >= 1.0:
			snap()
			return
		if progress >= 1.0:
			finish()
			return
	else:
		strain = maxf(strain - cool_rate * delta, 0.0)
		#a fresh tap on a move key means the rancher gives up on this bunch
		if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") \
		or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			stop()
			return
	plant.straining(strain)
	#the camera keeps drifting while the rancher is locked, so the bars follow every frame
	place_widget()
	update_bars()

#the clean cut: the bananas, plus a bonus one for a gentle hand
func finish():
	var harvest = plant.harvest_bananas()
	if perfect:
		harvest += 1
		floats.popup(plant.global_position, "+" + str(harvest) + "!", Color(1, 0.95, 0.15))
	else:
		floats.popup(plant.global_position, "+" + str(harvest))
	banana_audio.play()
	inventory.add_bananas(harvest)
	harvested_signal.emit(perfect)
	stop()

#too much force: the stem snaps and the bananas stay up there
func snap():
	plant.snapped_stem()
	floats.popup(plant.global_position, "snap!", Color(0.7, 0.9, 0.5))
	snap_signal.emit()
	stop()

func stop():
	active = false
	movement.locked = false
	widget.visible = false
	plant.straining(0.0)
	plant = null

#park the bars on the tree's canopy, or below it for trees hugging the top edge
#only the tree position goes through the camera transform: the offset stays in screen
#pixels, so the camera zoom can't stretch the bars up into the dark
func place_widget():
	var tree = widget.get_viewport().get_canvas_transform() * plant.global_position
	var pos = tree + widget_offset
	if pos.y < 8.0:
		pos.y = tree.y + 24.0
	widget.position = pos

func update_bars():
	cut_bar.value = progress
	strain_bar.value = strain
	#set the color every frame so the shared stylebox never stays red across a reload
	strain_bar.get_theme_stylebox("fill").bg_color = strain_ok.lerp(strain_hot, strain)
