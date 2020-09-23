extends Node

onready var result_image = get_node("../PickedImage") as TextureRect

var pickers = AGPickers.new()

func _on_PickImagesButtonClicked():
	pickers.pick_image_from_gallery(-1, false, true, "_onImagesPicked", self, "_onPickError", self)

func _onImagesPicked(images : Array):
	print(images.size())
	var texture = ImageTexture.new().create_from_image(images[0].image)
	
func _onPickError(error : String):
	print(error)
