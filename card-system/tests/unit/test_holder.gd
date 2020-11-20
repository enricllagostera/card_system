extends "res://addons/gut/test.gd"

var HolderScene = load("res://card-system/holder.tscn")
var holder


func before_each():
	holder = HolderScene.instance()
	add_child_autofree(holder)

func test_init():
	assert_almost_eq(holder.rect_pivot_offset, holder.rect_size/2, Vector2(0.1, 0.1))
	assert_eq(holder._cards.size(), 0)

func test_ready():
	var sensor = holder.get_node("Sensor")
	assert_eq(sensor.holder, holder, "Sensor area refers back to parent.")
	assert_almost_eq(sensor.position, holder.rect_pivot_offset, Vector2(0.1, 0.1), "Sensor position is aligned with parent pivot offset.")
	var visual = holder.get_node("Visual")
	assert_almost_eq(visual.rect_pivot_offset, holder.rect_pivot_offset, Vector2(0.1, 0.1), "Visual position is aligned with parent pivot offset.")

