extends AudioStreamPlayer

func _on_Holder_card_dropped():
	pitch_scale = rand_range(0.9, 1.1)
	play(0.36)
