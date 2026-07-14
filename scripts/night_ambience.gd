extends AudioStreamPlayer
#we must slightly adjust the pitch before every iteration
#this way, the ambience is always slightly different

func _on_finished():
	pitch_scale = randf_range(0.95,1.05)
	play()
