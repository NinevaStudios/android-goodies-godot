class_name AGHardware

var permissions = AGPermissions.new()

enum ContentType { Unknown = 0, Speech = 1, Music = 2, Movie = 3, Sonification = 4 }

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
	
enum Flags { AudibilityEnforced = 0, HwAvSync = 16, LowLatency = 256 }

class BatteryStatus:
	const Unknown = 1
	const Charging = 2
	const Discharging = 3
	const NotCharging = 4
	const Full = 5
	
class BatteryHealth:
	const Unknown = 1
	const Good = 2
	const Overheat = 3
	const Dead = 4
	const OverVoltage = 5
	const UnspecifiedFailure = 6
	const Cold = 7
	
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

func enable_flashlight(enable : bool):
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		singleton.enableFlashlight(enable)
	else:
		print("No plugin singleton")

func has_vibrator() -> bool:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.hasVibrator()
	else:
		print("No plugin singleton")
		return false
		
func has_amplitude_control() -> bool:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.hasAmplitudeControl()
	else:
		print("No plugin singleton")
		return false
		
func vibrate(durations : PoolIntArray, amplitudes : PoolIntArray, repeat : int = -1, 
		usage = Usage.Unknown, flags = Flags.AudibilityEnforced, content_type = ContentType.Unknown):
	_durations = durations
	_amplitudes = amplitudes
	_repeat = repeat
	_usage = usage
	_flags = flags
	_content_type = content_type

	permissions.request_permission(AGPermissions.vibrate_permission, "_on_vibrate_permission_granted", self)
	
func stop_vibration():
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		singleton.stopVibration()
	else:
		print("No plugin singleton")
		
func compute_battery_charge_time_remaining() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.computeRemainingChargeTime()
	else:
		print("No plugin singleton")
		return -1
		
func get_battery_capacity() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryCapacity()
	else:
		print("No plugin singleton")
		return -1
		
func get_battery_charge_counter() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryChargeCounter()
	else:
		print("No plugin singleton")
		return -1
		
func get_average_battery_current() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getAverageBatteryCurrent()
	else:
		print("No plugin singleton")
		return -1
		
func get_battery_current() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryCurrent()
	else:
		print("No plugin singleton")
		return -1
		
func get_battery_energy_counter() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryEnergyCounter()
	else:
		print("No plugin singleton")
		return -1
		
func get_battery_status() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryStatus()
	else:
		print("No plugin singleton")
		return BatteryStatus.Unknown
		
func is_battery_low() -> bool:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.isBatteryLow()
	else:
		print("No plugin singleton")
		return false
		
func get_battery_health() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryHealth()
	else:
		print("No plugin singleton")
		return BatteryHealth.Unknown
		
func get_battery_level() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryLevel()
	else:
		print("No plugin singleton")
		return -1
		
func get_battery_plugged_state() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryPluggedState()
	else:
		print("No plugin singleton")
		return BatteryPluggedState.OnBattery
		
func is_battery_present() -> bool:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.isBatteryPresent()
	else:
		print("No plugin singleton")
		return false
		
func get_battery_scale() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryScale()
	else:
		print("No plugin singleton")
		return -1
		
func get_battery_technology() -> String:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryTechnology()
	else:
		print("No plugin singleton")
		return "Unknown"
		
func get_battery_temperature() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryTemperature()
	else:
		print("No plugin singleton")
		return -273
		
func get_battery_voltage() -> int:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		return singleton.getBatteryVoltage()
	else:
		print("No plugin singleton")
		return 0
		
func _on_vibrate_permission_granted(permission : String, granted : bool):
	if (permission == AGPermissions.vibrate_permission && granted):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		singleton.vibrate(_durations, _amplitudes, _repeat, _usage, _flags, _content_type)
