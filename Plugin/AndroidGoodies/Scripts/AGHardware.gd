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
		
func _on_vibrate_permission_granted(permission : String, granted : bool):
	if (permission == AGPermissions.vibrate_permission && granted):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		singleton.vibrate(_durations, _amplitudes, _repeat, _usage, _flags, _content_type)
