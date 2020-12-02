extends Reference

class_name CardContainer

const UNLIMITED_CAPACITY = -1

var capacity := UNLIMITED_CAPACITY setget set_capacity, get_capacity

# This class stores cards in an "ordered" dictionary, basically relying in GDScript implementation in 3.0 keeping the order of addition. This could become a problem.
var _cards = {}

signal added_card_already_in_container
signal added_card_over_capacity
signal removed_card_container_was_empty
signal removed_card_id_not_found


func _init():
	pass


func set_capacity(new_capacity):
# TODO emit signal when trying to make capacity smaller than current contents
	capacity = new_capacity


func get_capacity():
	return capacity


func add(card:Card):
	if not _cards.has(card.get_id()):
		if count() + 1 <= capacity or capacity == UNLIMITED_CAPACITY:
			_cards[card.get_id()] = card
		else:
			emit_signal("added_card_over_capacity")
	else:
		emit_signal("added_card_already_in_container")


func count():
	return _cards.size()


func remove_last():
	var res = null
	if not _cards.empty():
		var top_id = _cards.keys().back()
		res = remove(top_id)
	else:
		emit_signal("removed_card_container_was_empty")
	return res


func remove(id):
	var res = null
	if _cards.has(id):
		res = _cards[id]
		_cards.erase(id)
	else:
		emit_signal("removed_card_id_not_found")
	return res
	