extends Node2D

class_name Workshop

export(int) var tabletop_capacity := 2

var FloppyScene = preload("res://floppy.tscn")

onready var deck :Deck = $Deck
onready var discard_deck :Deck = $DiscardDeck
onready var card_db :CardDb = $CardDb
onready var tabletop = $Tabletop


func _init():
	pass


func _ready():
	var initial_data = card_db.load()
	for card_id in initial_data.keys():
		var new_floppy = FloppyScene.instance()
		new_floppy.set_label(initial_data[card_id].label)
		deck.add_card(new_floppy)
	

func fill_tabletop():
	var diskettes_needed = tabletop_capacity - $Tabletop.get_child_count()
	for _i in range(0, diskettes_needed):
		tabletop.add_child(deck.deal_card())


func _on_DealTurnButton_button_up():
	print("Deal turn!")
	fill_tabletop()
