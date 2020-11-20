extends "res://addons/gut/test.gd"

var CardScene = load("res://card-system/card.tscn")
var card_scene


func before_each():
	card_scene = CardScene.instance()
	add_child_autofree(card_scene)

func test_init_setup():
	assert_almost_eq(card_scene.rect_pivot_offset, card_scene.rect_size / 2, Vector2(0.5, 0.5))
	assert_connected(card_scene, card_scene, "mouse_entered", "mouse_entered")
	assert_connected(card_scene, card_scene, "mouse_exited", "mouse_exited")

func test_sensor_setup():
	var sensor = card_scene.get_node("Sensor")
	print(str(sensor))
	assert_not_null(sensor)
	assert_connected(sensor, card_scene, "area_entered", "_on_card_entered_area")
	assert_connected(sensor, card_scene, "area_exited", "_on_card_exited_area")
