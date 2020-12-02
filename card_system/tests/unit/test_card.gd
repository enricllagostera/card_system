extends "res://addons/gut/test.gd"

var CardScene = load("res://card_system/card.tscn")
var card_scene


func before_each():
	card_scene = CardScene.instance()
	add_child_autofree(card_scene)


func test_init_setup():
	var collision_shape = card_scene.get_node("Sensor/CollisionShape2D")
	assert_almost_eq(collision_shape.shape.extents, card_scene.rect_size / 2, Vector2(0.5, 0.5))
	assert_almost_eq(card_scene.rect_pivot_offset, card_scene.rect_size / 2, Vector2(0.5, 0.5))


func test_sensor_setup():
	var sensor = card_scene.get_node("Sensor")
	print(str(sensor))
	assert_not_null(sensor)
	assert_connected(sensor, card_scene, "area_entered", "_on_card_entered_area")
	assert_connected(sensor, card_scene, "area_exited", "_on_card_exited_area")


func test_id_accessors():
	assert_accessors(card_scene,"id", card_scene.get_id(), "2")
	card_scene.set_id()
	var card2 = CardScene.instance()
	add_child_autofree(card2)
	assert_ne(card_scene.id, card2.id, "Two cards should have different ids by default.")
