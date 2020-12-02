extends Control

class_name Holder

var _cards = []

export(int) var capacity = 1
export(bool) var snap_on_drop = true
export(float) var snap_duration := 0.1

signal card_added
signal card_entered
signal card_exited
signal card_placed
signal card_removed


func _init():
	rect_pivot_offset = rect_size / 2
	_cards = []
	
	
func _ready():
	$Sensor.holder = self
	$Sensor.position = rect_pivot_offset
	$Visual.rect_position = Vector2.ZERO
	$Visual.rect_pivot_offset = rect_pivot_offset
	$"Sensor/CollisionShape2D".shape.extents = rect_size * 0.5


func _highlight_top_card():
	if _cards.size() == 0:
		return
	for card in _cards:
		card.mouse_filter = MOUSE_FILTER_IGNORE
		card.modulate = Color.black
	_cards.back().modulate = Color.white
	_cards.back().mouse_filter = MOUSE_FILTER_STOP

	
func _continue_flip(object, _key):
	object.modulate = Color.white
	object.mouse_filter = MOUSE_FILTER_STOP
	var _aux = $Tween.interpolate_property(object, "rect_scale", null, Vector2(1, 1), 0.1, Tween.TRANS_SINE)
	$Tween.disconnect("tween_completed", self, "_continue_flip")


func _snap(card):
	if snap_on_drop:
		var target = self.rect_global_position + self.rect_pivot_offset - card.rect_size / 2
		$Tween.interpolate_property(card, "rect_global_position", card.rect_global_position, target, snap_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
			

func _add_card(card):
	_cards.append(card)
	_snap(card)
	_highlight_top_card()
	emit_signal("card_added")


func on_card_entered(card):
	if not has_card(card):
		card.connect("card_dropped", self, "_on_card_dropped")
	emit_signal("card_entered")


func on_card_exited(card):
	if not has_card(card) and card.is_connected("card_dropped", self, "_on_card_dropped") :
		card.disconnect("card_dropped", self, "_on_card_dropped")
	emit_signal("card_exited")


func on_card_removed(card):
	remove(card)
	

func _on_card_dropped(card):
	emit_signal("card_placed")
	if not has_card(card) and _cards.size() + 1 <= capacity:
		_add_card(card)
		return
	if has_card(card):
		if card.overlaps(self):
			_snap(card)
			_highlight_top_card()
			return
		on_card_removed(card)
	
	
func get_sensor():
	return $Sensor


func has_card(card):
	return _cards.has(card)


func remove(card):
	card.disconnect("card_dropped", self, "_on_card_dropped")
	if _cards.size() > 0 and card == _cards.back():
		_cards.pop_back()
	_highlight_top_card()
	card.modulate = Color.white
	emit_signal("card_removed", card)


func peek_top():
	if _cards.size() > 0:
		return _cards.back()
	return null


func remove_from_top():
	if card_count() > 0:
		var card = _cards.back()
		remove(_cards.back())
		return card
	return null


func card_count():
	return _cards.size()
