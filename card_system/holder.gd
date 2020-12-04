extends CardContainer

class_name Holder

export(bool) var snap_on_drop = true
export(float) var snap_duration := 0.1

signal card_entered
signal card_exited
signal card_placed


func _ready():
	rect_pivot_offset = rect_size / 2
	$Sensor.holder = self
	$Sensor.position = rect_pivot_offset
	$Visual.rect_position = Vector2.ZERO
	$Visual.rect_pivot_offset = rect_pivot_offset
	$"Sensor/CollisionShape2D".shape.extents = rect_size * 0.5


func _highlight_top_card():
	if count() == 0:
		return
	for c in _cards:
		c.mouse_filter = MOUSE_FILTER_IGNORE
		c.modulate = Color.black
	peek_last().modulate = Color.white
	peek_last().mouse_filter = MOUSE_FILTER_STOP

	
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


func on_card_entered(card):
	if not has_card(card):
		card.connect("card_dropped", self, "_on_card_dropped")
	emit_signal("card_entered")


func on_card_exited(card):
	if not has_card(card) and card.is_connected("card_dropped", self, "_on_card_dropped") :
		card.disconnect("card_dropped", self, "_on_card_dropped")
	emit_signal("card_exited")
	

func _on_card_dropped(card):
	if not has_card(card) and has_available_capacity(1):
		emit_signal("card_placed", card)
	if has_card(card):
		if card.overlaps(self):
			_snap(card)
			_highlight_top_card()
		else:
			emit_signal("card_removed", card)
	

func get_sensor():
	return $Sensor


func add(card):
	.add(card)


func remove(card):
	if card.is_connected("card_dropped", self, "_on_card_dropped"):
		card.disconnect("card_dropped", self, "_on_card_dropped")
	.remove(card)
	_highlight_top_card()
	card.modulate = Color.white

