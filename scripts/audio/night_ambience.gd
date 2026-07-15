extends AudioStreamPlayer
#we must slightly adjust the pitch before every iteration
#this way, the ambience is always slightly different

#to stop the ambient when the monkey is pursuing
@export var monkey : Node
var must_restart := false

func _on_finished():
	if !monkey.going_bananas:
		pitch_scale = randf_range(0.95,1.05)
		play()
	else:
		must_restart = true

func _process(delta):
	if !monkey.going_bananas and must_restart:
		pitch_scale = randf_range(0.95,1.05)
		play()
		must_restart = false
