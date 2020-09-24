extends Node

onready var result_image = get_node("../PickedImage") as TextureRect

var pickers = AGPickers.new()

func _on_PickImagesButtonClicked():
	pickers.pick_image_from_gallery(-1, false, true, "_onImagesPicked", self, "_onPickError", self)
		
func _onTakePhotoButtonClicked():
	pickers.take_photo(128, true, "_onImagesPicked", self, "_onPickError", self)

func _onImagesPicked(images : Array):
	_set_texture(images[0])
	_rotate_rect(images[0].image_orientation)
	
func _onPickError(error : String):
	print(error)
		
func _set_texture(picked_image : AGPickers.PickedImage):
	var image = Image.new()
	image.load(picked_image.original_path)
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


