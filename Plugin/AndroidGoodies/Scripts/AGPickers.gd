class_name AGPickers

const plugin_name = "AndroidGoodies"

const picked_images_signal_name = "onImagesPicked"
const picked_videos_signal_name = "onVideosPicked"
const picked_files_signal_name = "onFilesPicked"
const picked_audio_signal_name = "onAudioPicked"
const pick_error_signal_name = "onPickError"

const pick_from_gallery = 1
const pick_from_camera = 0

var _images_picked_callback_name = ""
var _images_picked_callback_object = null

var _pick_error_callback_name = ""
var _pick_error_callback_object = null

var utils = AGUtils.new()

# API functions

func pick_image_from_gallery(max_size, generate_thumbnails, allow_multiple, images_picked_callback_name, 
		images_picked_callback_object, pick_error_callback_name, pick_error_callback_object):
	_images_picked_callback_name = images_picked_callback_name
	_images_picked_callback_object = images_picked_callback_object
	_pick_error_callback_name = pick_error_callback_name
	_pick_error_callback_object = pick_error_callback_object
	
	if Engine.has_singleton(plugin_name):
		var singleton = Engine.get_singleton(plugin_name)
		
		_connect_images_picked_callback(singleton)
		_connect_pick_error_callback(singleton)
		
		singleton.pickImages(pick_from_gallery, max_size, generate_thumbnails, allow_multiple)
	else:
		print("No plugin singleton")
		
# Helper functions. Do not call them directly.

func _connect_images_picked_callback(singleton):
	singleton.connect(picked_images_signal_name, self, "_on_images_picked")
	
func _on_images_picked(images):
	_images_picked_callback_object.call(_images_picked_callback_name, images)
	_disconnect_callbacks()
	
func _connect_pick_error_callback(singleton):
	singleton.connect(pick_error_signal_name, self, "_on_pick_error")
	
func _on_pick_error(error):
	_pick_error_callback_object.call(_pick_error_callback_name, error)
	_disconnect_callbacks()
	
func _disconnect_callbacks():
	var singleton = Engine.get_singleton(plugin_name)
	
	utils.disconnect_callback_if_connected(singleton, picked_images_signal_name, self, "_on_images_picked")
	utils.disconnect_callback_if_connected(singleton, pick_error_signal_name, self, "_on_pick_error")
