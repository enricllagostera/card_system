extends Control


class_name DraggableCard


var is_grabbing
var cursor_over
var grabbed_offset


signal card_picked
signal card_dropped


func _gui_input(event):
	if event is InputEventMouseButton and cursor_over:
		is_grabbing = event.pressed
		if event.pressed:
			grabbed_offset = rect_position - get_global_mouse_position()
			print("pick")
			emit_signal("card_picked")
	if event is InputEventMouseButton:
		if not event.pressed:
			print("drop")			
			emit_signal("card_dropped")	


func _process(delta):
	$Visual.rect_scale = Vector2.ONE * 1.05 if cursor_over else Vector2.ONE	
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and is_grabbing:
		rect_position = get_global_mouse_position() + grabbed_offset


func _ready():
	rect_pivot_offset = rect_size / 2
	$Visual.rect_pivot_offset = rect_size / 2
	$Sensor.position = rect_pivot_offset
	$Sensor
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	$Sensor.connect("area_entered", self, "_on_card_entered_area")
	$Sensor.connect("area_exited", self, "_on_card_exited_area")
	$AnimationPlayer.play("idle")


func _on_mouse_entered():
	cursor_over = true
	get_parent().move_child(self, get_parent().get_child_count()-1)
	$AnimationPlayer.play("hover")


func _on_mouse_exited():
	cursor_over = false
	$AnimationPlayer.play("idle")


func _on_card_entered_area(area):
	if area is HolderArea:
		area.holder.emit_signal("card_entered", self)
		self.connect("card_dropped", area.holder, "_on_card_dropped", [self])
		print("card entered holder")


func _on_card_exited_area(area):
	if area is HolderArea:
		area.holder.emit_signal("card_exited", self)		
		self.disconnect("card_dropped", area.holder, "_on_card_dropped")
		print("card exited holder")
		
