extends Control

class_name DraggableCard

var is_grabbing
var cursor_over
var grabbed_offset


func _gui_input(event):
	if event is InputEventMouseButton and cursor_over:
		is_grabbing = event.pressed
		grabbed_offset = rect_position - get_global_mouse_position()
		get_tree().set_input_as_handled()


func _process(delta):
	$Visual.rect_scale = Vector2.ONE * 1.05 if cursor_over else Vector2.ONE	
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and is_grabbing:
		rect_position = get_global_mouse_position() + grabbed_offset
	pass


func _ready():
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	$AnimationPlayer.play("idle")

func _on_mouse_entered():
	cursor_over = true
	get_parent().move_child(self, get_parent().get_child_count()-1)
	$AnimationPlayer.play("hover")


func _on_mouse_exited():
	cursor_over = false
	$AnimationPlayer.play("idle")
