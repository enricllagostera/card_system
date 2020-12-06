extends CardContainer

class_name Deck

signal deck_shuffled

func random_shuffle():
	randomize()
	_shuffle()


func repeatable_shuffle(new_seed:int):
	seed(new_seed)
	_shuffle()


func _shuffle():
	shuffle()
	emit_signal("deck_shuffled")
