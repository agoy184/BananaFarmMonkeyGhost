extends Node
#just to update the top label  of the aforementioned panel

@export var title : Label

func update_title(number):
	title.text = "Night " + str(number) + " survived!"
