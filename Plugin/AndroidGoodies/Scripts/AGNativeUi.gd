extends Node

const plugin_name = "AndroidGoodies"
const positive_button_signal_name = "onPositiveButtonClicked"

enum ToastLength { SHORT = 0, LONG = 1 }
enum DialogTheme { LIGHT = 0, DARK = 1, DEFAULT = 2 }

static func show_toast(text, length):
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		singleton.showToast(text, length as int)
	else:
		print("No plugin singleton")
		
static func show_confirmation_dialog(title, body, theme, button_text, button_callback_name, button_callback_object):
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		singleton.connect(positive_button_signal_name, button_callback_object, button_callback_name)
		singleton.showConfirmationDialog(title, body, button_text, theme as int)
	else:
		print("No plugin singleton")
