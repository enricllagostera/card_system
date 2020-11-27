extends Node

class_name Deck

const UNLIMITED_CAPACITY := -1

var _cards := []

export var capacity := UNLIMITED_CAPACITY setget set_capacity, get_capacity

signal card_added
signal card_added_fail_overcapacity
signal card_added_fail_no_duplicates
signal card_dealt
signal card_dealt_fail_empty
signal deck_shuffled


func _init():
    _cards = []


func card_count() -> int:
    return _cards.size()


func add_card(card:Card) -> void:
    if _cards.has(card):
        emit_signal("card_added_fail_no_duplicates")
        return

    if (capacity == UNLIMITED_CAPACITY):
        _cards.append(card)
        emit_signal("card_added")
        return
    if card_count() + 1 <= capacity:
        _cards.append(card)
        emit_signal("card_added")
        return;
    emit_signal("card_added_fail_overcapacity")


func set_capacity(new_capacity):
    capacity = new_capacity


func get_capacity():
    return capacity


func peek_card() -> Card:
	return _cards.back()


func deal_card() -> Card:
    var result = _cards.pop_back()
    if result != null:
        emit_signal("card_dealt", result)
    else:
        emit_signal("card_dealt_fail_empty")
    return result


func random_shuffle():
    randomize()
    _shuffle()


func _shuffle():
    _cards.shuffle()
    emit_signal("deck_shuffled")


func repeatable_shuffle(new_seed:int):
    seed(new_seed)
    _shuffle()
