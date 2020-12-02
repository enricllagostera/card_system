extends "res://driver.gd"

var card = null

func run():
	var result = []
	print("run ", name, " logic")
	card = remove_from_top()
	card.move_to_with_callback(card.rect_position+Vector2(0, -1000),0.5,self,"clean_up")
	return result

func clean_up():
	card.free()
	pass
