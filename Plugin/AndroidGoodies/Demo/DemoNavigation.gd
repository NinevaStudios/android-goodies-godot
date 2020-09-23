extends Node

class_name DemoNavigation

onready var native_ui_panel = get_node("NativeUiPanel")
onready var pickers_panel = get_node("PickersPanel")
onready var base_panel = get_node("BasePanel")

onready var open_native_ui_button = get_node("BasePanel/OpenNativeUiButton") as Button
onready var open_pickers_button = get_node("BasePanel/OpenPickersButton") as Button

onready var back_button_ui = get_node("NativeUiPanel/BackButton") as Button
onready var back_button_pickers = get_node("PickersPanel/BackButton") as Button

func _ready():
	hide_panels()
	base_panel.show()
	set_up_button_listeners()
	
func hide_panels():
	native_ui_panel.hide()
	base_panel.hide()
	pickers_panel.hide()
	
func set_up_button_listeners():
	open_native_ui_button.connect("button_up", self, "_onOpenNativeUiButtonClicked")
	open_pickers_button.connect("button_up", self, "_onOpenPickersButtonClicked")
	
	back_button_ui.connect("button_up", self, "_onBackButtonClicked")
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
