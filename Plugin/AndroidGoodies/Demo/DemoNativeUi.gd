extends Node

const NativeUiClass = preload("../Scripts/AGNativeUi.gd")

func _onShowToastButtonClick():
	NativeUiClass.showToast("Toast", NativeUiClass.ToastLength.SHORT)


func _onShowConfirmationDialogButtonClick():
	NativeUiClass.showConfirmationDialog("Confirmation Dialog", 
	"Do you accept your swift death?", NativeUiClass.DialogTheme.DEFAULT, 
	"Okay...", "_onPositiveButtonClicked", self)
	
func _onPositiveButtonClicked():
	NativeUiClass.showToast("Positive Button Clicked", 0)
