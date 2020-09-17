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
	
	var is_cancelable = false
	var cancel_callback_name = ""
	var cancel_callback_object = null
	
var cached_button_dialog_data
	
func show_toast(text, length):
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		singleton.showToast(text, length as int)
	else:
		print("No plugin singleton")
		
func show_button_dialog(title, body, theme, button_dialog_data):
	if !(button_dialog_data is ButtonDialogData):
		print("ButtonDialogData is not valid")
		pass
		
	cached_button_dialog_data = button_dialog_data
	
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		
		connect_positive_button_callback(singleton)
		connect_negative_button_callback(singleton)
		connect_neutral_button_callback(singleton)
		connect_cancel_callback(singleton)
		
		singleton.showButtonDialog(title, body, button_dialog_data.positive_button_text, 
		button_dialog_data.negative_button_text, button_dialog_data.neutral_button_text, theme as int,
		button_dialog_data.is_cancelable)
	else:
		print("No plugin singleton")
		
func connect_cancel_callback(singleton):
	if cached_button_dialog_data.is_cancelable:
		singleton.connect(dialog_cancelled_signal_name, self, "on_dialog_cancel_callback")

func on_dialog_cancel_callback():
	cached_button_dialog_data.cancel_callback_object.call(cached_button_dialog_data.cancel_callback_name)
	
	disconnect_button_dialog_callbacks()
		
func connect_positive_button_callback(singleton):
	if (cached_button_dialog_data.positive_button_text != ""):
		singleton.connect(positive_button_signal_name, self, "on_positive_button_selected")
		
func on_positive_button_selected():
	cached_button_dialog_data.positive_button_callback_object.call(cached_button_dialog_data.positive_button_callback_name)
	
	disconnect_button_dialog_callbacks()
	
func connect_negative_button_callback(singleton):
	if (cached_button_dialog_data.positive_button_text != ""):
		singleton.connect(negative_button_signal_name, self, "on_negative_button_selected")
		
func on_negative_button_selected():
	cached_button_dialog_data.negative_button_callback_object.call(cached_button_dialog_data.negative_button_callback_name)
	
	disconnect_button_dialog_callbacks()
	
func connect_neutral_button_callback(singleton):
	if (cached_button_dialog_data.neutral_button_text != ""):
		singleton.connect(neutral_button_signal_name, self, "on_neutral_button_selected")
		
func on_neutral_button_selected():
	cached_button_dialog_data.neutral_button_callback_object.call(cached_button_dialog_data.neutral_button_callback_name)
	
	disconnect_button_dialog_callbacks()
		
func disconnect_button_dialog_callbacks():
	var singleton = Engine.get_singleton(plugin_name)
	
	disconnect_callback_if_connected(singleton, positive_button_signal_name, self, "on_positive_button_selected")
	disconnect_callback_if_connected(singleton, negative_button_signal_name, self, "on_negative_button_selected")
	disconnect_callback_if_connected(singleton, neutral_button_signal_name, self, "on_neutral_button_selected")
	disconnect_callback_if_connected(singleton, dialog_cancelled_signal_name, self, "on_dialog_cancel_callback")
	
func disconnect_callback_if_connected(singleton, signal_name, callback_object, callback_name):
	if callback_object != null && singleton.is_connected(signal_name, callback_object, callback_name):
		singleton.disconnect(signal_name, callback_object, callback_name)
