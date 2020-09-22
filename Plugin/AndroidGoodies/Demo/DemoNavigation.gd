extends Panel

onready var native_ui_panel = get_node("NativeUiPanel")
onready var base_panel = get_node("BasePanel")

func _ready():
	hide_panels()
	base_panel.show()
	
func hide_panels():
	native_ui_panel.hide()
	base_panel.hide()


func _onOpenNativeUiButtonClicked():
	hide_panels()
	native_ui_panel.show()


func _onBackButtonClicked():
	hide_panels()
	base_panel.show()
