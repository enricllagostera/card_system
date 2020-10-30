extends Control

export(int) var slot_number = 3
export(PackedScene) var slot_prefab

var slot_size = Vector2()

func _ready():
	var distance_slots_x = rect_size.x / slot_number
	for i in range(0, slot_number):
		var new_slot = slot_prefab.instance()
		add_child(new_slot)
		var offset_x = (distance_slots_x - new_slot.rect_size.x) /2
		new_slot.rect_position = Vector2(i * distance_slots_x + offset_x, 0)
		new_slot.connect("mouse_entered", self, "on_slot_mouse_entered", [new_slot]
		)
		new_slot.connect("mouse_exited", self, "on_slot_mouse_exited", [new_slot])
	pass

func on_slot_mouse_entered(slot):
	slot.rect_position.y -= 10
	pass

func on_slot_mouse_exited(slot):
	slot.rect_position.y = 0
	pass
