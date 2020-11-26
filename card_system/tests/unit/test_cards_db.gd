extends "res://addons/gut/test.gd"

var CardDb = load("res://card_system/card_db.tscn")
var card_db

func before_each():
	card_db = CardDb.instance()
	add_child_autofree(card_db)


func test_card_db_init_invalid_file():
	assert_has_method(card_db, "load")
	assert_file_does_not_exist(card_db.json_file_path)


func test_card_db_set_file():
	watch_signals(card_db)
	card_db.set_json_file_path("res://card_system/tests/_____.json")
	assert_signal_emitted(card_db, "json_file_path_invalid")
	card_db.set_json_file_path("res://card_system/tests/card_db_test.json")
	assert_file_exists(card_db.json_file_path)

func test_loading_no_file():
	card_db.set_json_file_path("res://card_system/tests/_____.json")
	watch_signals(card_db)
	var data = card_db.load()
	assert_signal_emitted(card_db, "json_file_path_invalid")
	assert_eq(data.size(), 0)


func test_loading_invalid_json():
	card_db.set_json_file_path("res://card_system/tests/card_db_invalid_json.json")
	watch_signals(card_db)
	var data = card_db.load()
	assert_signal_emitted(card_db, "json_file_invalid_json")
	assert_eq(data.size(), 0)


func test_loading_no_dictionary():
	card_db.set_json_file_path("res://card_system/tests/card_db_array_test.json")
	watch_signals(card_db)
	var data = card_db.load()
	assert_signal_emitted(card_db, "json_file_not_dictionary")
	assert_eq(data.size(), 0)


func test_loading_proper_dictionary():
	card_db.set_json_file_path("res://card_system/tests/card_db_test.json")
	watch_signals(card_db)
	var data = card_db.load()
	assert_eq(data.card01.name, "card name 1")
	