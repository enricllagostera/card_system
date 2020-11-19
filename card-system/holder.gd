extends Control


class_name Holder


var _is_hover = false
var _is_on_holder = false
var _cards = []


export(int) var capacity = 1
export(bool) var snap_on_drop = true


signal card_added
signal card_entered
signal card_exited
signal card_removed


func _ready():
	rect_pivot_offset = rect_size / 2
	$Sensor.holder = self
	$Sensor.position = rect_pivot_offset
	$Visual.rect_pivot_offset = rect_pivot_offset
	_is_hover = false
	connect("card_entered", self, "_on_card_entered")
	connect("card_exited", self, "_on_card_exited")
	connect("card_removed", self, "_on_card_removed")


func _highlight_top_card():
	if _cards.size() == 0:
		return
	for card in _cards:
		card.mouse_filter = MOUSE_FILTER_IGNORE
		card.modulate = Color.black
	_cards.back().modulate = Color.white
	_cards.back().mouse_filter = MOUSE_FILTER_STOP


func _snap(card):
	if snap_on_drop:
		$Tween.interpolate_property(card, "rect_position", card.rect_position, self.rect_global_position, 0.1, Tween.TRANS_SINE)
		$Tween.start()
			

func _add_card(card):
	_cards.append(card)
	_snap(card)
	_highlight_top_card()
	print("added card: ", card)
	emit_signal("card_added")


func _on_card_entered(card):
	if not has_card(card):
		card.connect("card_dropped", self, "_on_card_dropped")

func _on_card_exited(card):
	if not has_card(card):
		card.disconnect("card_dropped", self, "_on_card_dropped")


func _on_card_removed(card):
	card.disconnect("card_dropped", self, "_on_card_dropped")
	print("card removed: ", str(card))
	if _cards.size() > 0 and card == _cards.back():
		_cards.pop_back()
	card.modulate = Color.white
	_highlight_top_card()
	

func _on_card_dropped(card):
	print("card dropped: ", str(card))

	if not has_card(card) and _cards.size() + 1 <= capacity:
		_add_card(card)
		return

	if has_card(card):
		if card.overlaps(self):
			print("card already on holder: ", str(card))
			_snap(card)
			_highlight_top_card()
			return
		emit_signal("card_removed", card)
		return;		
	
	
func get_sensor():
	return $Sensor


func has_card(card):
	return _cards.has(card)
