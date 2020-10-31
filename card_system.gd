extends Control


export(int) var holder_count = 3
export(PackedScene) var holder_prefab
export (PackedScene) var card_prefab


var _holders := []
var _hand := []


func _ready():
	var holder_distance_x = rect_size.x / holder_count
	for i in range(0, holder_count):
		var new_holder = holder_prefab.instance()
		add_child(new_holder)
		var offset_x = (holder_distance_x - new_holder.rect_size.x) /2
		new_holder.rect_position = Vector2(i * holder_distance_x + offset_x, 0)
		new_holder.connect("mouse_entered", self, "_on_holder_mouse_entered", [new_holder]
		)
		new_holder.connect("mouse_exited", self, "_on_holder_mouse_exited", [new_holder])
		_holders.append(new_holder)


func add_card():
	var empty_card_index = _find_empty_holder()
	if empty_card_index < 0:
		return
	
	var new_card = card_prefab.instance() as Card
	new_card.id = OS.get_unique_id()
	_hand.append(new_card)
	_holders[empty_card_index].card = new_card
	add_child(new_card) 


func remove_card_at(index):
	if index < 0 or index > _hand.size():
		return
	
	var removed_card = _hand[index]
	_hand.remove(index)
	_holders[index].card = null
	remove_child(removed_card)


func _find_empty_holder() -> int:
	for i in range(_holders.size()):
		if _holders[i].card == null:
			return i
	return -1


func _on_holder_mouse_entered(holder):
	holder.rect_position.y -= 10


func _on_holder_mouse_exited(holder):
	holder.rect_position.y = 0


func _on_AddCardButton_button_down():
	add_card()


func _on_RemoveCardButton_button_down():
	remove_card_at(_hand.size()-1)
