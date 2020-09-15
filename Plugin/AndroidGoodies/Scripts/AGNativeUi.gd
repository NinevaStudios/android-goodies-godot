extends Node

const plugin_name = "AndroidGoodies"

static func showToast(text, length):
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		singleton.showToast(text, length)
	else:
		print("No plugin singleton")
		
static func showConfirmationDialog(title, body, button_text, button_callback_name, button_callback_object):
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		singleton.connect("onConfirmButtonClicked", button_callback_object, button_callback_name)
		singleton.showConfirmationDialog(title, body, button_text)
	else:
		print("No plugin singleton")
