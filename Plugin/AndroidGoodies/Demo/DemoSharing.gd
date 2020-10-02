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

func _onSendSMSIntentButtonClicked():
	sharer.send_sms_via_messaging_app("+1234567890", "SMS via chooser", true, chooser_title)

func _onSendSMSDirectlyButtonClicked():
	sharer.send_sms_directly("380631895341", "Direct SMS")

func _onSendEmailButtonClicked():
	sharer.send_email("Email with text and image", "A very meaningful text.", image, 
			["carl@borsch.com"], ["cc@gmail.com"], ["bcc@gmail.com"])

func _onSendEmailMultiImageButtonClicked():
	sharer.send_email_with_images("Email with multiple images", [image, image, image],
			["carl@borsch.com"], ["cc@gmail.com"], ["bcc@gmail.com"])
