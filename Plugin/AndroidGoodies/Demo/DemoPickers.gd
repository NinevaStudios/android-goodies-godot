extends Node

onready var result_image = get_node("PickedImage") as TextureRect
var default_image : Image

var pickers = AGPickers.new()

func _ready():
	default_image = result_image.texture.get_data()

func _onPickImagesButtonClicked():
	pickers.pick_image_from_gallery(-1, false, true, "_onImagesPicked", self, "_onPickError", self)
		
func _onTakePhotoButtonClicked():
	pickers.take_photo(128, true, "_onImagesPicked", self, "_onPickError", self)
	
func _onPickVideoButtonClicked():
	pickers.pick_videos(true, true, "_onVideosPicked", self, "_onPickError", self)

func _onTakeVideoButtonClicked():
	pickers.record_video(true, "_onVideosPicked", self, "_onPickError", self)
	
func _on_PickAudioButtonClicked():
	pickers.pick_audio(false, "_onAudioPicked", self, "_onPickError", self)

func _on_PickFilesButtonClicked():
	pickers.pick_files(false, "application/pdf", "_onFilesPicked", self, "_onPickError", self)

func _onSaveImageButtonClicked():
	var image = default_image if result_image.texture == null else result_image.texture.get_data()
	
	pickers.save_image_to_gallery(image, "Borsch-godot", "_onImageSaved", self, "_onPickError", self)

func _onImagesPicked(images : Array):
	_set_texture(images[0].original_path)
	_rotate_rect(images[0].image_orientation)
	
func _onVideosPicked(videos : Array):
	_set_texture(videos[0].video_preview_image_path)
	_rotate_rect(videos[0].video_orientation)
	print(videos[0].original_path)
	OS.native_video_play(videos[0].original_path, 100, "default", "default")

func _onAudioPicked(audios : Array):
	print("Picked audio: " + String(audios[0].original_path))
		
func _onFilesPicked(files : Array):
	print("Picked " + String(files.size()) + " files.")
	
func _onImageSaved():
	print("Image saved successfully")
		
func _onPickError(error : String):
	print(error)
		
func _set_texture(path : String):
	var image = Image.new()
	image.load(path)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	result_image.texture = texture

func _rotate_rect(orientation : int):
	var rotation_degree = 0
	match orientation:
		AGPickers.orientation_normal:
			rotation_degree = 0
		AGPickers.orientation_rotate_90:
			rotation_degree = PI / 2
		AGPickers.orientation_rotate_180:
			rotation_degree = PI
		AGPickers.orientation_rotate_270:
			rotation_degree = 3 * PI / 2
			
	result_image.set_rotation(rotation_degree)
