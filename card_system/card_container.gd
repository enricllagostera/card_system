extends Control

class_name CardContainer

const UNLIMITED_CAPACITY = -1

export(int, -1, 9999) var capacity := UNLIMITED_CAPACITY setget set_capacity, get_capacity
var _cards = []

signal card_added
signal card_added_already_in_container
signal card_added_over_capacity
signal card_removed
signal card_removed_container_was_empty
signal card_removed_id_not_found


func _init():
	_cards = []


func set_capacity(new_capacity):
# TODO emit signal when trying to make capacity smaller than current contents
	if new_capacity != null:
		capacity = new_capacity


func get_capacity():
	return capacity


func has_available_capacity(cards_to_add):
	if capacity == UNLIMITED_CAPACITY:
		return true
	return capacity >= count() + cards_to_add


func add(card:Card):
	if not has(card.card_id):
		if count() + 1 <= capacity or capacity == UNLIMITED_CAPACITY:
			_cards.append(card)
			card.container = self
			emit_signal("card_added")
		else:
			emit_signal("card_added_over_capacity")
	else:
		emit_signal("card_added_already_in_container")


func count():
	return _cards.size()


func get_ids() -> Array:
	var ids = []
	for c in _cards:
		ids.append(c.card_id)
	return ids


func is_empty():
	return count() == 0


func remove_last():
	var res = null
	if not _cards.empty():
		res = remove_by_id(_cards.back().card_id)
	else:
		emit_signal("card_removed_container_was_empty")
	return res


func remove_by_id(card_id):
	var res = null
	var i = find_index_by_id(card_id)
	if i >= 0:
		res = _cards[i]
		_cards.remove(i)
		res.container = null
		emit_signal("card_removed", res)
	else:
		emit_signal("card_removed_id_not_found")
	return res


func remove(card:Card):
	return remove_by_id(card.card_id)


func peek_last():
	if not _cards.empty():
		return _cards.back()
	return null


func find_index_by_id(card_id):
	for c in range(_cards.size()):
		if _cards[c].card_id == card_id:
			return c
	return -1


func find_by_id(card_id):
	var i = find_index_by_id(card_id)
	if i >= 0:
		return _cards[i]
	return null


func has(card_id) -> bool:
	return find_index_by_id(card_id) >= 0


func has_card(card) -> bool:
	if card != null and card is Card:
		return find_index_by_id(card.card_id) >= 0
	return false


func shuffle():
	_cards.shuffle()


static func switch(card:Card, origin:CardContainer, destination:CardContainer):
	if origin.has_card(card) and not destination.has_card(card):
		origin.remove(card)
		destination.add(card)
	else:
		push_warning("Switching containers failed.")
