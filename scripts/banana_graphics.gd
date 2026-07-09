extends Node2D
@export var plant : Node
@export var sprite : AnimatedSprite2D

func setframe(f):
	sprite.animation = "default"
	sprite.stop()
	sprite.frame = f

func update_sprite():
	var status = plant.getstatus()
	var bananas = plant.bananas
	print(str(status) + " " + str(bananas))
	if status == "Flourishing" && bananas == 2 :
		setframe(5)
	elif (status == "Healthy" || status == "Flourishing") && bananas == 1 :
		setframe(4)
	elif (status == "Healthy" || status == "Flourishing") && bananas == 0 :
		setframe(3)
	elif status == "Ailing" && bananas != 0 :
		setframe(2)
	elif status == "Ailing" && bananas == 0 :
		setframe(1)
	elif status == "Withered" && bananas == 0 :
		setframe(0)
	else:
		print("Something went wrong with the status")


func _on_banana_status_signal():
	update_sprite()
