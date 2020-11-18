extends Area2D

class_name Holder

var _is_hover = false

export(bool) var snap_on_drop = true

signal card_entered
signal card_exited
signal card_dropped


func _ready():
	connect("card_entered", self, "_on_card_entered")
	connect("card_exited", self, "_on_card_exited")
	_is_hover = false


func _process(delta):
#	print (_is_hover)
	if _is_hover:
		$Visual.modulate = Color.rebeccapurple
	else:
		$Visual.modulate = Color.green


func _on_card_entered(card_area):
#	print("card entered holder 2: ")
#	print(card_area)
	_is_hover = true


func _on_card_exited(card_area):
#	print("card exited holder: ")
#	print(card_area)
	_is_hover = false
	

func _on_card_dropped(card):
	emit_signal("card_dropped")
	print("dropped card: ", card)
	if snap_on_drop:
		$Tween.interpolate_property(card, "rect_position", card.rect_position, self.position - card.rect_pivot_offset, 0.1, Tween.TRANS_SINE)
		card.set_rotation(deg2rad (rand_range(-5.0, 5.0)))
		$Tween.start()


func _on_Holder_card_dropped():
	pass # Replace with function body.
