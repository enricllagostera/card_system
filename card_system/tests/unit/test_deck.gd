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


func test_add_card_over_capacity():
	card = double(CardScript).new()
	deck.set_capacity(1)
	deck.add_card(card)
	deck.add_card(card)
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
