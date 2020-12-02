extends Node

class_name Deck

const UNLIMITED_CAPACITY := -1

var _cards :CardContainer

export var capacity := UNLIMITED_CAPACITY setget set_capacity, get_capacity

signal card_dealt
signal card_dealt_fail_empty
signal deck_shuffled


func _init():
	_cards = CardContainer.new()


func card_count() -> int:
    return _cards.count()


func add(card:Card) -> void:
	_cards.add(card)


func set_capacity(new_capacity):
    capacity = new_capacity


func get_capacity():
    return capacity


func peek_top() -> Card:
	return _cards.peek_last()


func deal_card() -> Card:
    var result = _cards.remove_last()
    if result != null:
        emit_signal("card_dealt", result)
    else:
        emit_signal("card_dealt_fail_empty")
    return result


func random_shuffle():
    randomize()
    _shuffle()


func repeatable_shuffle(new_seed:int):
    seed(new_seed)
    _shuffle()


func _shuffle():
    _cards.shuffle()
    emit_signal("deck_shuffled")


func get_ids() -> Array:
	return _cards.get_ids()