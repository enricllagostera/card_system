extends AudioStreamPlayer

class_name SfxPlayer

export(float) var offset = 0.36
export(float) var pitch_variation_range = 0.2

func _on_event_happened():
	pitch_scale = rand_range(1-pitch_variation_range/2, 1 + pitch_variation_range/2)
	play(offset)
