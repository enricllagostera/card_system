extends "res://addons/gut/test.gd"

var container :CardContainer


func before_each():
	container = CardContainer.new()


func test_init():
	assert_eq(container.capacity, CardContainer.UNLIMITED_CAPACITY)
	assert_accessors(container, "capacity", CardContainer.UNLIMITED_CAPACITY, 1)


func test_adding_cards_to_capacity():
	container.set_capacity(2)
	var c1 = Card.new()
	var c2 = Card.new()

	watch_signals(container)
	container.add(c1)
	container.add(c2)
	autofree(c1)
	autofree(c2)

	assert_signal_not_emitted(container, "added_card_already_in_container")
	assert_eq(container.count(), 2)


func test_adding_card_over_capacity():
	container.set_capacity(1)
	var c1 = Card.new()
	var c2 = Card.new()

	watch_signals(container)
	container.add(c1)
	container.add(c2)
	autofree(c1)
	autofree(c2)

	assert_signal_emitted(container, "added_card_over_capacity")
	assert_eq(container.count(), 1)


func test_remove_top_card_from_empty_container():
	watch_signals(container)
	var removed = container.remove_last()
	assert_eq(container.count(), 0)
	assert_null(removed)
	assert_signal_emitted(container, "removed_card_container_was_empty")



func test_remove_top_card_from_container():
	watch_signals(container)
	var c1 = Card.new()
	var c2 = Card.new()
	container.add(c1)
	container.add(c2)
	autofree(c1)
	autofree(c2)
	var removed = container.remove_last()
	assert_eq(container.count(), 1)
	assert_not_null(removed)
	


func test_remove_card_by_id():
	watch_signals(container)
	var c1 = Card.new()
	container.add(c1)
	autofree(c1)

	var id = c1.get_id()
	var removed = container.remove(id)
	assert_eq(container.count(), 0)
	assert_not_null(removed)
	removed = container.remove(id)
	assert_signal_emitted(container, "removed_card_id_not_found")
	assert_null(removed)
