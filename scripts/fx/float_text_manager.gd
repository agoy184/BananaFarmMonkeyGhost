extends Node
#spawns little "+N" labels that float up and fade
#they live in a canvaslayer so the darkness of the canvasmodulate can't eat them
#note: the camera moves the world under the layer, so world coords go through the canvas transform

@export var fx_layer : CanvasLayer
#how far up the text drifts before vanishing
@export var rise := 40.0
@export var lifetime := 0.7

func popup(pos, text, color := Color(1, 0.9, 0.4)):
	var l = Label.new()
	l.text = text
	l.modulate = color
	l.z_index = 100
	l.add_theme_font_size_override("font_size", 22)
	fx_layer.add_child(l)
	var screen = fx_layer.get_viewport().get_canvas_transform() * pos
	#keep the text on screen even for trees hugging the top edge
	l.position = Vector2(screen.x - 10.0, maxf(screen.y - 70.0, 8.0))
	var t = l.create_tween()
	t.tween_property(l, "position:y", l.position.y - rise, lifetime)
	t.parallel().tween_property(l, "modulate:a", 0.0, lifetime)
	t.tween_callback(l.queue_free)
