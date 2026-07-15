extends Node
#to manage the sound of footsteps and adjust speed based on terrain type

var groundspeed := 1.0
var woodspeed := 1.2
var mudspeed := 0.6

@export var groundsound : AudioStreamPlayer
@export var woodsound : AudioStreamPlayer

@export var tilemap : TileMapLayer
@export var rancher : CharacterBody2D
#the rancher movement manager
@export var manager : Node

#basic audio functions
func playwood():
	if !woodsound.playing:
		groundsound.stop()
		woodsound.play()
func playground():
	if !groundsound.playing:
		woodsound.stop()
		groundsound.play()
func playnone():
	woodsound.stop()
	groundsound.stop()

#we get the custom data "terrain_type" from the tileset
func get_terrain_data():
	var cell = tilemap.local_to_map(rancher.global_position)
	var data = tilemap.get_cell_tile_data(cell)
	if data:
		var result = data.get_custom_data("terrain_type")
		return result
	return "error"

func adjust_speed(terrain):
	if terrain == "Wood":
		manager.groundfactor = woodspeed
	elif terrain == "Ground":
		manager.groundfactor = groundspeed
	elif terrain == "Mud":
		manager.groundfactor = mudspeed

func adjust_audio(terrain):
	if manager.rancher_body.velocity == Vector2.ZERO:
		playnone()
		return
	if terrain == "Wood":
		playwood()
	else:
		playground()

func _process(data):
	adjust_speed(get_terrain_data())
	adjust_audio(get_terrain_data())
