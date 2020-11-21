extends "res://addons/gut/test.gd"

var HolderScene = load("res://card-system/holder.tscn")
var holder
var Card = load("res://card-system/card.tscn")


func before_each():
	holder = HolderScene.instance()
	add_child_autofree(holder)


func test_init():
	assert_almost_eq(holder.rect_pivot_offset, holder.rect_size/2, Vector2(0.1, 0.1))
	assert_eq(holder._cards.size(), 0)


func test_ready():
	var sensor = holder.get_node("Sensor")
	var visual = holder.get_node("Visual")
	assert_eq(sensor.holder, holder, "Sensor area refers back to parent.")
	assert_almost_eq(sensor.position, holder.rect_pivot_offset, Vector2(0.1, 0.1), "Sensor position is aligned with parent pivot offset.")
	assert_almost_eq(visual.rect_pivot_offset, holder.rect_pivot_offset, Vector2(0.1, 0.1), "Visual position is aligned with parent pivot offset.")


func test_add_card():
	var card_double = double(Card).instance()
	watch_signals(holder)
	holder._add_card(card_double)
	assert_eq(holder._cards.size(), 1, "Card collection increased by one.")
	assert_signal_emitted(holder, "card_added")


func test_get_sensor():
	var sensor = holder.get_node("Sensor")
	assert_eq(holder.get_sensor(), sensor)


func test_has_card():
	var card_double = double(Card).instance()
	assert_false(holder.has_card(card_double))
	holder._add_card(card_double)
	assert_true(holder.has_card(card_double))



