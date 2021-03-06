extends Control

class_name Card

const INTERACTION_ROTATION_RANGE := 8.0

var _is_grabbing
var _cursor_over
var _grabbed_offset

var container = null

var uuid_util = preload("res://card_system/uuid/uuid.gd")

var card_id = "" setget set_card_id, get_card_id

signal card_picked
signal card_dropped


func _init():
	set_card_id()
	rect_pivot_offset = rect_size / 2
	_cursor_over = false


func _ready():
	$Visual.rect_pivot_offset = self.rect_size / 2
	_connect_sensor()
	$AnimationPlayer.play("idle")
	$Sensor.position = self.rect_pivot_offset
	$"Sensor/CollisionShape2D".shape.extents = rect_size * 0.5


func _connect_sensor():
	var _aux = $Sensor.connect("area_entered", self, "_on_card_entered_area")
	_aux = $Sensor.connect("area_exited", self, "_on_card_exited_area")


func _gui_input(event):
	if event is InputEventMouseButton and _cursor_over:
		_is_grabbing = event.pressed
		if event.pressed:
			_grabbed_offset = rect_position - get_global_mouse_position()
			_rotate_on_interaction()
			emit_signal("card_picked", self)
	if event is InputEventMouseButton:
		if not event.pressed:
			_rotate_on_interaction()
			emit_signal("card_dropped", self)	


func _rotate_on_interaction():
	set_rotation(deg2rad (rand_range(-INTERACTION_ROTATION_RANGE, INTERACTION_ROTATION_RANGE)))


func _process(_delta):
	$Visual.rect_scale = Vector2.ONE * 1.05 if _cursor_over else Vector2.ONE	
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and _is_grabbing:
		rect_position = get_global_mouse_position() + _grabbed_offset


func _notification(what):
	if what == NOTIFICATION_MOUSE_ENTER:
		_mouse_entered()
	if what == NOTIFICATION_MOUSE_EXIT:
		_mouse_exited()


func _mouse_entered():
	_cursor_over = true
	get_parent().move_child(self, get_parent().get_child_count()-1)
	$AnimationPlayer.play("hover")


func _mouse_exited():
	_cursor_over = false
	$AnimationPlayer.play("idle")


func _on_card_entered_area(area):
	if area is HolderArea:
		area.holder.on_card_entered(self)


func _on_card_exited_area(area):
	if area is HolderArea:
		area.holder.on_card_exited(self)
	

func set_card_id(new_id = ""):
	if new_id == "":
		card_id = uuid_util.v4()
		return
	card_id = new_id


func get_card_id():
	return card_id


func move_to(position, duration):
	$Tween.interpolate_property(self, "rect_position", rect_position, position, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()


func move_to_with_callback(position, duration, object = null, callback = ""):
	move_to(position, duration)
	if object != null and callback != "":
		$Tween.interpolate_callback(object, duration, callback)


func overlaps(holder) -> bool:
	return $Sensor.overlaps_area (holder.get_sensor())

func stop_animations():
	$Tween.stop_all()