extends Node

class_name DemoHardware

onready var hardware = AGHardware.new()
onready var battery_info_text = get_node("BatteryInfoText") as RichTextLabel

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

func print_battery_info():
	var info = "Battery info: \n"
	
	if (hardware.is_battery_present()):
		info += _get_battery_status()
		info += _get_battery_health()
		info += _get_battery_plugged_state()
		info += "Current: " + String(hardware.get_battery_current() / 1000000.0) + " A\n"
		info += "Average current: " + String(hardware.get_battery_current() / 1000000.0) + " A\n"
		info += "Capacity: " + String(hardware.get_battery_capacity()) + " %\n"
		info += "Energy counter: " + String(hardware.get_battery_charge_counter()) + " nW⋅h\n"
		info += "Is low: " + String(hardware.is_battery_low()) + "\n"
		info += "Level: " + String(hardware.get_battery_level()) + "/" + String(hardware.get_battery_scale()) + "\n"
		info += "Technology: " + hardware.get_battery_technology() + "\n"
		info += "Temperature: " + String(hardware.get_battery_temperature() / 10.0) + " C\n"
		info += "Voltage: " + String(hardware.get_battery_voltage() / 1000.0) + " V\n"
	else:
		info = "Battery is not present. No data available."
	
	battery_info_text.text = info

func _get_battery_status() -> String:
	var status_int = hardware.get_battery_status()
	var result = "Status: "
	
	match status_int:
		AGHardware.BatteryStatus.Unknown:
			result += "Unknown"
		AGHardware.BatteryStatus.Charging:
			result += "Charging"
		AGHardware.BatteryStatus.Discharging:
			result += "Discharging"
		AGHardware.BatteryStatus.Full:
			result += "Full"
		AGHardware.BatteryStatus.NotCharging:
			result += "Not Charging"
			
	result += "\n"
	return result

func _get_battery_health() -> String:
	var status_int = hardware.get_battery_health()
	var result = "Health: "
	
	match status_int:
		AGHardware.BatteryHealth.Unknown:
			result += "Unknown"
		AGHardware.BatteryHealth.Good:
			result += "Good"
		AGHardware.BatteryHealth.Overheat:
			result += "Overheat"
		AGHardware.BatteryHealth.OverVoltage:
			result += "OverVoltage"
		AGHardware.BatteryHealth.Cold:
			result += "Cold"
		AGHardware.BatteryHealth.Dead:
			result += "Dead"
		AGHardware.BatteryHealth.UnspecifiedFailure:
			result += "Unspecified Failure"
	result += "\n"
	return result
	
func _get_battery_plugged_state() -> String:
	var status_int = hardware.get_battery_plugged_state()
	var result = "Plugged state: "
	
	match status_int:
		AGHardware.BatteryPluggedState.OnBattery:
			result += "On Battery"
		AGHardware.BatteryPluggedState.PluggedAc:
			result += "Plugged AC"
		AGHardware.BatteryPluggedState.PluggedUsb:
			result += "Plugged USB"
		AGHardware.BatteryPluggedState.PluggedWireless:
			result += "Plugged Wireless"
	result += "\n"
	return result
