extends "res://addons/gut/test.gd"

var CardFromJSON = load("res://card_system/card_from_json.tscn")
var card

func before_each():
	card = CardFromJSON.instance()
	add_child_autofree(card)


func test_init():	
	watch_signals(card)
	card.set_json_file_path("res://card_system/tests/card_data.json")


func test_set_json_file_path():
	watch_signals(card)
	card.set_json_file_path("res://card_system/tests/random_filename.json")
	assert_signal_emitted(card, "json_file_path_invalid")
	clear_signal_watcher()
	watch_signals(card)
	card.set_json_file_path("res://card_system/tests/card_data.json")
	assert_signal_not_emitted(card, "json_file_path_invalid")


func test_load_from_file_invalid():
	watch_signals(card)
	card._load_text_from_file()
	assert_file_does_not_exist(card.json_file_path)
	assert_signal_emitted(card, "json_file_path_invalid")

func test_load_from_file_valid():
	card.set_json_file_path("res://card_system/tests/card_data.json")
	card._load_text_from_file()
	card._update_gui()
	assert_eq(card._text, "test_text")
	assert_eq(card.get_node("DataLabel").text, "test_text")
