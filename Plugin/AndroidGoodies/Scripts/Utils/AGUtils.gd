class_name AGUtils

const plugin_name = "AndroidGoodies"

func disconnect_callback_if_connected(singleton, signal_name, callback_object, callback_name):
	if callback_object != null && singleton.is_connected(signal_name, callback_object, callback_name):
		singleton.disconnect(signal_name, callback_object, callback_name)
