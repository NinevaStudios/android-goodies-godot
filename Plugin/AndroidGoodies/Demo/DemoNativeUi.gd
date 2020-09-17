extends Node

const NativeUiClass = preload("../Scripts/AGNativeUi.gd")

var native_ui = NativeUiClass.new()

func _onShowToastButtonClick():
	native_ui.show_toast("Toast", NativeUiClass.ToastLength.SHORT)


func _onShowConfirmationDialogButtonClick():
	var dialog_data = _create_dialog_data()
	
	native_ui.show_button_dialog("Dialog", "Do you accept your swift death?", 
			dialog_data, NativeUiClass.DialogTheme.DEFAULT, true, "_onDialogCancelled", self)
			
func _onShowItemsDialogClicked():
	native_ui.show_items_dialog("How would you like to die?", 
			["Slowly", "Quickly", "Don't care, just now"], "_onItemSelected", self,
			NativeUiClass.DialogTheme.DEFAULT, true, "_onDialogCancelled", self)

func _onShowSingleChoiceDialogClicked():
	var dialog_data = _create_dialog_data()
	
	native_ui.show_single_choice_dialog("Choose only one:", ["Intelligence", "Beauty", "Wealth"], 0, 
			"_onItemSelected", self, dialog_data, NativeUiClass.DialogTheme.DEFAULT, 
			true, "_onDialogCancelled", self)
			
func _create_dialog_data() -> NativeUiClass.ButtonDialogData:
	var dialog_data = NativeUiClass.ButtonDialogData.new()
	
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
	native_ui.show_toast("Positive Button Clicked", 0)
	
func _onNegativeButtonClicked():
	native_ui.show_toast("Negative Button Clicked", 0)
	
func _onNeutralButtonClicked():
	native_ui.show_toast("Neutral Button Clicked", 0)
	
func _onDialogCancelled():
	native_ui.show_toast("Dialog was cancelled", 0)
	
func _onItemSelected(index):
	native_ui.show_toast("Item selected: " + String(index), 0)


