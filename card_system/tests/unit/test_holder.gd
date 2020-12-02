extends "res://addons/gut/test.gd"

var HolderScene = load("res://card_system/holder.tscn")
var holder
var Card = load("res://card_system/card.tscn")


func before_each():
	holder = HolderScene.instance()
	add_child_autofree(holder)


func test_init():
	assert_almost_eq(holder.rect_pivot_offset, holder.rect_size/2, Vector2(0.1, 0.1))
	assert_eq(holder.count(), 0)
	
	
func test_ready():
	var sensor = holder.get_node("Sensor")
	var collision_shape = sensor.get_node("CollisionShape2D") as CollisionShape2D
	var visual = holder.get_node("Visual")
	assert_almost_eq(collision_shape.shape.extents, holder.rect_size * 0.5, Vector2(0.5, 0.5))
	assert_eq(sensor.holder, holder, "Sensor area refers back to parent.")
	assert_almost_eq(sensor.position, holder.rect_pivot_offset, Vector2(0.1, 0.1), "Sensor position is aligned with parent pivot offset.")
	assert_almost_eq(visual.rect_pivot_offset, holder.rect_pivot_offset, Vector2(0.1, 0.1), "Visual position is aligned with parent pivot offset.")


func test_add_card():
	var card_double = double(Card).instance()
	add_child_autofree(card_double)
	watch_signals(holder)
	holder._add(card_double)
	assert_eq(holder.count(), 1, "Card collection increased by one.")
	assert_signal_emitted(holder, "card_added")


func test_get_sensor():
	var sensor = holder.get_node("Sensor")
	assert_eq(holder.get_sensor(), sensor)


func test_has_card():
	var card_temp = Card.instance()
	add_child_autofree(card_temp)
	assert_false(holder.has_card(card_temp))
	holder._add(card_temp)
	assert_true(holder.has_card(card_temp))




