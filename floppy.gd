extends Card

class_name Floppy

var _label := "" setget set_label, get_label


func set_label(new_label):
	_label = new_label


func get_label():
	return _label