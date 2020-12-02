extends "res://addons/gut/test.gd"

var Wksp = load("res://workshop.tscn")
var Floppy = load("res://floppy.gd")
var wksp


func before_each():
	wksp = Wksp.instance()
	add_child_autofree(wksp)


func test_new_workshop():
	# assert_eq(wksp.card_db.json_file_path, "res://all_diskettes_01.json")
	assert_is(wksp, Workshop)
	assert_not_null(wksp.deck)
	assert_not_null(wksp.discard_deck)
	assert_not_null(wksp.card_db)


func test_loaded_floppies():
	assert_gt((wksp as Workshop).deck.count(), 0)
	assert_is(wksp.deck.peek_top(), Floppy)
	assert_eq(wksp.deck.peek_top().get_label(), "floppy 04")


func test_fill_tabletop():
	var count = wksp.deck.count()
	wksp.fill_tabletop()
	assert_gt(wksp.tabletop.get_child_count(), 0)
	assert_eq(wksp.deck.count(), count - 2)