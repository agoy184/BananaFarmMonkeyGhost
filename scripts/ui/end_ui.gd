extends Node
#simple script to manage the end panel.

@export var mlabel : Label
@export var flolabel : Label
@export var helabel : Label
@export var ailabel : Label
@export var wilabel : Label

@export var endmanager : Node

func update_panel():
	endmanager.get_all()
	mlabel.text = "$"+str(endmanager.end_money)
	flolabel.text = "Floursihing: " + str(endmanager.end_flourishing)
	helabel.text = "Healthy: " + str(endmanager.end_healthy)
	ailabel.text = "Ailing: " + str(endmanager.end_ailing)
	wilabel.text = "Withered: " + str(endmanager.end_withered)
