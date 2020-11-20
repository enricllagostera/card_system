extends Control

class_name Card

const INTERACTION_ROTATION_RANGE := 8.0

var _is_grabbing
var _cursor_over
var _grabbed_offset

signal card_picked
signal card_dropped


func _gui_input(event):
	if event is InputEventMouseButton and _cursor_over:
		_is_grabbing = event.pressed
		if event.pressed:
			_grabbed_offset = rect_position - get_global_mouse_position()
			print("pick")
			_rotate_on_interaction()
			emit_signal("card_picked", self)
	if event is InputEventMouseButton:
		if not event.pressed:
			print("drop")			
			_rotate_on_interaction()
			emit_signal("card_dropped", self)	


func _rotate_on_interaction():
	set_rotation(deg2rad (rand_range(-INTERACTION_ROTATION_RANGE, INTERACTION_ROTATION_RANGE)))


func _process(_delta):
	$Visual.rect_scale = Vector2.ONE * 1.05 if _cursor_over else Vector2.ONE	
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and _is_grabbing:
		rect_position = get_global_mouse_position() + _grabbed_offset


func _init():
	rect_pivot_offset = rect_size / 2
	_cursor_over = false
	connect("mouse_entered", self, "mouse_entered")
	connect("mouse_exited", self, "mouse_exited")


func _ready():
	$Visual.rect_pivot_offset = self.rect_size / 2
	_connect_sensor()
	$AnimationPlayer.play("idle")


func _connect_sensor():
	$Sensor.connect("area_entered", self, "_on_card_entered_area")
	$Sensor.connect("area_exited", self, "_on_card_exited_area")


func mouse_entered():
	_cursor_over = true
	get_parent().move_child(self, get_parent().get_child_count()-1)
	$AnimationPlayer.play("hover")


func mouse_exited():
	_cursor_over = false
	$AnimationPlayer.play("idle")


func _on_card_entered_area(area):
	if area is HolderArea:
		area.holder.on_card_entered(self)


func _on_card_exited_area(area):
	if area is HolderArea:
		area.holder.on_card_exited(self)
	

func overlaps(holder) -> bool:
	return $Sensor.overlaps_area (holder.get_sensor())