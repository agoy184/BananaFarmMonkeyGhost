extends AudioStreamPlayer
#tiny script to regulate the sound of monkey movement

func spooky():
	if !playing:
		pitch_scale = randf_range(0.9,1.1)
		play()
