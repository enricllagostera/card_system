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
	var initial_data = card_db.load()
	for card_id in initial_data.keys():
		var new_floppy = FloppyScene.instance()
		new_floppy.set_label(initial_data[card_id].label)
		deck.add(new_floppy)
	

func fill_tabletop():
	var diskettes_needed = tabletop_capacity - $Tabletop.get_child_count()
	for _i in range(0, diskettes_needed):
		if deck.card_count() == 0:
			_refill_player_deck()
		if deck.card_count() > 0:
			var c = deck.deal_card()
			c.rect_position = Vector2(0,0)
			tabletop.add_child(c)
			

func _on_DealTurnButton_button_up():
	print("Deal turn!")
	fill_tabletop()


func _on_EndTurnButton_button_up():
	print("end turn btn")
	turns += 1
	for h in $Holders.get_children():
		if (h as Holder).card_count() > 0:
			var res = h.run()
			for c in res:
				discard_deck.add_card(c)	


func _on_floppy_discarded(card, _key):
	tabletop.remove_child(card)


func _refill_player_deck():
	print("refilling deck")
	for i in discard_deck.card_count():
		var card = discard_deck.deal_card()
		deck.add_card(card)
	deck.random_shuffle()
