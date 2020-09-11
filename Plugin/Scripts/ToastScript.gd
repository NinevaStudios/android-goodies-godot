extends Node

var text = "toast text"
var plugin_name = "TestGodotPlugin"

func showToast():
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		singleton.showToast(text)
	else:
		print("No plugin singleton")


func _on_Button_button_up():
	print("Button clicked")
	showToast()
