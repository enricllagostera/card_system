extends "res://addons/gut/test.gd"

var TabletopScript = preload("res://tabletop.gd")
var tabletop

func before_each():
	tabletop = TabletopScript.new()
	autofree(tabletop)


func test_init():
	assert_true(tabletop.is_empty())
	assert_accessors(tabletop, "capacity", -1, 1)


func test_add_to_capacity():
	var c1 = Card.new()
	var c2 = Card.new()
	autofree(c1)
	autofree(c2)
	assert_has_method(tabletop, "add")
	tabletop.add(c1)
	assert_eq(tabletop.peek_last(), c1)
	tabletop.add(c2)
	assert_eq(tabletop.count(), 2)


func test_add_over_capacity():
	var c1 = Card.new()
	var c2 = Card.new()
	autofree(c1)
	autofree(c2)
	tabletop.set_capacity(1)
	tabletop.add(c1)
	tabletop.add(c2)
	assert_eq(tabletop.peek_last(), c1)
	assert_eq(tabletop.count(), 1)


func test_find_by_id():
	var c1 = Card.new()
	autofree(c1)
	assert_has_method(tabletop, "find_by_id")
	assert_null(tabletop.find_by_id(c1.card_id))
	tabletop.add(c1)
	assert_eq(tabletop.find_by_id(c1.card_id), c1)


func test_remove_card():
	var c1 = Card.new()
	autofree(c1)
	assert_has_method(tabletop, "remove")
	assert_null(tabletop.remove(c1))
	tabletop.add(c1)
	var res = tabletop.remove(c1)
	print(str(res))
	assert_eq(res, c1)
	assert_eq(tabletop.count(), 0)
