extends Node2D


var CardScene = load("res://card-system/card.tscn")


func _ready():
	$Deck.connect("card_dealt", self, "_on_card_dealt")


func _on_DealButton_button_up():
	print("deal")
	$Deck.deal_card()


func _on_AddButton_button_up():
	$Deck.add_card(CardScene.instance())


func _on_card_dealt(card):
	add_child(card)
	$Tween.interpolate_property(card, "rect_position", Vector2(400, -400), Vector2(rand_range(200, 600), 350), 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.start()
