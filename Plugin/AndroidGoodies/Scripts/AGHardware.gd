class_name AGHardware

var permissions = AGPermissions.new()

func enable_flashlight(enable : bool):
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		singleton.enableFlashlight(enable)
	else:
		print("No plugin singleton")
