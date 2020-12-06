extends "res://driver.gd"

var card

func run():
	var result = []
	print("run ", name, " logic")
	card = peek_last()
	card.move_to(card.rect_position + Vector2(2000,0), 0.5)
	var clone = { 
		"data": card.data.duplicate(true) 
	}
	result.append(card)
	result.append(clone)
	return result
