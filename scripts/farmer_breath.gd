extends AudioStreamPlayer
#simple script to play the sfx fully before playing it again

func breathe():
	if !playing:
		pitch_scale = randf_range(0.9,1.1)
		play()
