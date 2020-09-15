extends Node

const plugin_name = "AndroidGoodies"

static func showToast(text, length):
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		singleton.showToast(text, length)
	else:
		print("No plugin singleton")
