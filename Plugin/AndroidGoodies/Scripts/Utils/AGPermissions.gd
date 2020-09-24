class_name AGPermissions

const camera_permission = "android.permission.CAMERA"

const _permission_granted_signal_name = "onPermissionGranted"

var _permission_granted_callback_name : String = ""
var _permission_granted_callback_object : Object = null

var utils = AGUtils.new()

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
	_permission_granted_callback_object.call(_permission_granted_callback_name, permission, granted)
