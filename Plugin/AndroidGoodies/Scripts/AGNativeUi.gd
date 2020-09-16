extends Node

const plugin_name = "AndroidGoodies"
const positive_button_signal_name = "onPositiveButtonClicked"
const negative_button_signal_name = "onNegativeButtonClicked"
const neutral_button_signal_name = "onNeutralButtonClicked"
const dialog_cancelled_signal_name = "onDialogCancelled";

enum ToastLength { SHORT = 0, LONG = 1 }
enum DialogTheme { LIGHT = 0, DARK = 1, DEFAULT = 2 }

static func show_toast(text, length):
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		singleton.showToast(text, length as int)
	else:
		print("No plugin singleton")
		
static func show_confirmation_dialog(title, body, theme, button_text, button_callback_name, button_callback_object, 
is_cancelable = false, cancel_callback_name = null, cancel_callback_object = null):
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		singleton.connect(positive_button_signal_name, button_callback_object, button_callback_name)
		set_cancel_listener(singleton, is_cancelable, cancel_callback_name, cancel_callback_object)
		singleton.showConfirmationDialog(title, body, button_text, theme as int, is_cancelable)
	else:
		print("No plugin singleton")
		
static func set_cancel_listener(singleton, is_cancelable = false, cancel_callback_name = null, cancel_callback_object = null):
	if is_cancelable && cancel_callback_name != null && cancel_callback_object != null:
		singleton.connect(dialog_cancelled_signal_name, cancel_callback_object, cancel_callback_name)
	else: 
		print("Cancel callback is either disabled or not configured properly")
