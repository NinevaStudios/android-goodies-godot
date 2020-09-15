extends Node

const NativeUiClass = preload("../Scripts/AGNativeUi.gd")

func _onShowToastButtonClick():
	NativeUiClass.showToast("Toast", 0)


func _onShowConfirmationDialogButtonClick():
	NativeUiClass.showConfirmationDialog("Confirmation Dialog", "Do you accept your swift death?", "Okay...", "_onPositiveButtonClicked", self)
	
func _onPositiveButtonClicked():
	NativeUiClass.showToast("Positive Button Clicked", 0)
