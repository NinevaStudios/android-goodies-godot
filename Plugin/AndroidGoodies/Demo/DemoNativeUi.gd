extends Node

const NativeUiClass = preload("../Scripts/AGNativeUi.gd")

func _onShowToastButtonClick():
	NativeUiClass.show_toast("Toast", NativeUiClass.ToastLength.SHORT)


func _onShowConfirmationDialogButtonClick():
	NativeUiClass.show_confirmation_dialog("Confirmation Dialog", 
	"Do you accept your swift death?", NativeUiClass.DialogTheme.DEFAULT, 
	"Okay...", "_onPositiveButtonClicked", self, true, "_onDialogCancelled", self)
	
func _onPositiveButtonClicked():
	NativeUiClass.show_toast("Positive Button Clicked", 0)
	
func _onDialogCancelled():
	NativeUiClass.show_toast("Dialog was cancelled", 0)
