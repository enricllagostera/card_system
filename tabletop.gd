extends Node2D

class_name Tabletop

const UNLIMITED_CAPACITY := -1

var cards :CardContainer

export(int) var capacity setget set_capacity, get_capacity


func _init():
	cards = CardContainer.new()


func add(card):
	cards.add(card)


func count():
	return cards.count()


func find(card):
	return cards._find_by_id(card.id)


func find_by_id(id):
	return cards._find_by_id(id)


func is_empty():
	return cards.count() == 0


func remove(card):
	return cards.remove(card)


func set_capacity(new_capacity):
	cards.capacity = new_capacity


func get_capacity():
	return cards.capacity

