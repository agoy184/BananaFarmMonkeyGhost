extends Node
@export var darkness : CanvasModulate

func daylight():
	darkness.visible = false
func nighttime():
	darkness.visible = true
