extends Reference

class_name CardContainer

const UNLIMITED_CAPACITY = -1

var capacity := UNLIMITED_CAPACITY setget set_capacity, get_capacity
var _cards = []

signal added_card
signal added_card_already_in_container
signal added_card_over_capacity
signal removed_card
signal removed_card_container_was_empty
signal removed_card_id_not_found


func _init():
	_cards = []


func set_capacity(new_capacity):
# TODO emit signal when trying to make capacity smaller than current contents
	capacity = new_capacity


func get_capacity():
	return capacity


func add(card:Card):
	if not has(card.id):
		if count() + 1 <= capacity or capacity == UNLIMITED_CAPACITY:
			_cards.append(card)
			emit_signal("added_card")
		else:
			emit_signal("added_card_over_capacity")
	else:
		emit_signal("added_card_already_in_container")


func count():
	return _cards.size()


func get_ids() -> Array:
	var ids = []
	for c in _cards:
		ids.append(c.id)
	return ids


func remove_last():
	var res = null
	if not _cards.empty():
		res = remove_by_id(_cards.back().id)
	else:
		emit_signal("removed_card_container_was_empty")
	return res


func remove_by_id(id):
	var res = null
	var i = _find_index_by_id(id)
	if i >= 0:
		res = _cards[i]
		_cards.remove(i)
		emit_signal("removed_card")
	else:
		emit_signal("removed_card_id_not_found")
	return res


func remove(card):
	return remove_by_id(card.id)


func peek_last():
	if not _cards.empty():
		return _cards.back()
	return null


func _find_index_by_id(id):
	for c in range(_cards.size()):
		if _cards[c].id == id:
			return c
	return -1


func _find_by_id(id):
	var i = _find_index_by_id(id)
	if i >= 0:
		return _cards[i]
	return null


func has(id) -> bool:
	return _find_index_by_id(id) >= 0


func shuffle():
	_cards.shuffle()
