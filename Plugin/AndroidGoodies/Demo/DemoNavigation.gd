extends Node

class_name DemoNavigation

onready var native_ui_panel = get_node("NativeUiPanel")
onready var pickers_panel = get_node("PickersPanel")
onready var device_info_panel = get_node("DeviceInfoPanel")
onready var sharing_panel = get_node("SharePanel")
onready var hardware_panel = get_node("HardwarePanel") as DemoHardware
onready var base_panel = get_node("BasePanel")

func _ready():
	hide_panels()
	base_panel.show()
	
func hide_panels():
	native_ui_panel.hide()
	base_panel.hide()
	pickers_panel.hide()
	device_info_panel.hide()
	sharing_panel.hide()
	hardware_panel.hide()

func _onOpenNativeUiButtonClicked():
	hide_panels()
	native_ui_panel.show()

func _onBackButtonClicked():
	hide_panels()
	base_panel.show()

func _onOpenPickersButtonClicked():
	hide_panels()
	pickers_panel.show()

func _onOpenDeviceInfoButtonClicked():
	hide_panels()
	device_info_panel.show()
	
func _onOpenSharingButtonClicked():
	hide_panels()
	sharing_panel.show()

func _onOpenHardwareButtonClicked():
	hide_panels()
	hardware_panel.show()
	hardware_panel.print_battery_info()
