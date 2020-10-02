class_name AGShare

var permissions = AGPermissions.new()

var _phone_number : String = ""
var _sms_body : String = ""

func share_text(subject : String, text_body : String, 
		with_chooser : bool = false, chooser_title : String = ""):
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		singleton.shareText(subject, text_body, with_chooser, chooser_title)
	else:
		print("No plugin singleton")

func share_image(image : Image, with_chooser : bool = false, chooser_title : String = ""):
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		var image_path = _save_image_to_cache(image)
		singleton.shareImage(image_path, with_chooser, chooser_title)
	else:
		print("No plugin singleton")

func share_text_with_image(subject : String, text_body : String, image : Image,
		with_chooser : bool = false, chooser_title : String = ""):
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		var image_path = _save_image_to_cache(image)
		singleton.shareTextWithImage(subject, text_body, image_path, with_chooser, chooser_title)
	else:
		print("No plugin singleton")

func share_video(video_path : String, with_chooser : bool = false, chooser_title : String = ""):
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		singleton.shareVideo(video_path, with_chooser, chooser_title)
	else:
		print("No plugin singleton")

func send_sms_via_messaging_app(phone_number : String, message : String, 
		with_chooser : bool = false, chooser_title : String = ""):
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		singleton.sendSmsViaMessagingApp(phone_number, message, with_chooser, chooser_title)
	else:
		print("No plugin singleton")

func send_sms_directly(phone_number : String, message : String):
	_phone_number = phone_number
	_sms_body = message
	if Engine.has_singleton(AGUtils.plugin_name):
		permissions.request_permission(AGPermissions.send_sms_permission, "_on_sms_permission_granted", self)
	else:
		print("No plugin singleton")

func send_email(subject : String, text_body : String, image : Image, recipients : PoolStringArray, 
		cc : PoolStringArray, bcc : PoolStringArray, with_chooser : bool = false, chooser_title : String = ""):
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		var image_path = _save_image_to_cache(image)
		singleton.sendEMail(subject, text_body, image_path, recipients, cc, bcc, with_chooser, chooser_title)
	else:
		print("No plugin singleton")

func send_email_with_images(subject : String, extra_images : Array, recipients : PoolStringArray, 
		cc : PoolStringArray, bcc : PoolStringArray, with_chooser : bool = false, chooser_title : String = ""):
	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		var image_paths = PoolStringArray()
		for image in extra_images:
			var image_path = _save_image_to_cache(image)
			image_paths.append(image_path)
		
		singleton.sendEMailWithMultipleImages(subject, image_paths, recipients, cc, bcc, with_chooser, chooser_title)
	else:
		print("No plugin singleton")
		
func _save_image_to_cache(image : Image) -> String:
	if image == null or not image is Image:
		print("Image is not valid. Not saving")
		return ""

	if Engine.has_singleton(AGUtils.plugin_name):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		
		image.decompress()
		image.convert(Image.FORMAT_RGBA8)
		
		return singleton.saveImageToCache(image.get_data(), image.get_width(), image.get_height())
	else:
		print("No plugin singleton")
		return ""
		
func _on_sms_permission_granted(permission : String, granted : bool):
	if (permission == AGPermissions.send_sms_permission && granted):
		var singleton = Engine.get_singleton(AGUtils.plugin_name)
		singleton.sendSmsDirectly(_phone_number, _sms_body)
