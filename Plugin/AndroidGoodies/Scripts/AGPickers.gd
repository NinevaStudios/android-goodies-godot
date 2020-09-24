class_name AGPickers

const _picked_images_signal_name = "onImagesPicked"
const _picked_videos_signal_name = "onVideosPicked"
const _picked_files_signal_name = "onFilesPicked"
const _picked_audio_signal_name = "onAudioPicked"
const _pick_error_signal_name = "onPickError"

const pick_from_gallery = 1
const pick_from_camera = 0

var _images_picked_callback_name = ""
var _images_picked_callback_object = null
var _videos_picked_callback_name = ""
var _videos_picked_callback_object = null

var _pick_error_callback_name = ""
var _pick_error_callback_object = null

var _max_size : int
var _generate_thumbnails : bool

var utils = AGUtils.new()
var permissions = AGPermissions.new()

class PickedFile:
	var original_path = ""
	var created_at = 0
	var display_name = ""
	var extension = ""
	var mime_type = ""
	var size = 0
	
class PickedImage extends PickedFile:
	var image_orientation : int
	
class PickedVideo extends PickedFile:
	var video_duration = 0
	var video_height = 0
	var video_width = 0
	var video_orientation = 0
	var video_preview_image_path = ""
	
class PickedAudio extends PickedFile:
	var audio_duration = 0
	
const orientation_normal = 1
const orientation_rotate_90 = 6
const orientation_rotate_180 = 3
const orientation_rotate_270 = 8

# API functions

func pick_image_from_gallery(max_size : int, generate_thumbnails : bool, allow_multiple : bool, images_picked_callback_name : String, 
		images_picked_callback_object : Object, pick_error_callback_name : String, pick_error_callback_object : Object):
	_images_picked_callback_name = images_picked_callback_name
	_images_picked_callback_object = images_picked_callback_object
	_pick_error_callback_name = pick_error_callback_name
	_pick_error_callback_object = pick_error_callback_object
	
	_max_size = max_size
	_generate_thumbnails = generate_thumbnails
	
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		_connect_images_picked_callback(singleton)
		_connect_pick_error_callback(singleton)
		
		singleton.pickImages(pick_from_gallery, max_size, generate_thumbnails, allow_multiple)
	else:
		print("No plugin singleton")

func take_photo(max_size : int, generate_thumbnails : bool, images_picked_callback_name : String, images_picked_callback_object : Object,
		pick_error_callback_name : String, pick_error_callback_object : Object):
	_images_picked_callback_name = images_picked_callback_name
	_images_picked_callback_object = images_picked_callback_object
	_pick_error_callback_name = pick_error_callback_name
	_pick_error_callback_object = pick_error_callback_object
	
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		_connect_images_picked_callback(singleton)
		_connect_pick_error_callback(singleton)
		
		permissions.request_permission(AGPermissions.camera_permission, "_on_camera_permission_granted", self)
	else:
		print("No plugin singleton")

func pick_videos(generate_preview_images : bool, allow_multiple : bool, 
		videos_picked_callback_name : String, videos_picked_callback_object : Object,
		pick_error_callback_name : String, pick_error_callback_object : Object):
			
	_videos_picked_callback_name = videos_picked_callback_name
	_videos_picked_callback_object = videos_picked_callback_object
	_pick_error_callback_name = pick_error_callback_name
	_pick_error_callback_object = pick_error_callback_object
	
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		_connect_videos_picked_callback(singleton)
		_connect_pick_error_callback(singleton)
		
		singleton.pickVideos(pick_from_gallery, generate_preview_images, allow_multiple)
	else:
		print("No plugin singleton")

# Helper functions. Do not call them directly.

func _connect_images_picked_callback(singleton):
	singleton.connect(_picked_images_signal_name, self, "_on_images_picked")
	
func _on_images_picked(images):
	var picked_images = Array()
	for i in images.size():
		var picked_image = PickedImage.new()
		_set_chosen_file_fields(picked_image, images[i])
		picked_image.image_orientation = images[i].get("image_orientation")
		picked_images.append(picked_image)
	
	_images_picked_callback_object.call(_images_picked_callback_name, picked_images)
	_disconnect_callbacks()
	
func _connect_videos_picked_callback(singleton):
	singleton.connect(_picked_videos_signal_name, self, "_on_videos_picked")
	
func _on_videos_picked(videos):
	var picked_videos = Array()
	for i in videos.size():
		var picked_video = PickedVideo.new()
		_set_chosen_file_fields(picked_video, videos[i])
		picked_video.video_orientation = videos[i].get("video_orientation")
		picked_video.video_duration = videos[i].get("video_duration")
		picked_video.video_height = videos[i].get("video_height")
		picked_video.video_width = videos[i].get("video_width")
		picked_video.video_preview_image_path = videos[i].get("video_preview_image_path")
		picked_videos.append(picked_video)
	
	_videos_picked_callback_object.call(_videos_picked_callback_name, picked_videos)
	_disconnect_callbacks()
	
func _connect_pick_error_callback(singleton):
	singleton.connect(_pick_error_signal_name, self, "_on_pick_error")
	
func _on_pick_error(error):
	_pick_error_callback_object.call(_pick_error_callback_name, error)
	_disconnect_callbacks()
	
func _disconnect_callbacks():
	var singleton = Engine.get_singleton(AGUtils.plugin_name)
	
	utils.disconnect_callback_if_connected(singleton, _picked_images_signal_name, self, "_on_images_picked")
	utils.disconnect_callback_if_connected(singleton, _picked_videos_signal_name, self, "_on_videos_picked")
	utils.disconnect_callback_if_connected(singleton, _pick_error_signal_name, self, "_on_pick_error")

func _set_chosen_file_fields(file, file_dictionary) -> PickedFile:
	file.original_path = file_dictionary.get("original_path")
	file.created_at = file_dictionary.get("created_at")
	file.display_name = file_dictionary.get("display_name")
	file.extension = file_dictionary.get("extension")
	file.mime_type = file_dictionary.get("mime_type")
	file.size = file_dictionary.get("size")
	
	return file

func _on_camera_permission_granted(permission : String, granted : bool):
	if (permission == AGPermissions.camera_permission && granted):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		singleton.pickImages(pick_from_camera, _max_size, _generate_thumbnails, false)
	else:
		_on_pick_error("Permission was not granted")
