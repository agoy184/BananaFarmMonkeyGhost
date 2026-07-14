extends AnimatedSprite2D
#for managing the monkey sprite

func spooky():
	speed_scale = 1.0
	if !is_playing() or animation != "floating":
		play("floating")

func bouncy():
	speed_scale = 1.0
	if !is_playing() or animation != "bouncing":
		play("bouncing")

func screaming():
	speed_scale = 2.0
	play("screaming")
	await animation_finished
