class_name AGPickers

const _picked_images_signal_name = "onImagesPicked"
const _picked_videos_signal_name = "onVideosPicked"
const _picked_files_signal_name = "onFilesPicked"
const _picked_audio_signal_name = "onAudioPicked"
const _image_saved_signal_name = "onImageSaved"
const _pick_error_signal_name = "onPickError"

const pick_from_gallery = 1
const pick_from_camera = 0

var _images_picked_callback_name = ""
var _images_picked_callback_object = null
var _videos_picked_callback_name = ""
var _videos_picked_callback_object = null
var _audio_picked_callback_name = ""
var _audio_picked_callback_object = null
var _files_picked_callback_name = ""
var _files_picked_callback_object = null
var _image_saved_callback_name = ""
var _image_saved_callback_object = null

var _pick_error_callback_name = ""
var _pick_error_callback_object = null

var _max_size : int
var _generate_thumbnails : bool
var _generate_preview_images : bool

var _filename : String
var _image_to_save : Image

var utils = AGUtils.new()
var permissions = AGPermissions.new()

# An object representing a picked file.
class PickedFile:
	var original_path = ""
	var created_at = 0
	var display_name = ""
	var extension = ""
	var mime_type = ""
	var size = 0

# An object representing a picked image. Has all the fields of the PickedFile, as well.
class PickedImage extends PickedFile:
	var image_orientation : int
	
# An object representing a picked video. Has all the fields of the PickedFile, as well.
class PickedVideo extends PickedFile:
	var video_duration = 0
	var video_height = 0
	var video_width = 0
	var video_orientation = 0
	var video_preview_image_path = ""

# An object representing a picked audio. Has all the fields of the PickedFile, as well.
class PickedAudio extends PickedFile:
	var audio_duration = 0

const orientation_normal = 1
const orientation_rotate_90 = 6
const orientation_rotate_180 = 3
const orientation_rotate_270 = 8

# API functions

# Pick image from gallery.
#
# @param max_size: size of the resulting image (pick smaller value to save memory). Pass value <=0 to keep original size.
# @param generate_thumbnails: flag that indicates whether to generate thumbnails
# @param allow_multiple: flag that indicates whether to pick multiple files
# @param images_picked_callback_name: name of the callback function to be invoked after successful pick (Array of PickedImage)
# @param images_picked_callback_object: object on which the images_picked_callback_name is invoked
# @param pick_error_callback_name: name of the callback function to be invoked if the pick results in an error (String)
# @param pick_error_callback_object: object on which the pick_error_callback_name is invoked
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

# Pick photo from camera.
#
# @param max_size: size of the resulting image (pick smaller value to save memory). Pass value <=0 to keep original size.
# @param generate_thumbnails: flag that indicates whether to generate thumbnails
# @param images_picked_callback_name: name of the callback function to be invoked after successful pick (Array of PickedImage)
# @param images_picked_callback_object: object on which the images_picked_callback_name is invoked
# @param pick_error_callback_name: name of the callback function to be invoked if the pick results in an error (String)
# @param pick_error_callback_object: object on which the pick_error_callback_name is invoked
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

# Pick videos from gallery.
#
# @param generate_preview_images: whether generate preview images for the picked videos
# @param allow_multiple: flag that indicates whether to pick multiple files
# @param videos_picked_callback_name: name of the callback function to be invoked after successful pick (Array of PickedVideo)
# @param videos_picked_callback_object: object on which the images_picked_callback_name is invoked
# @param pick_error_callback_name: name of the callback function to be invoked if the pick results in an error (String)
# @param pick_error_callback_object: object on which the pick_error_callback_name is invoked
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

# Record video on camera. Requires the Camera permission.
#
# @param generate_preview_images: whether generate preview images for the picked videos
# @param videos_picked_callback_name: name of the callback function to be invoked after successful pick (Array of PickedVideo)
# @param videos_picked_callback_object: object on which the images_picked_callback_name is invoked
# @param pick_error_callback_name: name of the callback function to be invoked if the pick results in an error (String)
# @param pick_error_callback_object: object on which the pick_error_callback_name is invoked
func record_video(generate_preview_images : bool,
		videos_picked_callback_name : String, videos_picked_callback_object : Object,
		pick_error_callback_name : String, pick_error_callback_object : Object):
			
	_videos_picked_callback_name = videos_picked_callback_name
	_videos_picked_callback_object = videos_picked_callback_object
	_pick_error_callback_name = pick_error_callback_name
	_pick_error_callback_object = pick_error_callback_object
	
	_generate_preview_images = generate_preview_images
	
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		_connect_videos_picked_callback(singleton)
		_connect_pick_error_callback(singleton)
		
		permissions.request_permission(AGPermissions.camera_permission, "_on_camera_permission_video_granted", self)
	else:
		print("No plugin singleton")

# Pick audio files.
#
# @param allow_multiple: flag that indicates whether to pick multiple files
# @param audio_picked_callback_name: name of the callback function to be invoked after successful pick (Array of PickedAudio)
# @param audio_picked_callback_object: object on which the images_picked_callback_name is invoked
# @param pick_error_callback_name: name of the callback function to be invoked if the pick results in an error (String)
# @param pick_error_callback_object: object on which the pick_error_callback_name is invoked
func pick_audio(allow_multiple : bool,
		audio_picked_callback_name : String, audio_picked_callback_object : Object,
		pick_error_callback_name : String, pick_error_callback_object : Object):
			
	_audio_picked_callback_name = audio_picked_callback_name
	_audio_picked_callback_object = audio_picked_callback_object
	_pick_error_callback_name = pick_error_callback_name
	_pick_error_callback_object = pick_error_callback_object
	
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		_connect_audio_picked_callback(singleton)
		_connect_pick_error_callback(singleton)
		
		singleton.pickAudio(allow_multiple)
	else:
		print("No plugin singleton")

# Pick files.
#
# @param allow_multiple: flag that indicates whether to pick multiple files
# @param mime_type: preferred MIME type of the file. List of MIME types can be found here: https://www.freeformatter.com/mime-types-list.html
# @param files_picked_callback_name: name of the callback function to be invoked after successful pick (Array of PickedFile)
# @param files_picked_callback_object: object on which the images_picked_callback_name is invoked
# @param pick_error_callback_name: name of the callback function to be invoked if the pick results in an error (String)
# @param pick_error_callback_object: object on which the pick_error_callback_name is invoked
func pick_files(allow_multiple : bool, mime_type : String,
		files_picked_callback_name : String, files_picked_callback_object : Object,
		pick_error_callback_name : String, pick_error_callback_object : Object):
			
	_files_picked_callback_name = files_picked_callback_name
	_files_picked_callback_object = files_picked_callback_object
	_pick_error_callback_name = pick_error_callback_name
	_pick_error_callback_object = pick_error_callback_object
	
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		_connect_files_picked_callback(singleton)
		_connect_pick_error_callback(singleton)
		
		singleton.pickFiles(mime_type, allow_multiple)
	else:
		print("No plugin singleton")

# Save image to gallery.
#
# @param image: image to be saved
# @param filename: resulting file name
# @param image_saved_callback_name: name of the callback function to be invoked after successful pick 
# @param image_saved_callback_object: object on which the image_saved_callback_name is invoked
# @param pick_error_callback_name: name of the callback function to be invoked if the saving results in an error (String)
# @param pick_error_callback_object: object on which the pick_error_callback_name is invoked
func save_image_to_gallery(image : Image, filename : String, 
		image_saved_callback_name : String, image_saved_callback_object : Object,
		pick_error_callback_name : String, pick_error_callback_object : Object):
	_image_saved_callback_name = image_saved_callback_name
	_image_saved_callback_object = image_saved_callback_object
	_pick_error_callback_name = pick_error_callback_name
	_pick_error_callback_object = pick_error_callback_object
	
	_image_to_save = image
	_filename = filename
	
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		_connect_image_saved_callback(singleton)
		_connect_pick_error_callback(singleton)
		
		permissions.request_permission(AGPermissions.write_storage_permission, "_on_write_storage_granted", self)
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
	
func _connect_audio_picked_callback(singleton):
	singleton.connect(_picked_audio_signal_name, self, "_on_audio_picked")
	
func _on_audio_picked(audio):
	var picked_audios = Array()
	for i in audio.size():
		var picked_audio = PickedAudio.new()
		_set_chosen_file_fields(picked_audio, audio[i])
		picked_audio.audio_duration = audio[i].get("audio_duration")
		picked_audios.append(picked_audio)
	
	_audio_picked_callback_object.call(_audio_picked_callback_name, picked_audios)
	_disconnect_callbacks()
	
func _connect_files_picked_callback(singleton):
	singleton.connect(_picked_files_signal_name, self, "_on_files_picked")
	
func _on_files_picked(files):
	var picked_files = Array()
	for i in files.size():
		var picked_file = PickedFile.new()
		_set_chosen_file_fields(picked_file, files[i])
		picked_files.append(picked_file)
	
	_files_picked_callback_object.call(_files_picked_callback_name, picked_files)
	_disconnect_callbacks()
	
func _connect_pick_error_callback(singleton):
	singleton.connect(_pick_error_signal_name, self, "_on_pick_error")
	
func _connect_image_saved_callback(singleton):
	singleton.connect(_image_saved_signal_name, self, "_on_image_saved")
	
func _on_image_saved():
	_image_saved_callback_object.call(_image_saved_callback_name)
	_disconnect_callbacks()
	
func _on_pick_error(error):
	_pick_error_callback_object.call(_pick_error_callback_name, error)
	_disconnect_callbacks()
	
func _disconnect_callbacks():
	var singleton = Engine.get_singleton(AGUtils.plugin_name)
	
	utils.disconnect_callback_if_connected(singleton, _picked_images_signal_name, self, "_on_images_picked")
	utils.disconnect_callback_if_connected(singleton, _picked_videos_signal_name, self, "_on_videos_picked")
	utils.disconnect_callback_if_connected(singleton, _pick_error_signal_name, self, "_on_pick_error")
	utils.disconnect_callback_if_connected(singleton, _picked_files_signal_name, self, "_on_files_picked")
	utils.disconnect_callback_if_connected(singleton, _picked_audio_signal_name, self, "_on_audio_picked")
	utils.disconnect_callback_if_connected(singleton, _image_saved_signal_name, self, "_on_image_saved")

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
		
func _on_camera_permission_video_granted(permission : String, granted : bool):
	if (permission == AGPermissions.camera_permission && granted):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		singleton.pickVideos(pick_from_camera, _generate_preview_images, false)
	else:
		_on_pick_error("Permission was not granted")
		
func _on_write_storage_granted(permission : String, granted : bool):
	if (permission == AGPermissions.write_storage_permission && granted):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		_image_to_save.decompress()
		_image_to_save.convert(Image.FORMAT_RGBA8)
		singleton.saveImageToGallery(_filename, _image_to_save.get_data(), 
				_image_to_save.get_width(), _image_to_save.get_height())
	else:
		_on_pick_error("Permission was not granted")
