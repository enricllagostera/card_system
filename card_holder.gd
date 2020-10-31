extends Control

var card:Card = null

func _process(delta):
	if not card:
		return
	card.rect_position = lerp(card.rect_position, rect_position, delta * 10)
