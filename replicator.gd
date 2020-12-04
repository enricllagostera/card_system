extends "res://driver.gd"

var card

func run():
	var result = []
	print("run ", name, " logic")
	var clone = _cards.peek_last().duplicate()
	clone.set_id()
	result.append(clone)
	result.append(_cards.peek_last())
	card = remove_from_top()
	card.move_to(card.rect_position + Vector2(2000,0), 0.5)
	return result