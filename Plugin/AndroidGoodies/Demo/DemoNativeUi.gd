extends Node

const NativeUiClass = preload("../Scripts/AGNativeUi.gd")

func _onShowToastButtonClick():
	NativeUiClass.show_toast("Toast", NativeUiClass.ToastLength.SHORT)


func _onShowConfirmationDialogButtonClick():
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
	
	NativeUiClass.show_button_dialog("Dialog", 
	"Do you accept your swift death?", NativeUiClass.DialogTheme.DEFAULT, 
	dialog_data, true, "_onDialogCancelled", self)
	
func _onPositiveButtonClicked():
	NativeUiClass.show_toast("Positive Button Clicked", 0)
	
func _onNegativeButtonClicked():
	NativeUiClass.show_toast("Negative Button Clicked", 0)
	
func _onNeutralButtonClicked():
	NativeUiClass.show_toast("Neutral Button Clicked", 0)
	
func _onDialogCancelled():
	NativeUiClass.show_toast("Dialog was cancelled", 0)
