extends Node

var device_info = AGDeviceInfo.new()
var build = AGDeviceInfo.Build.new()
var build_version = AGDeviceInfo.Build.Version.new()

onready var text = get_node("InfoText") as RichTextLabel

func _ready():
	var info = String()
	
	info = _append_build_info(info)
	info = _append_features(info)
	
	text.text = info
	
func _append_build_info(info : String) -> String:
	var package_name = device_info.get_package_name()
	info += "Package name: " + package_name + "\n"
	info += "Is package installed: " + String(device_info.is_package_installed(package_name)) + "\n"
	
	info += "Build Version: \n"
	info += "SDK int: " + String(build_version.sdk_int()) + "\n"
	info += "Base OS: " + build_version.base_os() + "\n"
	info += "Codename: " + build_version.codename() + "\n"
	info += "Release: " + build_version.release() + "\n"
	
	info += "Build: \n"
	info += "Board: " + build.board() + "\n"
	info += "Bootloader: " + build.bootloader() + "\n"
	info += "Brand: " + build.brand() + "\n"
	info += "Device: " + build.device() + "\n"
	info += "Display: " + build.display() + "\n"
	info += "Hardware: " + build.hardware() + "\n"
	info += "Manufacturer: " + build.manufacturer() + "\n"
	info += "Model: " + build.model() + "\n"
	info += "Product: " + build.product() + "\n"
	info += "Radio version: " + build.radio_version() + "\n"
	info += "Tags: " + build.tags() + "\n"
	info += "Type: " + build.type() + "\n"
	
	return info
	
func _append_features(info : String) -> String:
	info += "Features: \n"
	info += _text_for_feature(AGDeviceInfo.SystemFeature.APP_WIDGETS)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.AUDIO_LOW_LATENCY)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.AUDIO_OUTPUT)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.AUDIO_PRO)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.BLUETOOTH)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.BLUETOOTH_LE)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.CAMERA)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.CAMERA_AUTOFOCUS)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.CAMERA_ANY)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.CAMERA_EXTERNAL)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.CAMERA_FLASH)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.CAMERA_FRONT)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.CAMERA_LEVEL_FULL)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.CAMERA_CAPABILITY_MANUAL_SENSOR)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.CAMERA_CAPABILITY_MANUAL_POST_PROCESSING)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.CAMERA_CAPABILITY_RAW)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.CONSUMER_IR)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.LOCATION)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.LOCATION_GPS)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.LOCATION_NETWORK)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.MICROPHONE)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.NFC)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.NFC_HCE)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.NFC_HOST_CARD_EMULATION)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.OPENGLES_EXTENSION_PACK)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SENSOR_ACCELEROMETER)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SENSOR_BAROMETER)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SENSOR_COMPASS)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SENSOR_GYROSCOPE)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SENSOR_LIGHT)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SENSOR_PROXIMITY)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SENSOR_STEP_COUNTER)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SENSOR_STEP_DETECTOR)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SENSOR_HEART_RATE)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SENSOR_HEART_RATE_ECG)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SENSOR_RELATIVE_HUMIDITY)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SENSOR_AMBIENT_TEMPERATURE)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.HIFI_SENSORS)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.TELEPHONY)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.TELEPHONY_CDMA)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.TELEPHONY_GSM)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.USB_HOST)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.USB_ACCESSORY)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SIP)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SIP_VOIP)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.CONNECTION_SERVICE)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.TOUCHSCREEN)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.TOUCHSCREEN_MULTITOUCH)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.TOUCHSCREEN_MULTITOUCH_DISTINCT)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.TOUCHSCREEN_MULTITOUCH_JAZZHAND)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.FAKETOUCH)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.FAKETOUCH_MULTITOUCH_DISTINCT)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.FAKETOUCH_MULTITOUCH_JAZZHAND)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.FINGERPRINT)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SCREEN_PORTRAIT)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SCREEN_LANDSCAPE)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.LIVE_WALLPAPER)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.APP_WIDGETS)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.VOICE_RECOGNIZERS)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.HOME_SCREEN)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.INPUT_METHODS)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.DEVICE_ADMIN)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.LEANBACK)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.LEANBACK_ONLY)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.LIVE_TV)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.WIFI)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.WIFI_DIRECT)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.AUTOMOTIVE)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.WATCH)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.PRINTING)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.BACKUP)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.MANAGED_USERS)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.MANAGED_PROFILES)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.VERIFIED_BOOT)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.SECURELY_REMOVES_USERS)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.WEBVIEW)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.ETHERNET)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.HDMI_CEC)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.GAMEPAD)
	info += _text_for_feature(AGDeviceInfo.SystemFeature.MIDI)
	
	return info

func _text_for_feature(feature : String) -> String:
	return feature + ": " + String(device_info.has_system_feature(feature)) + "\n"
