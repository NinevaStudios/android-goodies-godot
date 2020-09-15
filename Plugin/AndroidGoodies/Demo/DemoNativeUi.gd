extends Node

const NativeUiClass = preload("../Scripts/AGNativeUi.gd")

func _onShowToastButtonClick():
	print("Button clicked")
	NativeUiClass.showToast("Toast", 0)
