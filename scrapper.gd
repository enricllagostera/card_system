extends "res://driver.gd"

var card = null

func run():
	var result = []
	print("run ", name, " logic")
	card = peek_last()
	card.move_to_with_callback(card.rect_position+Vector2(0, -1000), 0.5, self, "clean_up")
	# result.append(card)
	return result

func clean_up():
	remove(card)
	card.queue_free()