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
		var new_floppy = FloppyScene.instance()
		add_child(new_floppy)
		new_floppy.set_label(initial_data[card_id].label)
		new_floppy.visible = false
		deck.add(new_floppy)
	

func fill_tabletop():
	var diskettes_needed = tabletop_capacity - tabletop.count()
	for _i in range(0, diskettes_needed):
		if deck.count() == 0:
			_refill_player_deck()
		if deck.count() > 0:
			var c = deck.deal()
			c.rect_position = Vector2(0,0)
			c.visible = true
			tabletop.add(c)


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
				discard_deck.add(c)


func _on_floppy_discarded(card, _key):
	card.visible = false


func _refill_player_deck():
	print("refilling deck")
	for i in discard_deck.count():
		var card = discard_deck.deal()
		deck.add(card)
	deck.random_shuffle()



func _on_drivers_card_removed(card):
	if not discard_deck.has(card):
		tabletop.add(card)


func _on_drivers_card_added(card):
	tabletop.remove(card)
