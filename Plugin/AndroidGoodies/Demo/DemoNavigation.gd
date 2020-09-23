extends Node

class_name DemoNavigation

onready var native_ui_panel = get_node("NativeUiPanel")
onready var pickers_panel = get_node("PickersPanel")
onready var base_panel = get_node("BasePanel")

func _ready():
	hide_panels()
	base_panel.show()
	set_up_button_listeners()
	
func hide_panels():
	native_ui_panel.hide()
	base_panel.hide()
	pickers_panel.hide()
	
func set_up_button_listeners():
	var open_native_ui_button = get_node("BasePanel/OpenNativeUiButton") as Button
	open_native_ui_button.connect("button_up", self, "_onOpenNativeUiButtonClicked")
	
	var open_pickers_button = get_node("BasePanel/OpenPickersButton") as Button
	open_pickers_button.connect("button_up", self, "_onOpenPickersButtonClicked")
	
	var back_button_ui = get_node("NativeUiPanel/BackButton") as Button
	back_button_ui.connect("button_up", self, "_onBackButtonClicked")
	
	var back_button_pickers = get_node("PickersPanel/BackButton") as Button
	back_button_pickers.connect("button_up", self, "_onBackButtonClicked")

func _onOpenNativeUiButtonClicked():
	hide_panels()
	native_ui_panel.show()


func _onBackButtonClicked():
	hide_panels()
	base_panel.show()


func _onOpenPickersButtonClicked():
	hide_panels()
	pickers_panel.show()
