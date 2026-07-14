extends AudioStreamPlayer
#tiny script for managing this audio

func grr():
	if !playing:
		pitch_scale = randf_range(0.9,1.1)
		play()
