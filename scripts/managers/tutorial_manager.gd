extends Node
#walks the rancher through the basics, then hands over to the real night

@export var rancher_body : CharacterBody2D
@export var tree : Node
@export var house : Node
@export var flare_manager : Node
@export var prompt_label : RichTextLabel
#the little arrow that floats around the rancher pointing at the next stop
@export var arrow : Node2D
#seconds of walking needed to pass the first step
@export var move_time := 1
#little pause on the final message before the real night starts
@export var outro_time := 1.2
#how far from the rancher the arrow floats, and how close to the stop it hides
@export var arrow_distance := 70.0
@export var arrow_bob := 6.0
@export var arrow_close := 150.0
#the color that makes key names pop in the prompts
@export var key_color := Color(1, 0.87, 0.33)

var step := 0
var walked := 0.0
var target = null
var bob_t := 0.0

func _ready():
	#force a full tree so the harvest step always has bananas
	#(runs after the banana manager's randomizer thanks to node order)
	tree.tree_status = 3
	tree.grow_bananas()
	set_prompt(1, "Walk around - " + key("WASD") + " or " + key("arrow keys"))

func _process(delta):
	if step == 0:
		if rancher_body.velocity != Vector2.ZERO:
			walked += delta
		if walked >= move_time:
			step = 1
			target = tree
			set_prompt(2, "Hold " + key("E") + " by the banana tree - ease off before the stem snaps")
	elif step == 2:
		if flare_manager.flareon:
			step = 3
			target = house
			set_prompt(4, "Press " + key("E") + " at the house to end the night")
	aim_arrow(delta)

#float the arrow around the rancher, aimed at the current stop
func aim_arrow(delta):
	if target == null:
		arrow.visible = false
		return
	var to = target.global_position - rancher_body.global_position
	if to.length() < arrow_close:
		arrow.visible = false
		return
	arrow.visible = true
	bob_t += delta
	var dir = to.normalized()
	arrow.global_position = rancher_body.global_position + dir * (arrow_distance + sin(bob_t * 4.0) * arrow_bob)
	arrow.rotation = dir.angle()

#the harvest manager celebrates a clean cut
func _on_harvest_manager_harvested_signal(_perfect):
	if step == 1:
		step = 2
		target = null
		set_prompt(3, key("Right-click") + " to hurl a flare - it scares off the monkey ghost")

#the stem snapped: same step, gentler words
func _on_harvest_manager_snap_signal():
	if step == 1:
		set_prompt(2, "Snap! Gently now - hold " + key("E") + ", rest when the strain climbs")

#the home manager thinks we're the game manager, and that's fine
func end_night():
	if step == 3:
		finish()

func finish():
	step = 4
	target = null
	prompt_label.text = "[center]That's everything - good luck out there[/center]"
	await get_tree().create_timer(outro_time).timeout
	go_to_game()

func go_to_game():
	get_tree().change_scene_to_file("res://scenes/root.tscn")

func _on_skip_button_pressed():
	go_to_game()

#wraps a key name in the highlight color
func key(s):
	return "[color=#" + key_color.to_html(false) + "]" + s + "[/color]"

func set_prompt(n, text):
	prompt_label.text = "[center]" + str(n) + "/4  " + text + "[/center]"
