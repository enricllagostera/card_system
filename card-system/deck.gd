extends Node

class_name Deck

const UNLIMITED_CAPACITY := -1

var _cards := []

export var capacity := UNLIMITED_CAPACITY setget set_capacity, get_capacity

signal card_added
signal card_added_fail_overcapacity
signal card_dealt
signal card_dealt_fail_empty


func _init():
    _cards = []


func card_count() -> int:
    return _cards.size()


func add_card(card:Card) -> void:
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


func deal_card() -> Card:
    var result = _cards.pop_back()
    if result != null:
        emit_signal("card_dealt", result)
    else:
        emit_signal("card_dealt_fail_empty")
    return result