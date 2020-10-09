class_name AGNativeUi

const _positive_button_signal_name = "onPositiveButtonClicked"
const _negative_button_signal_name = "onNegativeButtonClicked"
const _neutral_button_signal_name = "onNeutralButtonClicked"
const _dialog_cancelled_signal_name = "onDialogCancelled";
const _item_selected_signal_name = "onDialogItemClicked";
const _multi_item_selected_signal_name = "onDialogItemSelected";
const _dialog_dismiss_signal_name = "onProgressDialogDismissed";

# Values used to specify the duration for Toast appearance.
enum ToastLength { SHORT = 0, LONG = 1 }

#Values for the themes of the native dialogs.
enum DialogTheme { LIGHT = 0, DARK = 1, DEFAULT = 2 }

# Structure to send the data about buttons for the native dialogs.
# All the buttons are optional, but when providing info for a button, 
# you should set the text, callback name, and callback object for the respective button.
class ButtonDialogData:
	# Text to show on the positive button.
	var positive_button_text : String = ""
	# Name of the callback function to be invoked if the positive button is tapped.
	var positive_button_callback_name : String = ""
	# Object reference to invoke the positive_button_callback_name function on.
	var positive_button_callback_object : Object = null
	
	# Text to show on the negative button.
	var negative_button_text : String = ""
	# Name of the callback function to be invoked if the negative button is tapped.
	var negative_button_callback_name : String = ""
	# Object reference to invoke the negative_button_callback_name function on.
	var negative_button_callback_object : Object = null
	
	# Text to show on the neutral button.
	var neutral_button_text : String = ""
	# Name of the callback function to be invoked if the neutral button is tapped.
	var neutral_button_callback_name : String = ""
	# Object reference to invoke the neutral_button_callback_name function on.
	var neutral_button_callback_object : Object = null
	
var _cached_button_dialog_data

var _is_cancelable = false
var _cancel_callback_name = ""
var _cancel_callback_object = null

var _item_chosen_callback_name = ""
var _item_chosen_callback_object = null

var _item_selected_callback_name = ""
var _item_selected_callback_object = null

var _dismiss_callback_name = ""
var _dismiss_callback_object = null

var utils = AGUtils.new()

# API functions

# Show a toast message.
func show_toast(text : String, length = ToastLength.SHORT):
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		singleton.showToast(text, length as int)
	else:
		print("No plugin singleton")

# Show the default Android message dialog with one, two or three buttons.
# 
# @param title: message title text to be displayed in dialog.
# @param body: message text to be displayed in dialog.
# @param button_dialog_data: ButtonDialogData object containing information about the buttons to be displayed on the dialog.
# @param theme: theme of the dialog. One of the DialogTheme constants.
# @param is_cancelable: whether the dialog can be dismissed by tapping outsude its bounds.
# @param cancel_callback_name: name of the callback function to be invoked if the dialog is cancelled.
# @param cancel_callback_object: object on which the cancel_callback_name is invoked if the dialog is cancelled.
func show_button_dialog(title : String, body : String, button_dialog_data : ButtonDialogData, theme = DialogTheme.DEFAULT, 
		is_cancelable : bool = false, cancel_callback_name : String = "", cancel_callback_object : Object = null):
	if not button_dialog_data is ButtonDialogData:
		print("ButtonDialogData is not valid")
		pass
		
	_cached_button_dialog_data = button_dialog_data
	_is_cancelable = is_cancelable
	_cancel_callback_name = cancel_callback_name
	_cancel_callback_object = cancel_callback_object
	
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		_connect_positive_button_callback(singleton)
		_connect_negative_button_callback(singleton)
		_connect_neutral_button_callback(singleton)
		_connect_cancel_callback(singleton)
		
		singleton.showButtonDialog(title, body, button_dialog_data.positive_button_text, 
		button_dialog_data.negative_button_text, button_dialog_data.neutral_button_text, theme as int,
		is_cancelable)
	else:
		print("No plugin singleton")
		
# Show the default Android message dialog with choosable items list.
# The dialog is dismissed when an item is selected.
# 
# @param title: message title text to be displayed in dialog.
# @param items: array of choosable text items that are displayed in dialog
# @param item_chosen_callback_name: name of the callback function to be invoked when an item is chosen (returning the index of an item).
# @param item_chosen_callback_name: object on which the item_chosen_callback_object is invoked when an item is chosen.
# @param theme: theme of the dialog. One of the DialogTheme constants.
# @param is_cancelable: whether the dialog can be dismissed by tapping outsude its bounds.
# @param cancel_callback_name: name of the callback function to be invoked if the dialog is cancelled.
# @param cancel_callback_object: object on which the cancel_callback_name is invoked if the dialog is cancelled.
func show_items_dialog(title : String, items : PoolStringArray, item_chosen_callback_name : String, item_chosen_callback_object : Object,
		theme = DialogTheme.DEFAULT, is_cancelable : bool = false, cancel_callback_name : String = "", cancel_callback_object : Object = null):
	if items == null || items.size() == 0:
		print("Items are not valid")
		pass
		
	_is_cancelable = is_cancelable
	_cancel_callback_name = cancel_callback_name
	_cancel_callback_object = cancel_callback_object
	
	_item_chosen_callback_name = item_chosen_callback_name
	_item_chosen_callback_object = item_chosen_callback_object
		
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		_connect_item_selected_callback(singleton)
		_connect_cancel_callback(singleton)
		
		singleton.showItemsDialog(title, items, theme as int, is_cancelable)
	else:
		print("No plugin singleton")
		
# Show the default Android message dialog with single choice items list.
# 
# @param title: message title text to be displayed in dialog.
# @param items: array of choosable text items that are displayed in dialog
# @param selected_index: index of list item that is selected when the dialog is shown.
# @param item_chosen_callback_name: name of the callback function to be invoked when an item is chosen (returning the index of an item).
# @param item_chosen_callback_name: object on which the item_chosen_callback_object is invoked when an item is chosen.
# @param button_dialog_data: ButtonDialogData object containing information about the buttons to be displayed on the dialog.
# @param theme: theme of the dialog. One of the DialogTheme constants.
# @param is_cancelable: whether the dialog can be dismissed by tapping outsude its bounds.
# @param cancel_callback_name: name of the callback function to be invoked if the dialog is cancelled.
# @param cancel_callback_object: object on which the cancel_callback_name is invoked if the dialog is cancelled.
func show_single_choice_dialog(title : String, items : PoolStringArray, selected_index : int, item_chosen_callback_name : String, item_chosen_callback_object : Object, 
		button_dialog_data : ButtonDialogData, theme = DialogTheme.DEFAULT, is_cancelable : bool = false, cancel_callback_name : String = "", cancel_callback_object : Object = null):
	if items == null || items.size() == 0:
		print("Items are not valid")
		pass
	
	_cached_button_dialog_data = button_dialog_data
	_is_cancelable = is_cancelable
	_cancel_callback_name = cancel_callback_name
	_cancel_callback_object = cancel_callback_object
	
	_item_chosen_callback_name = item_chosen_callback_name
	_item_chosen_callback_object = item_chosen_callback_object
	
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
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
		
# Show the default Android message dialog with multiple choice items list.
# 
# @param title: message title text to be displayed in dialog.
# @param items: array of choosable text items that are displayed in dialog
# @param selected_indices: indices of list item that are selected when the dialog is shown.
# @param item_selected_callback_name: name of the callback function to be invoked when an item is chosen (returning the index of an item).
# @param item_selected_callback_object: object on which the item_chosen_callback_object is invoked when an item is chosen.
# @param button_dialog_data: ButtonDialogData object containing information about the buttons to be displayed on the dialog.
# @param theme: theme of the dialog. One of the DialogTheme constants.
# @param is_cancelable: whether the dialog can be dismissed by tapping outsude its bounds.
# @param cancel_callback_name: name of the callback function to be invoked if the dialog is cancelled.
# @param cancel_callback_object: object on which the cancel_callback_name is invoked if the dialog is cancelled.
func show_multi_choice_dialog(title : String, items : PoolStringArray, selected_indices : Array, item_selected_callback_name : String, item_selected_callback_object, 
		button_dialog_data : ButtonDialogData, theme = DialogTheme.DEFAULT, is_cancelable : bool = false, cancel_callback_name : String = "", cancel_callback_object = null):
	if items == null || items.size() == 0:
		print("Items are not valid")
		pass
	
	_cached_button_dialog_data = button_dialog_data
	_is_cancelable = is_cancelable
	_cancel_callback_name = cancel_callback_name
	_cancel_callback_object = cancel_callback_object
	
	_item_selected_callback_name = item_selected_callback_name
	_item_selected_callback_object = item_selected_callback_object
	
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
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
		
# Show the default Android progress dialog.
# 
# @param title: message title text to be displayed in dialog.
# @param items: array of choosable text items that are displayed in dialog
# @param progress: maximum allowed progress value.
# @param indeterminate: flag that determines whether progress dialog shows infinite animation.
# @param theme: theme of the dialog. One of the DialogTheme constants.
# @param is_cancelable: whether the dialog can be dismissed by tapping outsude its bounds.
# @param dismiss_callback_name: name of the callback function to be invoked if the dialog is dismissed.
# @param dismiss_callback_object: object on which the cancel_callback_name is invoked if the dialog is dismissed
# @param cancel_callback_name: name of the callback function to be invoked if the dialog is cancelled.
# @param cancel_callback_object: object on which the cancel_callback_name is invoked if the dialog is cancelled.
func show_progress_dialog(title : String, message : String, progress : int, max_value : int, 
		indeterminate : bool, theme = DialogTheme.DEFAULT, is_cancelable : bool = false, 
		dismiss_callback_name : String = "", dismiss_callback_object : Object = null,
		cancel_callback_name : String = "", cancel_callback_object : Object = null):
	_is_cancelable = is_cancelable
	_cancel_callback_name = cancel_callback_name
	_cancel_callback_object = cancel_callback_object
	
	_dismiss_callback_name = dismiss_callback_name
	_dismiss_callback_object = dismiss_callback_object
		
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		_connect_dismiss_callback(singleton)
		_connect_cancel_callback(singleton)
		
		singleton.showProgressDialog(title, message, progress, max_value, theme as int, is_cancelable, indeterminate)
	else:
		print("No plugin singleton")
		
# Set the progress of the currently displayed progress dialog between 0 and its max_value.
func set_progress_dialog_progress(progress : int):
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		singleton.setProgressForProgressDialog(progress)
	else:
		print("No plugin singleton")
		
# Dismiss the currently displayed progress dialog.
func dismiss_progress_dialog():
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		singleton.dismissProgressDialog()
	else:
		print("No plugin singleton")

# Helper functions. Do not call them directly.

func _connect_cancel_callback(singleton):
	if _is_cancelable:
		singleton.connect(_dialog_cancelled_signal_name, self, "_on_dialog_cancel_callback")

func _on_dialog_cancel_callback():
	_cancel_callback_object.call(_cancel_callback_name)
	
	_disconnect_dialog_callbacks()
		
func _connect_positive_button_callback(singleton):
	if _cached_button_dialog_data.positive_button_text != "":
		singleton.connect(_positive_button_signal_name, self, "_on_positive_button_selected")
		
func _on_positive_button_selected():
	_cached_button_dialog_data.positive_button_callback_object.call(_cached_button_dialog_data.positive_button_callback_name)
	
	_disconnect_dialog_callbacks()
	
func _connect_negative_button_callback(singleton):
	if _cached_button_dialog_data.positive_button_text != "":
		singleton.connect(_negative_button_signal_name, self, "_on_negative_button_selected")
		
func _on_negative_button_selected():
	_cached_button_dialog_data.negative_button_callback_object.call(_cached_button_dialog_data.negative_button_callback_name)
	
	_disconnect_dialog_callbacks()
	
func _connect_neutral_button_callback(singleton):
	if _cached_button_dialog_data.neutral_button_text != "":
		singleton.connect(_neutral_button_signal_name, self, "_on_neutral_button_selected")
		
func _on_neutral_button_selected():
	_cached_button_dialog_data.neutral_button_callback_object.call(_cached_button_dialog_data.neutral_button_callback_name)
	
	_disconnect_dialog_callbacks()
	
func _connect_item_selected_callback(singleton):
	singleton.connect(_item_selected_signal_name, self, "_on_item_selected")
	
func _on_item_selected(index):
	_item_chosen_callback_object.call(_item_chosen_callback_name, index)
	
	_disconnect_dialog_callbacks()
	
func _connect_single_item_selected_callback(singleton):
	singleton.connect(_item_selected_signal_name, self, "_on_single_item_selected")
	
func _on_single_item_selected(index):
	_item_chosen_callback_object.call(_item_chosen_callback_name, index)
	
func _connect_multi_item_selected_callback(singleton):
	singleton.connect(_multi_item_selected_signal_name, self, "_on_multi_item_selected")
	
func _on_multi_item_selected(index, selected):
	_item_selected_callback_object.call(_item_selected_callback_name, index, selected)
	
func _connect_dismiss_callback(singleton):
	singleton.connect(_dialog_dismiss_signal_name, self, "_on_dialog_dismiss_callback")

func _on_dialog_dismiss_callback():
	_dismiss_callback_object.call(_dismiss_callback_name)
	
	_disconnect_dialog_callbacks()
	
func _disconnect_dialog_callbacks():
	var singleton = Engine.get_singleton(AGUtils.plugin_name)
	
	utils.disconnect_callback_if_connected(singleton, _positive_button_signal_name, self, "_on_positive_button_selected")
	utils.disconnect_callback_if_connected(singleton, _negative_button_signal_name, self, "_on_negative_button_selected")
	utils.disconnect_callback_if_connected(singleton, _neutral_button_signal_name, self, "_on_neutral_button_selected")
	utils.disconnect_callback_if_connected(singleton, _dialog_cancelled_signal_name, self, "_on_dialog_cancel_callback")
	utils.disconnect_callback_if_connected(singleton, _item_selected_signal_name, self, "_on_item_selected")
	utils.disconnect_callback_if_connected(singleton, _item_selected_signal_name, self, "_on_single_item_selected")
	utils.disconnect_callback_if_connected(singleton, _multi_item_selected_signal_name, self, "_on_multi_item_selected")
	utils.disconnect_callback_if_connected(singleton, _dialog_dismiss_signal_name, self, "_on_dialog_dismiss_callback")
	
	_cached_button_dialog_data = null	
