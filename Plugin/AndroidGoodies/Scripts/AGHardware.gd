# Class for interactions with device's hardware.
class_name AGHardware

var permissions = AGPermissions.new()

# Content types for vibration attributes.
enum ContentType { Unknown = 0, Speech = 1, Music = 2, Movie = 3, Sonification = 4 }

# Possible usages for vibration attributes.
enum Usage { 
		Unknown = 0, 
		Media = 1, 
		VoiceCommunication = 2,
		VoiceCommunicationSignalling = 3,
		Alarm = 4,
		Notification = 5,
		NotificationRingtone = 6,
		NotificationCommunicationRequest = 7,
		NotificationCommunicationInstant = 8,
		NotificationCommunicationDelayed = 9,
		NotificationEvent = 10,
		AssistanceAccessibility = 11,
		AssistanceNavigationGuidance = 12,
		AssistanceSonification = 13,
		Game = 14,
		VirtualSource = 15,
		Assistant = 16
	}
	
# Possible flags for vibration attributes
enum Flags { AudibilityEnforced = 0, HwAvSync = 16, LowLatency = 256 }

# Possible battery statuses.
class BatteryStatus:
	const Unknown = 1
	const Charging = 2
	const Discharging = 3
	const NotCharging = 4
	const Full = 5

# Possible battery health states.
class BatteryHealth:
	const Unknown = 1
	const Good = 2
	const Overheat = 3
	const Dead = 4
	const OverVoltage = 5
	const UnspecifiedFailure = 6
	const Cold = 7
	
# Possible battery plugged states.
class BatteryPluggedState:
	const OnBattery = 0
	const PluggedAc = 1
	const PluggedUsb = 2
	const PluggedWireless = 4

var _durations
var _amplitudes
var _repeat
var _usage
var _flags
var _content_type

# Enable or disable the camera flashlight.
func enable_flashlight(enable : bool):
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		singleton.enableFlashlight(enable)
	else:
		print("No plugin singleton")

# Check if device can vibrate.
func has_vibrator() -> bool:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.hasVibrator()
	else:
		print("No plugin singleton")
		return false

# Check whether the vibrator has amplitude control.
func has_amplitude_control() -> bool:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.hasAmplitudeControl()
	else:
		print("No plugin singleton")
		return false

# Vibrate with specified parameters.
# @param durations: array of intervals to split the vibration into (in milliseconds). 
# @param amplitudes: array of amplitudes for each interval (0-255). Lengths of the arrays have to be the same.
# @param repeat: the index of the element in the intervals array, from which to repeat the sequence, or -1 for a single playback.
# @param usage: one of the Usage constants.
# @param flags: one of the Flags constants.
# @param content_type: one of the ContentType constants.
func vibrate(durations : PoolIntArray, amplitudes : PoolIntArray, repeat : int = -1, 
		usage = Usage.Unknown, flags = Flags.AudibilityEnforced, content_type = ContentType.Unknown):
	_durations = durations
	_amplitudes = amplitudes
	_repeat = repeat
	_usage = usage
	_flags = flags
	_content_type = content_type

	permissions.request_permission(AGPermissions.vibrate_permission, "_on_vibrate_permission_granted", self)

# Stop the current vibration sequence (if any).
func stop_vibration():
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		singleton.stopVibration()
	else:
		print("No plugin singleton")

# The remaining battery charge time in seconds. Returns -1, on OS version <28 and if something went wrong.
func compute_battery_charge_time_remaining() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.computeRemainingChargeTime()
	else:
		print("No plugin singleton")
		return -1
		
# The current battery capacity (0 - 100 %). Returns -1, if something went wrong.
func get_battery_capacity() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryCapacity()
	else:
		print("No plugin singleton")
		return -1
		
# The battery capacity in micro ampere-hours, as an integer.
func get_battery_charge_counter() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryChargeCounter()
	else:
		print("No plugin singleton")
		return -1
		
# The average battery current in micro amperes, as an integer.
# Positive values indicate net current entering the battery from a charge source,
# negative values indicate net current discharging from the battery.
# The time period over which the average is computed may depend on the fuel gauge hardware and its configuration.
func get_average_battery_current() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getAverageBatteryCurrent()
	else:
		print("No plugin singleton")
		return -1
		
# Instantaneous battery current in micro amperes, as an integer.
# Positive values indicate net current entering the battery from a charge source,
# negative values indicate net current discharging from the battery.
func get_battery_current() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryCurrent()
	else:
		print("No plugin singleton")
		return -1
		
# Battery remaining energy in nano watt-hours. -1 if not supported.
func get_battery_energy_counter() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryEnergyCounter()
	else:
		print("No plugin singleton")
		return -1
		
# Battery charge status. One of the BatteryStatus constants.
func get_battery_status() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryStatus()
	else:
		print("No plugin singleton")
		return BatteryStatus.Unknown
		
# Whether the battery is currently considered to be low,
# that is whether an Intent.ActionBatteryLow broadcast has been sent.
func is_battery_low() -> bool:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.isBatteryLow()
	else:
		print("No plugin singleton")
		return false
		
# Current BatteryHealth constant.
func get_battery_health() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryHealth()
	else:
		print("No plugin singleton")
		return BatteryHealth.Unknown
		
# The current battery level, from 0 to "get_battery_scale()". -1 if something went wrong.
func get_battery_level() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryLevel()
	else:
		print("No plugin singleton")
		return -1
		
# One of the BatteryPluggedState values indicating whether the device is plugged in to a power source.
func get_battery_plugged_state() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryPluggedState()
	else:
		print("No plugin singleton")
		return BatteryPluggedState.OnBattery
		
# Whether a battery is present.
func is_battery_present() -> bool:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.isBatteryPresent()
	else:
		print("No plugin singleton")
		return false
		
# The maximum battery level. -1 if something went wrong.
func get_battery_scale() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryScale()
	else:
		print("No plugin singleton")
		return -1
		
# The technology of the current battery.
func get_battery_technology() -> String:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryTechnology()
	else:
		print("No plugin singleton")
		return "Unknown"
		
# The current battery temperature in the tenth parts of a Celcius degree.
func get_battery_temperature() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryTemperature()
	else:
		print("No plugin singleton")
		return -273
		
# The current battery voltage level in milli-volts.
func get_battery_voltage() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryVoltage()
	else:
		print("No plugin singleton")
		return 0

# Helper functions. Do not use them directly.

func _on_vibrate_permission_granted(permission : String, granted : bool):
	if (permission == AGPermissions.vibrate_permission && granted):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		singleton.vibrate(_durations, _amplitudes, _repeat, _usage, _flags, _content_type)
