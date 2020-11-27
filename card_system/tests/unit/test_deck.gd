extends "res://addons/gut/test.gd"

var DeckScript = load("res://card_system/deck.gd")
var CardScript = load("res://card_system/card.gd")
var deck
var card


func before_each():
	deck = DeckScript.new()
	add_child_autofree(deck)
	card = double(CardScript).new()
	watch_signals(deck)


func test_init():
	assert_eq(deck.card_count(), 0, "Start with a deck without cards.")


func test_add_card():
	deck.add_card(card)
	assert_eq(deck.card_count(), 1, "Add one card to the deck.")
	assert_signal_emitted(deck, "card_added")


func test_add_card_no_duplicates():
	deck.set_capacity(deck.UNLIMITED_CAPACITY)
	deck.add_card(card)
	deck.add_card(card)
	assert_eq(deck.card_count(), 1, "A card instance cannot be added twice to a deck.")
	assert_signal_emitted(deck, "card_added_fail_no_duplicates")


func test_add_card_over_capacity():
	card = double(CardScript).new()
	deck.set_capacity(1)
	deck.add_card(card)
	var card2 = double(CardScript).new()
	deck.add_card(card2)
	assert_signal_emitted(deck, "card_added_fail_overcapacity")
	assert_eq(deck.card_count(), 1)


func test_capacity_setup():
	assert_accessors(deck, "capacity", deck.UNLIMITED_CAPACITY, 1)


func test_deal_card_single():
	deck.add_card(card)
	var dealt = deck.deal_card()
	assert_signal_emitted(deck, "card_dealt")
	assert_eq(deck.card_count(), 0)
	assert_not_null(dealt)


func test_deal_card_empty_deck():
	var dealt = deck.deal_card()
	assert_signal_emitted(deck, "card_dealt_fail_empty")
	assert_null(dealt)
	assert_eq(deck.card_count(), 0)


func test_random_shuffle():
	for _i in range(0, 52):
		deck.add_card(double(CardScript).new())
	var deck_order = get_deck_order(deck._cards)
	deck.random_shuffle()
	var deck_order_2 = get_deck_order(deck._cards)
	assert_false(compare_deck_order(deck_order, deck_order_2), "Order should always be different after shuffle.")
	assert_signal_emitted(deck, "deck_shuffled")


func test_peek_card():
	assert_null(deck.peek_card())
	deck.add_card(card)
	assert_eq(deck.peek_card(), card)


func get_deck_order(cards):
	var deck_new_order = []
	for c in cards:
		deck_new_order.append(c)
	return deck_new_order


func compare_deck_order(order1, order2):
	for index in range(0, order1.size()):
		if order2[index] != order1[index]:
			return false
	return true


func test_shuffle_repeatable():
	for _i in range(0, 52):
		deck.add_card(double(CardScript).new())
	var backup_deck = deck._cards.duplicate() 
	deck.repeatable_shuffle(1000)
	var deck_order = get_deck_order(deck._cards)
	deck._cards = backup_deck
	deck.repeatable_shuffle(1000)
	var deck_order_2 = get_deck_order(deck._cards)
	assert_true(compare_deck_order(deck_order, deck_order_2), "Shuffles with same seed must create the same ordering.")
	assert_signal_emitted(deck, "deck_shuffled")