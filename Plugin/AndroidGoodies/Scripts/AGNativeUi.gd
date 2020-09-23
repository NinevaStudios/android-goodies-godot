class_name AGNativeUi

const plugin_name = "AndroidGoodies"

const positive_button_signal_name = "onPositiveButtonClicked"
const negative_button_signal_name = "onNegativeButtonClicked"
const neutral_button_signal_name = "onNeutralButtonClicked"
const dialog_cancelled_signal_name = "onDialogCancelled";
const item_selected_signal_name = "onDialogItemClicked";
const multi_item_selected_signal_name = "onDialogItemSelected";

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
	
var _cached_button_dialog_data

var _is_cancelable = false
var _cancel_callback_name = ""
var _cancel_callback_object = null

var _item_chosen_callback_name = ""
var _item_chosen_callback_object = null

var _item_selected_callback_name = ""
var _item_selected_callback_object = null

var utils = AGUtils.new()

# API functions

func show_toast(text, length):
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		singleton.showToast(text, length as int)
	else:
		print("No plugin singleton")

func show_button_dialog(title, body, button_dialog_data, theme = DialogTheme.DEFAULT, 
		is_cancelable = false, cancel_callback_name = "", cancel_callback_object = null):
	if not button_dialog_data is ButtonDialogData:
		print("ButtonDialogData is not valid")
		pass
		
	_cached_button_dialog_data = button_dialog_data
	_is_cancelable = is_cancelable
	_cancel_callback_name = cancel_callback_name
	_cancel_callback_object = cancel_callback_object
	
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		
		_connect_positive_button_callback(singleton)
		_connect_negative_button_callback(singleton)
		_connect_neutral_button_callback(singleton)
		_connect_cancel_callback(singleton)
		
		singleton.showButtonDialog(title, body, button_dialog_data.positive_button_text, 
		button_dialog_data.negative_button_text, button_dialog_data.neutral_button_text, theme as int,
		is_cancelable)
	else:
		print("No plugin singleton")
		
func show_items_dialog(title, items, item_chosen_callback_name, item_chosen_callback_object,
		theme = DialogTheme.DEFAULT, is_cancelable = false, cancel_callback_name = "", cancel_callback_object = null):
	if items == null || items.size() == 0:
		print("Items are not valid")
		pass
		
	_is_cancelable = is_cancelable
	_cancel_callback_name = cancel_callback_name
	_cancel_callback_object = cancel_callback_object
	
	_item_chosen_callback_name = item_chosen_callback_name
	_item_chosen_callback_object = item_chosen_callback_object
		
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		
		_connect_item_selected_callback(singleton)
		_connect_cancel_callback(singleton)
		
		singleton.showItemsDialog(title, items, theme as int, is_cancelable)
	else:
		print("No plugin singleton")

func show_single_choice_dialog(title, items, selected_index, item_chosen_callback_name, item_chosen_callback_object, 
		button_dialog_data, theme = DialogTheme.DEFAULT, is_cancelable = false, cancel_callback_name = "", cancel_callback_object = null):
	if items == null || items.size() == 0:
		print("Items are not valid")
		pass
	
	_cached_button_dialog_data = button_dialog_data
	_is_cancelable = is_cancelable
	_cancel_callback_name = cancel_callback_name
	_cancel_callback_object = cancel_callback_object
	
	_item_chosen_callback_name = item_chosen_callback_name
	_item_chosen_callback_object = item_chosen_callback_object
	
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		
		_connect_positive_button_callback(singleton)
		_connect_negative_button_callback(singleton)
		_connect_neutral_button_callback(singleton)
		_connect_single_item_selected_callback(singleton)
		_connect_cancel_callback(singleton)
		
		singleton.showSingleChoiceDialog(title, items, selected_index, button_dialog_data.positive_button_text, 
				button_dialog_data.negative_button_text, button_dialog_data.neutral_button_text, 
				theme as int, is_cancelable)
	else:
		print("No plugin singleton")
		
func show_multi_choice_dialog(title, items, selected_indices, item_selected_callback_name, item_selected_callback_object, 
		button_dialog_data, theme = DialogTheme.DEFAULT, is_cancelable = false, cancel_callback_name = "", cancel_callback_object = null):
	if items == null || items.size() == 0:
		print("Items are not valid")
		pass
	
	_cached_button_dialog_data = button_dialog_data
	_is_cancelable = is_cancelable
	_cancel_callback_name = cancel_callback_name
	_cancel_callback_object = cancel_callback_object
	
	_item_selected_callback_name = item_selected_callback_name
	_item_selected_callback_object = item_selected_callback_object
	
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		
		_connect_positive_button_callback(singleton)
		_connect_negative_button_callback(singleton)
		_connect_neutral_button_callback(singleton)
		_connect_multi_item_selected_callback(singleton)
		_connect_cancel_callback(singleton)
		
		var byte_array = Array();
		for i in selected_indices.size():
			byte_array.append(1 if selected_indices[i] else 0)
		
		singleton.showMultipleChoiceDialog(title, items, byte_array, button_dialog_data.positive_button_text, 
				button_dialog_data.negative_button_text, button_dialog_data.neutral_button_text, 
				theme as int, is_cancelable)
	else:
		print("No plugin singleton")

# Helper functions. Do not call them directly.

func _connect_cancel_callback(singleton):
	if _is_cancelable:
		singleton.connect(dialog_cancelled_signal_name, self, "_on_dialog_cancel_callback")

func _on_dialog_cancel_callback():
	_cancel_callback_object.call(_cancel_callback_name)
	
	_disconnect_dialog_callbacks()
		
func _connect_positive_button_callback(singleton):
	if _cached_button_dialog_data.positive_button_text != "":
		singleton.connect(positive_button_signal_name, self, "_on_positive_button_selected")
		
func _on_positive_button_selected():
	_cached_button_dialog_data.positive_button_callback_object.call(_cached_button_dialog_data.positive_button_callback_name)
	
	_disconnect_dialog_callbacks()
	
func _connect_negative_button_callback(singleton):
	if _cached_button_dialog_data.positive_button_text != "":
		singleton.connect(negative_button_signal_name, self, "_on_negative_button_selected")
		
func _on_negative_button_selected():
	_cached_button_dialog_data.negative_button_callback_object.call(_cached_button_dialog_data.negative_button_callback_name)
	
	_disconnect_dialog_callbacks()
	
func _connect_neutral_button_callback(singleton):
	if _cached_button_dialog_data.neutral_button_text != "":
		singleton.connect(neutral_button_signal_name, self, "_on_neutral_button_selected")
		
func _on_neutral_button_selected():
	_cached_button_dialog_data.neutral_button_callback_object.call(_cached_button_dialog_data.neutral_button_callback_name)
	
	_disconnect_dialog_callbacks()
	
func _connect_item_selected_callback(singleton):
	singleton.connect(item_selected_signal_name, self, "_on_item_selected")
	
func _on_item_selected(index):
	_item_chosen_callback_object.call(_item_chosen_callback_name, index)
	
	_disconnect_dialog_callbacks()
	
func _connect_single_item_selected_callback(singleton):
	singleton.connect(item_selected_signal_name, self, "_on_single_item_selected")
	
func _on_single_item_selected(index):
	_item_chosen_callback_object.call(_item_chosen_callback_name, index)
	
func _connect_multi_item_selected_callback(singleton):
	singleton.connect(multi_item_selected_signal_name, self, "_on_multi_item_selected")
	
func _on_multi_item_selected(index, selected):
	_item_selected_callback_object.call(_item_selected_callback_name, index, selected)
	
func _disconnect_dialog_callbacks():
	var singleton = Engine.get_singleton(plugin_name)
	
	utils.disconnect_callback_if_connected(singleton, positive_button_signal_name, self, "_on_positive_button_selected")
	utils.disconnect_callback_if_connected(singleton, negative_button_signal_name, self, "_on_negative_button_selected")
	utils.disconnect_callback_if_connected(singleton, neutral_button_signal_name, self, "_on_neutral_button_selected")
	utils.disconnect_callback_if_connected(singleton, dialog_cancelled_signal_name, self, "_on_dialog_cancel_callback")
	utils.disconnect_callback_if_connected(singleton, dialog_cancelled_signal_name, self, "_on_dialog_cancel_callback")
	utils.disconnect_callback_if_connected(singleton, item_selected_signal_name, self, "_on_item_selected")
	utils.disconnect_callback_if_connected(singleton, item_selected_signal_name, self, "_on_single_item_selected")
	utils.disconnect_callback_if_connected(singleton, multi_item_selected_signal_name, self, "_on_multi_item_selected")
	
	_cached_button_dialog_data = null	
