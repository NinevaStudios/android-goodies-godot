extends Node

var native_ui = AGNativeUi.new()

func _onShowToastButtonClick():
	native_ui.show_toast("Toast", AGNativeUi.ToastLength.SHORT)


func _onShowConfirmationDialogButtonClick():
	var dialog_data = _create_dialog_data()
	
	native_ui.show_button_dialog("Dialog", "Do you accept your swift death?", 
			dialog_data, AGNativeUi.DialogTheme.DEFAULT, true, "_onDialogCancelled", self)
			
func _onShowItemsDialogClicked():
	native_ui.show_items_dialog("How would you like to die?", 
			["Slowly", "Quickly", "Don't care, just now"], "_onItemSelected", self,
			AGNativeUi.DialogTheme.DEFAULT, true, "_onDialogCancelled", self)

func _onShowSingleChoiceDialogClicked():
	var dialog_data = _create_dialog_data()
	
	native_ui.show_single_choice_dialog("Choose only one:", ["Intelligence", "Beauty", "Wealth"], 0, 
			"_onItemSelected", self, dialog_data, AGNativeUi.DialogTheme.DEFAULT, 
			true, "_onDialogCancelled", self)
			
func _onShowMultiChoiceDialogClicked():
	var dialog_data = _create_dialog_data()
	
	native_ui.show_multi_choice_dialog("Choose only one:", ["Intelligence", "Beauty", "Wealth"], 
			[true, false, false], "_onMultiItemSelected", self, dialog_data, 
			AGNativeUi.DialogTheme.DEFAULT, true, "_onDialogCancelled", self)
			
func _onShowProgressDialogClicked():
	var max_progress = 100
	var timer_interval = 0.5
	native_ui.show_progress_dialog("Such progress", "Fascinating...", 0, max_progress, false, 
			AGNativeUi.DialogTheme.DEFAULT, false, "_onDialogCancelled", self, 
			"_on_progress_dialog_dismissed", self)
			
	var timer = Timer.new()
	timer.wait_time = timer_interval
	self.add_child(timer)
	timer.start()
	
	for i in range(11):
		yield(timer, "timeout")
		var progress = max_progress * i * timer_interval / 5
		print(progress)
		native_ui.set_progress_dialog_progress(progress)
		
	timer.stop()
	native_ui.dismiss_progress_dialog()
	
	var dialog_data = _create_dialog_data()
	native_ui.show_button_dialog("Progress", "Process was completed", 
			dialog_data, AGNativeUi.DialogTheme.DEFAULT, true, "_onDialogCancelled", self)
			
	timer.queue_free()

func _create_dialog_data() -> AGNativeUi.ButtonDialogData:
	var dialog_data = AGNativeUi.ButtonDialogData.new()
	
	dialog_data.positive_button_text = "Okay..."
	dialog_data.positive_button_callback_name = "_onPositiveButtonClicked"
	dialog_data.positive_button_callback_object = self
	
	dialog_data.neutral_button_text = "Maybe?"
	dialog_data.neutral_button_callback_name = "_onNeutralButtonClicked"
	dialog_data.neutral_button_callback_object = self

	dialog_data.negative_button_text = "NO!"
	dialog_data.negative_button_callback_name = "_onNegativeButtonClicked"
	dialog_data.negative_button_callback_object = self
	
	return dialog_data
	
func _onPositiveButtonClicked():
	native_ui.show_toast("Positive Button Clicked", AGNativeUi.ToastLength.SHORT)
	
func _onNegativeButtonClicked():
	native_ui.show_toast("Negative Button Clicked", AGNativeUi.ToastLength.SHORT)
	
func _onNeutralButtonClicked():
	native_ui.show_toast("Neutral Button Clicked", AGNativeUi.ToastLength.SHORT)
	
func _onDialogCancelled():
	native_ui.show_toast("Dialog was cancelled", AGNativeUi.ToastLength.SHORT)
	
func _onItemSelected(index):
	native_ui.show_toast("Item selected: " + String(index), AGNativeUi.ToastLength.SHORT)
	
func _onMultiItemSelected(index, selected):
	var message = "Item " + String(index) + " is " + ("selected." if selected else "deselected.")
	native_ui.show_toast(message, AGNativeUi.ToastLength.SHORT)
	
func _on_progress_dialog_dismissed():
	print("Dialog dismissed.")
