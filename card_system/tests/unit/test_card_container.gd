extends "res://addons/gut/test.gd"

var container :CardContainer


func before_each():
	container = CardContainer.new()
	autofree(container)


func test_init():
	assert_eq(container.capacity, CardContainer.UNLIMITED_CAPACITY)
	assert_accessors(container, "capacity", CardContainer.UNLIMITED_CAPACITY, 1)


func test_adding_cards_to_capacity():
	container.set_capacity(2)
	var c1 = Card.new()
	var c2 = Card.new()
	autofree(c1)
	autofree(c2)
	watch_signals(container)
	container.add(c1)
	container.add(c2)
	assert_signal_not_emitted(container, "card_added_already_in_container")
	assert_eq(container.count(), 2)


func test_adding_card_over_capacity():
	container.set_capacity(1)
	var c1 = Card.new()
	var c2 = Card.new()
	autofree(c1)
	autofree(c2)
	watch_signals(container)
	container.add(c1)
	container.add(c2)
	assert_signal_emitted(container, "card_added_over_capacity")
	assert_eq(container.count(), 1)


func test_remove_last_card_from_empty_container():
	watch_signals(container)
	var removed = container.remove_last()
	assert_eq(container.count(), 0)
	assert_null(removed)
	assert_signal_emitted(container, "card_removed_container_was_empty")


func test_remove_last_card_from_container():
	var c1 = Card.new()
	var c2 = Card.new()
	autofree(c1)
	autofree(c2)
	watch_signals(container)
	container.add(c1)
	container.add(c2)
	var removed = container.remove_last()
	assert_eq(container.count(), 1)
	assert_not_null(removed)


func test_remove_card_by_id():
	var c1 = Card.new()
	container.add(c1)
	autofree(c1)

	watch_signals(container)
	var card_id = c1.card_id
	var removed = container.remove_by_id(card_id)
	assert_eq(container.count(), 0)
	assert_not_null(removed)
	removed = container.remove_by_id(card_id)
	assert_signal_emitted(container, "card_removed_id_not_found")
	assert_null(removed)


func test_remove_card():
	var c1 = Card.new()
	container.add(c1)
	autofree(c1)

	watch_signals(container)
	var removed = container.remove(c1)
	assert_eq(container.count(), 0)
	assert_not_null(removed)
	removed = container.remove(c1)
	assert_signal_emitted(container, "card_removed_id_not_found")
	assert_null(removed)


func test_find_index_by_id():
	assert_eq(container.find_index_by_id(""), -1)
	var c1 = Card.new()
	container.add(c1)
	autofree(c1)
	assert_eq(container.find_index_by_id(c1.card_id), 0)
	assert_eq(container.find_by_id(c1.card_id), c1)
	assert_null(container.find_by_id(""))


func test_peek_last():
	assert_null(container.peek_last(), "Peek on empty returns null.")
	var c1 = Card.new()
	container.add(c1)
	autofree(c1)
	assert_eq(container.peek_last(), c1, "Peek returns reference to last card added.")


func test_switch():
	var container2 = CardContainer.new()
	autofree(container2)
	var c1 = Card.new()
	autofree(c1)
	
	assert_has_method(container, "switch")
	CardContainer.switch(c1, container, container2)
	assert_false(container.has(c1.card_id))
	assert_false(container2.has(c1.card_id))

	container.add(c1)
	CardContainer.switch(c1, container, container2)
	assert_false(container.has(c1.card_id))
	assert_true(container2.has(c1.card_id))
	
