extends Node

const plugin_name = "AndroidGoodies"
const positive_button_signal_name = "onPositiveButtonClicked"
const negative_button_signal_name = "onNegativeButtonClicked"
const neutral_button_signal_name = "onNeutralButtonClicked"
const dialog_cancelled_signal_name = "onDialogCancelled";

enum ToastLength { SHORT = 0, LONG = 1 }
enum DialogTheme { LIGHT = 0, DARK = 1, DEFAULT = 2 }

class ButtonDialogData:
	var positive_button_text = ""
	var positive_button_callback_name = ""
	var positive_button_callback_object = null
	var negative_button_text = ""
	var negative_button_callback_name = ""
	var negative_button_callback_object = null
	var neutral_button_text = ""
	var neutral_button_callback_name = ""
	var neutral_button_callback_object = null
	
static func show_toast(text, length):
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		singleton.showToast(text, length as int)
	else:
		print("No plugin singleton")
		
static func show_button_dialog(title, body, theme, button_dialog_data, 
is_cancelable = false, cancel_callback_name = null, cancel_callback_object = null):
	if !(button_dialog_data is ButtonDialogData):
		print("ButtonDialogData is not valid")
		pass
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		
		if (button_dialog_data.positive_button_text != ""):
			singleton.connect(positive_button_signal_name, button_dialog_data.positive_button_callback_object, button_dialog_data.positive_button_callback_name, [], Object.CONNECT_ONESHOT)
		
		if (button_dialog_data.negative_button_text != ""):
			singleton.connect(negative_button_signal_name, button_dialog_data.negative_button_callback_object, button_dialog_data.negative_button_callback_name, [], Object.CONNECT_ONESHOT)
		
		if (button_dialog_data.neutral_button_text != ""):
			singleton.connect(neutral_button_signal_name, button_dialog_data.neutral_button_callback_object, button_dialog_data.neutral_button_callback_name, [], Object.CONNECT_ONESHOT)
		
		set_cancel_listener(singleton, is_cancelable, cancel_callback_name, cancel_callback_object)
		
		singleton.showButtonDialog(title, body, button_dialog_data.positive_button_text, 
		button_dialog_data.negative_button_text, button_dialog_data.neutral_button_text, theme as int, is_cancelable)
	else:
		print("No plugin singleton")
		
static func set_cancel_listener(singleton, is_cancelable = false, cancel_callback_name = null, cancel_callback_object = null):
	if is_cancelable && cancel_callback_name != null && cancel_callback_object != null:
		singleton.connect(dialog_cancelled_signal_name, cancel_callback_object, cancel_callback_name, [], Object.CONNECT_ONESHOT)
	else: 
		print("Cancel callback is either disabled or not configured properly")
