extends "res://driver.gd"

var card

func run():
	var result = []
	print("run ", name, " logic")
	var clone = _cards.peek_last().duplicate()
	result.append(clone)
	result.append(_cards.peek_last())
	card = remove_from_top()
	card.move_to_with_callback(card.rect_position + Vector2(2000,0), 0.5, self, "clean_up")
	return result


func clean_up():
	card.get_parent().remove_child(card)
	add_child(card)
