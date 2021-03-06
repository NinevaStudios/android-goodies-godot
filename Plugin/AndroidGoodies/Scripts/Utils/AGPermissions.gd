class_name AGPermissions

const camera_permission = "android.permission.CAMERA"
const write_storage_permission = "android.permission.WRITE_EXTERNAL_STORAGE"
const send_sms_permission = "android.permission.SEND_SMS"
const vibrate_permission = "android.permission.VIBRATE"

const _permission_granted_signal_name = "onPermissionGranted"

var _permission_granted_callback_name : String = ""
var _permission_granted_callback_object : Object = null

var utils = AGUtils.new()

# Request system permission during application runtime.
#
# @param permission: the system string representing the specific permission.
# @param callback_name: name of the callback function to be invoked when the user responds to the permission request.
# 		Function signature: (String, bool)
# @param permission: object on which the callback_name function is invoked when the user responds to the permission request.
func request_permission(permission : String, callback_name : String, callback_object : Object):
	_permission_granted_callback_name = callback_name
	_permission_granted_callback_object = callback_object
	
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		utils.disconnect_callback_if_connected(singleton, _permission_granted_signal_name, self, "_on_permission_granted")
		_connect_on_permission_granted(singleton)
		
		singleton.requestPermission(permission)
	else:
		print("No plugin singleton")

func _connect_on_permission_granted(singleton):
	singleton.connect(_permission_granted_signal_name, self, "_on_permission_granted")
	
func _on_permission_granted(permission : String, granted : bool):
	print("Permission " + permission + " grant result: " + String(granted))
	_permission_granted_callback_object.call(_permission_granted_callback_name, permission, granted)
