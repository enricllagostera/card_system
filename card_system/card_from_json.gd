extends "res://card_system/card.gd"

class_name CardFromJSON

var _text := ""

export(String, FILE) var json_file_path = "" setget set_json_file_path

signal json_file_path_invalid


func _ready():
	_load_text_from_file()


func _update_gui():
	$DataLabel.text = _text;


func _load_text_from_file():
	var file = File.new()
	if not file.file_exists(json_file_path):
		emit_signal("json_file_path_invalid")
		return
	file.open(json_file_path, File.READ)
	var raw = file.get_as_text()
	var json_result = JSON.parse(raw)
	self._text = json_result.result.text
	file.close()
	_update_gui()


func set_json_file_path(new_path):
	var file = File.new()
	if not file.file_exists(new_path):
		emit_signal("json_file_path_invalid")
		return
	json_file_path = new_path
