class_name AGDeviceInfo

func has_system_feature(feature : String) -> bool:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		return singleton.hasSystemFeature(feature)
	else:
		print("No plugin singleton")
		return false
		
func get_package_name() -> String:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		return singleton.getApplicationPackageName()
	else:
		print("No plugin singleton")
		return ""

func is_package_installed(package_name : String) -> bool:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		return singleton.isPackageInstalled(package_name)
	else:
		print("No plugin singleton")
		return false

class SystemFeature:
	const AUDIO_LOW_LATENCY = "android.hardware.audio.low_latency" 
	const AUDIO_OUTPUT = "android.hardware.audio.output" 
	const AUDIO_PRO = "android.hardware.audio.pro" 
	const BLUETOOTH = "android.hardware.bluetooth" 
	const BLUETOOTH_LE = "android.hardware.bluetooth_le" 
	const CAMERA = "android.hardware.camera" 
	const CAMERA_AUTOFOCUS = "android.hardware.camera.autofocus" 
	const CAMERA_ANY = "android.hardware.camera.any" 
	const CAMERA_EXTERNAL = "android.hardware.camera.external" 
	const CAMERA_FLASH = "android.hardware.camera.flash" 
	const CAMERA_FRONT = "android.hardware.camera.front" 
	const CAMERA_LEVEL_FULL = "android.hardware.camera.level.full" 
	const CAMERA_CAPABILITY_MANUAL_SENSOR = "android.hardware.camera.capability.manual_sensor" 
	const CAMERA_CAPABILITY_MANUAL_POST_PROCESSING = "android.hardware.camera.capability.manual_post_processing" 
	const CAMERA_CAPABILITY_RAW = "android.hardware.camera.capability.raw" 
	const CONSUMER_IR = "android.hardware.consumerir" 
	const LOCATION = "android.hardware.location" 
	const LOCATION_GPS = "android.hardware.location.gps" 
	const LOCATION_NETWORK = "android.hardware.location.network" 
	const MICROPHONE = "android.hardware.microphone" 
	const NFC = "android.hardware.nfc" 
	const NFC_HCE = "android.hardware.nfc.hce" 
	const NFC_HOST_CARD_EMULATION = "android.hardware.nfc.hce" 
	const OPENGLES_EXTENSION_PACK = "android.hardware.opengles.aep" 
	const SENSOR_ACCELEROMETER = "android.hardware.sensor.accelerometer" 
	const SENSOR_BAROMETER = "android.hardware.sensor.barometer" 
	const SENSOR_COMPASS = "android.hardware.sensor.compass" 
	const SENSOR_GYROSCOPE = "android.hardware.sensor.gyroscope" 
	const SENSOR_LIGHT = "android.hardware.sensor.light" 
	const SENSOR_PROXIMITY = "android.hardware.sensor.proximity" 
	const SENSOR_STEP_COUNTER = "android.hardware.sensor.stepcounter" 
	const SENSOR_STEP_DETECTOR = "android.hardware.sensor.stepdetector" 
	const SENSOR_HEART_RATE = "android.hardware.sensor.heartrate" 
	const SENSOR_HEART_RATE_ECG = "android.hardware.sensor.heartrate.ecg" 
	const SENSOR_RELATIVE_HUMIDITY = "android.hardware.sensor.relative_humidity" 
	const SENSOR_AMBIENT_TEMPERATURE = "android.hardware.sensor.ambient_temperature" 
	const HIFI_SENSORS = "android.hardware.sensor.hifi_sensors" 
	const TELEPHONY = "android.hardware.telephony" 
	const TELEPHONY_CDMA = "android.hardware.telephony.cdma" 
	const TELEPHONY_GSM = "android.hardware.telephony.gsm" 
	const USB_HOST = "android.hardware.usb.host" 
	const USB_ACCESSORY = "android.hardware.usb.accessory" 
	const SIP = "android.software.sip" 
	const SIP_VOIP = "android.software.sip.voip" 
	const CONNECTION_SERVICE = "android.software.connectionservice" 
	const TOUCHSCREEN = "android.hardware.touchscreen" 
	const TOUCHSCREEN_MULTITOUCH = "android.hardware.touchscreen.multitouch" 
	const TOUCHSCREEN_MULTITOUCH_DISTINCT = "android.hardware.touchscreen.multitouch.distinct" 
	const TOUCHSCREEN_MULTITOUCH_JAZZHAND = "android.hardware.touchscreen.multitouch.jazzhand" 
	const FAKETOUCH = "android.hardware.faketouch" 
	const FAKETOUCH_MULTITOUCH_DISTINCT = "android.hardware.faketouch.multitouch.distinct" 
	const FAKETOUCH_MULTITOUCH_JAZZHAND = "android.hardware.faketouch.multitouch.jazzhand" 
	const FINGERPRINT = "android.hardware.fingerprint" 
	const SCREEN_PORTRAIT = "android.hardware.screen.portrait" 
	const SCREEN_LANDSCAPE = "android.hardware.screen.landscape" 
	const LIVE_WALLPAPER = "android.software.live_wallpaper" 
	const APP_WIDGETS = "android.software.app_widgets" 
	const VOICE_RECOGNIZERS = "android.software.voice_recognizers" 
	const HOME_SCREEN = "android.software.home_screen" 
	const INPUT_METHODS = "android.software.input_methods" 
	const DEVICE_ADMIN = "android.software.device_admin" 
	const LEANBACK = "android.software.leanback" 
	const LEANBACK_ONLY = "android.software.leanback_only" 
	const LIVE_TV = "android.software.live_tv" 
	const WIFI = "android.hardware.wifi" 
	const WIFI_DIRECT = "android.hardware.wifi.direct" 
	const AUTOMOTIVE = "android.hardware.type.automotive" 
	const WATCH = "android.hardware.type.watch" 
	const PRINTING = "android.software.print" 
	const BACKUP = "android.software.backup" 
	const MANAGED_USERS = "android.software.managed_users" 
	const MANAGED_PROFILES = "android.software.managed_users" 
	const VERIFIED_BOOT = "android.software.verified_boot" 
	const SECURELY_REMOVES_USERS = "android.software.securely_removes_users" 
	const WEBVIEW = "android.software.webview" 
	const ETHERNET = "android.hardware.ethernet" 
	const HDMI_CEC = "android.hardware.hdmi.cec" 
	const GAMEPAD = "android.hardware.gamepad" 
	const MIDI = "android.software.midi" 
	
class VersionCodes:
	const BASE = 1
	const BASE_1_1 = 2
	const CUPCAKE = 1
	const DONUT = 1
	const ECLAIR = 1
	const ECLAIR_0_1 = 1
	const ECLAIR_MR1 = 1
	const FROYO = 1
	const GINGERBREAD = 1
	const GINGERBREAD_MR1 = 1
	const HONEYCOMB = 1
	const HONEYCOMB_MR1 = 1
	const HONEYCOMB_MR2 = 1
	const ICE_CREAM_SANDWICH = 1
	const ICE_CREAM_SANDWICH_MR1 = 1
	const JELLY_BEAN = 1
	const JELLY_BEAN_MR1 = 1
	const JELLY_BEAN_MR2 = 1
	const KITKAT = 1
	const KITKAT_WATCH = 1
	const LOLLIPOP = 1
	const LOLLIPOP_MR1 = 1
	const M = 1
	const N = 1
	const N_MR1 = 1
	const O = 1
	const O_MR1 = 1
	const P = 1
	const Q = 1
	
class Build:
	func board() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildBoard()
		else:
			print("No plugin singleton")
			return ""
			
	func bootloader() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildBootloader()
		else:
			print("No plugin singleton")
			return ""
			
	func brand() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildBrand()
		else:
			print("No plugin singleton")
			return ""
			
	func device() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildDevice()
		else:
			print("No plugin singleton")
			return ""
			
	func display() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildDisplay()
		else:
			print("No plugin singleton")
			return ""
			
	func hardware() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildHardware()
		else:
			print("No plugin singleton")
			return ""
			
	func manufacturer() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildManufacturer()
		else:
			print("No plugin singleton")
			return ""
			
	func model() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildModel()
		else:
			print("No plugin singleton")
			return ""
			
	func product() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildProduct()
		else:
			print("No plugin singleton")
			return ""
			
	func radio_version() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildRadioVersion()
		else:
			print("No plugin singleton")
			return ""
			
	func serial() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildSerial()
		else:
			print("No plugin singleton")
			return ""
			
	func tags() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildTags()
		else:
			print("No plugin singleton")
			return ""
			
	func type() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildType()
		else:
			print("No plugin singleton")
			return ""
			
	class Version:
		func sdk_int() -> int:
			if Engine.has_singleton(AGUtils.plugin_name):
				var singleton = Engine.get_singleton(AGUtils.plugin_name)
				return singleton.getBuildVersionSdkInt()
			else:
				print("No plugin singleton")
				return 0
				
		func base_os() -> String:
			if Engine.has_singleton(AGUtils.plugin_name) and sdk_int() >= VersionCodes.M:
				var singleton = Engine.get_singleton(AGUtils.plugin_name)
				return singleton.getBuildVersionBaseOs()
			else:
				return ""
				
		func codename() -> String:
			if Engine.has_singleton(AGUtils.plugin_name):
				var singleton = Engine.get_singleton(AGUtils.plugin_name)
				return singleton.getBuildVersionCodeName()
			else:
				print("No plugin singleton")
				return ""
				
		func release() -> String:
			if Engine.has_singleton(AGUtils.plugin_name):
				var singleton = Engine.get_singleton(AGUtils.plugin_name)
				return singleton.getBuildVersionRelease()
			else:
				print("No plugin singleton")
				return ""

