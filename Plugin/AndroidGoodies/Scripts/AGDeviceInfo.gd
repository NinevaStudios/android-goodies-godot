# Class for getting the device-specific information.
class_name AGDeviceInfo

# Check if the device supports one of the SystemFeature items.
func has_system_feature(feature : String) -> bool:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		return singleton.hasSystemFeature(feature)
	else:
		print("No plugin singleton")
		return false

# Get application package name.
func get_package_name() -> String:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		return singleton.getApplicationPackageName()
	else:
		print("No plugin singleton")
		return ""

# Check if the provided package is installed on the device.
func is_package_installed(package_name : String) -> bool:
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		return singleton.isPackageInstalled(package_name)
	else:
		print("No plugin singleton")
		return false

# Container of the different system features that can be checked via "has_system_feature".
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

# Holder for the android version codes (possible values for "Build.Version.sdk_int()"
class VersionCodes:
	const BASE = 1
	const BASE_1_1 = 2
	const CUPCAKE = 3
	const DONUT = 4
	const ECLAIR = 5
	const ECLAIR_0_1 = 6
	const ECLAIR_MR1 = 7
	const FROYO = 8
	const GINGERBREAD = 9
	const GINGERBREAD_MR1 = 10
	const HONEYCOMB = 11
	const HONEYCOMB_MR1 = 12
	const HONEYCOMB_MR2 = 13
	const ICE_CREAM_SANDWICH = 14
	const ICE_CREAM_SANDWICH_MR1 = 15
	const JELLY_BEAN = 16
	const JELLY_BEAN_MR1 = 17
	const JELLY_BEAN_MR2 = 18
	const KITKAT = 19
	const KITKAT_WATCH = 20
	const LOLLIPOP = 21
	const LOLLIPOP_MR1 = 22
	const M = 23
	const N = 24
	const N_MR1 = 25
	const O = 26
	const O_MR1 = 27
	const P = 28
	const Q = 29

# Information about the current build, extracted from system properties.
class Build:
	# The name of the underlying board, like "goldfish".
	func board() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildBoard()
		else:
			print("No plugin singleton")
			return ""
	
	# The system bootloader version number.
	func bootloader() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildBootloader()
		else:
			print("No plugin singleton")
			return ""
	
	# The consumer-visible brand with which the product/hardware will be associated, if any.
	func brand() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildBrand()
		else:
			print("No plugin singleton")
			return ""
	
	# The name of the industrial design. 
	func device() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildDevice()
		else:
			print("No plugin singleton")
			return ""
	
	# A build ID string meant for displaying to the user.
	func display() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildDisplay()
		else:
			print("No plugin singleton")
			return ""
			
	# The name of the hardware (from the kernel command line or /proc).
	func hardware() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildHardware()
		else:
			print("No plugin singleton")
			return ""
			
	# The manufacturer of the product/hardware.
	func manufacturer() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildManufacturer()
		else:
			print("No plugin singleton")
			return ""
			
	# The end-user-visible name for the end product. 
	func model() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildModel()
		else:
			print("No plugin singleton")
			return ""
			
	# The name of the overall product. 
	func product() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildProduct()
		else:
			print("No plugin singleton")
			return ""
			
	# Returns the version string for the radio firmware.  
	# May return null (if, for instance, the radio is not currently on).
	func radio_version() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildRadioVersion()
		else:
			print("No plugin singleton")
			return ""
			
	# Comma-separated tags describing the build, like "unsigned,debug".
	func tags() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildTags()
		else:
			print("No plugin singleton")
			return ""
			
	# The type of build, like "user" or "eng".
	func type() -> String:
		if Engine.has_singleton(AGUtils.plugin_name):
			var singleton = Engine.get_singleton(AGUtils.plugin_name)
			return singleton.getBuildType()
		else:
			print("No plugin singleton")
			return ""
			
	# Various version strings.
	class Version:
		# The SDK version of the software currently running on this hardware device.
		# Possible values are defined in VersionCodes.
		func sdk_int() -> int:
			if Engine.has_singleton(AGUtils.plugin_name):
				var singleton = Engine.get_singleton(AGUtils.plugin_name)
				return singleton.getBuildVersionSdkInt()
			else:
				print("No plugin singleton")
				return 0
				
		# The base OS build the product is based on.
		func base_os() -> String:
			if Engine.has_singleton(AGUtils.plugin_name) and sdk_int() >= VersionCodes.M:
				var singleton = Engine.get_singleton(AGUtils.plugin_name)
				return singleton.getBuildVersionBaseOs()
			else:
				return ""
				
		# A build ID string meant for displaying to the user.
		func codename() -> String:
			if Engine.has_singleton(AGUtils.plugin_name):
				var singleton = Engine.get_singleton(AGUtils.plugin_name)
				return singleton.getBuildVersionCodeName()
			else:
				print("No plugin singleton")
				return ""
				
		# The user-visible version string.  E.g., "1.0" or "3.4b5" or "bananas".
		func release() -> String:
			if Engine.has_singleton(AGUtils.plugin_name):
				var singleton = Engine.get_singleton(AGUtils.plugin_name)
				return singleton.getBuildVersionRelease()
			else:
				print("No plugin singleton")
				return ""

