extends Node

onready var hardware = AGHardware.new()
var flashlight_state : bool = false

func _onToggleFlashlightButtonClicked():
	flashlight_state = not flashlight_state
	hardware.enable_flashlight(flashlight_state)
	

