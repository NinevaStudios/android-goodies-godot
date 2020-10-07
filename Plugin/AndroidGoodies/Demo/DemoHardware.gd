extends Node

onready var hardware = AGHardware.new()
var flashlight_state : bool = false

func _onToggleFlashlightButtonClicked():
	flashlight_state = not flashlight_state
	hardware.enable_flashlight(flashlight_state)

func _onVibrateButtonClicked():
	if (hardware.has_vibrator()):
		var intervals = [ 100, 200, 300, 400, 500]
		var amplitudes = [ 255, 0, 255, 0 , 255]
		hardware.vibrate(intervals, amplitudes)
	else:
		print("Device can not vibrate")

func _onStopVibrateButtonClicked():
	hardware.stop_vibration()
