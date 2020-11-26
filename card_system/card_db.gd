extends Node

class_name CardDb

export(String, FILE) var json_file_path = "" setget set_json_file_path

signal json_file_path_invalid
signal json_file_not_loaded
signal json_file_not_dictionary
signal json_file_invalid_json


func load() -> Dictionary:
	var file = File.new()
	if file.file_exists(json_file_path):
		var opening_error = file.open(json_file_path, File.READ)
		if not opening_error:
			var json_parsing = JSON.parse(file.get_as_text())
			if not json_parsing.error:
				var dict_result = json_parsing.result
				if typeof(dict_result) == TYPE_DICTIONARY:
					return dict_result			
				else:
					emit_signal("json_file_not_dictionary")
			else:
				emit_signal("json_file_invalid_json")
		else:
			emit_signal("json_file_not_loaded")
	else:
		emit_signal("json_file_path_invalid")
	return Dictionary()	


func set_json_file_path(new_path):
	var file = File.new()
	if file.file_exists(new_path):
		json_file_path = new_path
	emit_signal("json_file_path_invalid")