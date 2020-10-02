extends Node

onready var image = (load("res://icon.png") as Texture).get_data()

var sharer = AGShare.new()
var pickers = AGPickers.new()

const chooser_title = "Choose your destiny..."

func _onShareTextButtonClicked():
	sharer.share_text("Android Goodies", "Text message", true, chooser_title)

func _onShareTextWithImageButtonClicked():
	sharer.share_text_with_image("Android Goodies", "Text message", image, true, chooser_title)

func _onPickAndShareVideoButtonClicked():
	pickers.pick_videos(true, false, "_onVideosPicked", self, "_onPickError", self)
	
func _onVideosPicked(videos : Array):
	sharer.share_video(videos[0].original_path, true, chooser_title)
		
func _onPickError(error : String):
	print(error)
