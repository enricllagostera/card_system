extends Node2D

class_name Workshop

var turns := 0
export(int) var tabletop_capacity := 2

var FloppyScene = preload("res://floppy.tscn")

onready var deck :Deck = $Deck
onready var discard_deck :Deck = $DiscardDeck
onready var card_db :CardDb = $CardDb
onready var tabletop = $Tabletop


func _ready():
	tabletop.capacity = tabletop_capacity
	var initial_data = card_db.load()
	for card_id in initial_data.keys():
		var new_floppy = add_new_floppy(initial_data[card_id])
		deck.add(new_floppy)
	# Driver connections
	for h in $Holders.get_children():
		var _c = h.connect("card_placed", self, "_on_driver_card_placed", [h])
		_c = h.connect("card_removed", self, "_on_driver_card_removed", [h])
	fill_tabletop()


func add_new_floppy(data):
	var new_floppy = FloppyScene.instance()
	add_child(new_floppy)
	new_floppy.data = data
	new_floppy.set_label(data.label)
	new_floppy.visible = false
	new_floppy.rect_global_position = Vector2(0,0)
	return new_floppy


func fill_tabletop():
	var diskettes_needed = tabletop_capacity - tabletop.count()
	for _i in range(0, diskettes_needed):
		if deck.count() == 0:
			_refill_player_deck()
		if deck.count() > 0:
			var c = deck.peek_last()
			c.stop_animations()
			c.rect_global_position = Vector2(0,0)
			c.visible = true
			CardContainer.switch(c, deck, tabletop)


func _on_DealTurnButton_button_up():
	print("Deal turn!")
	fill_tabletop()


func _on_EndTurnButton_button_up():
	print("end turn btn")
	turns += 1
	for h in $Holders.get_children():
		if (h as Holder).count() > 0:
			var res = h.run()
			for c in res:
				if c is Floppy:
					CardContainer.switch(c, h, discard_deck)
				else:
					var new_floppy = add_new_floppy(c.data)
					discard_deck.add(new_floppy)
	fill_tabletop()


func _refill_player_deck():
	for i in discard_deck.count():
		CardContainer.switch(discard_deck.peek_last(), discard_deck, deck)
	deck.random_shuffle()


func _on_driver_card_placed(card, driver):
	CardContainer.switch(card, card.container, driver)


func _on_driver_card_removed(card, driver):
	CardContainer.switch(card, driver, tabletop)
