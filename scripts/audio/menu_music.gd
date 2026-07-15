extends AudioStreamPlayer
#can't find the loop option, shame on me

func _process(delta):
	if !playing:
		play()
