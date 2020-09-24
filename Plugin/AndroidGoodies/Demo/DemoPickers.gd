extends Node

onready var result_image = get_node("PickedImage") as TextureRect

var pickers = AGPickers.new()

func _onPickImagesButtonClicked():
	pickers.pick_image_from_gallery(-1, false, true, "_onImagesPicked", self, "_onPickError", self)
		
func _onTakePhotoButtonClicked():
	pickers.take_photo(128, true, "_onImagesPicked", self, "_onPickError", self)
	
func _onPickVideoButtonClicked():
	pickers.pick_videos(true, true, "_onVideosPicked", self, "_onPickError", self)

func _onTakeVideoButtonClicked():
	pickers.record_video(true, "_onVideosPicked", self, "_onPickError", self)

func _onImagesPicked(images : Array):
	_set_texture(images[0].original_path)
	_rotate_rect(images[0].image_orientation)
	
func _onVideosPicked(videos : Array):
	_set_texture(videos[0].video_preview_image_path)
	_rotate_rect(videos[0].video_orientation)
	print(videos[0].original_path)
	var error = OS.native_video_play(videos[0].original_path, 100, "default", "default")
	print(error)
	
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
