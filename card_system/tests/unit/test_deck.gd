extends "res://addons/gut/test.gd"

var deck
var card


func before_each():
	deck = Deck.new()
	add_child_autofree(deck)
	card = Card.new()
	autofree(card)
	watch_signals(deck)


func test_init():
	assert_eq(deck.count(), 0, "Start with a deck without cards.")


func test_add_card():
	deck.add(card)
	assert_eq(deck.count(), 1, "Add one card to the deck.")


func test_add_card_no_duplicates():
	deck.set_capacity(deck.UNLIMITED_CAPACITY)
	deck.add(card)
	deck.add(card)
	assert_eq(deck.count(), 1, "A card instance cannot be added twice to a deck.")


func test_add_card_over_capacity():
	card = double(Card).new()
	deck.set_capacity(1)
	deck.add(card)
	var card2 = double(Card).new()
	deck.add(card2)
	assert_eq(deck.count(), 1)


func test_capacity_setup():
	assert_accessors(deck, "capacity", deck.UNLIMITED_CAPACITY, 1)


func test_random_shuffle():
	var deck2 = Deck.new()
	autofree(deck2)
	for _i in range(0, 52):
		var c = Card.new()
		autofree(c)
		deck.add(c)
		deck2.add(c)
	deck.random_shuffle()
	deck2.random_shuffle()
	assert_false(compare_deck_order(deck.get_ids(), deck2.get_ids()), "Order should always be different after shuffle.")
	assert_signal_emitted(deck, "deck_shuffled")


func test_peek_top():
	assert_null(deck.peek_last())
	deck.add(card)
	assert_eq(deck.peek_last(), card)


func compare_deck_order(order1, order2):
	for index in range(0, order1.size()):
		if order2[index] != order1[index]:
			return false
	return true


func test_shuffle_repeatable():
	var deck2 = Deck.new()
	autofree(deck2)
	for _i in range(0, 52):
		var c = double(Card).new()
		deck.add(c)
		deck2.add(c)
	deck.repeatable_shuffle(1000)
	deck2.repeatable_shuffle(1000)
	assert_true(compare_deck_order(deck.get_ids(), deck2.get_ids()), "Shuffles with same seed must create the same ordering.")
	assert_signal_emitted(deck, "deck_shuffled")