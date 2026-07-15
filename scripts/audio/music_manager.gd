extends Node
#script to switch between main music and store music

@export var main : AudioStreamPlayer
@export var store : AudioStreamPlayer
var playstore := false

func _process(delta):
	if !playstore:
		if !main.playing:
			store.stop()
			main.play()
	if playstore:
		if !store.playing:
			main.stop()
			store.play()

#call this on entering and exiting the store to switch the music
func switch():
	playstore = !playstore
