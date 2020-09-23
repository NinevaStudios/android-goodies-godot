package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.util.Log;

import com.ninevastudios.androidgoodies.multipicker.api.AudioPicker;
import com.ninevastudios.androidgoodies.multipicker.api.CameraImagePicker;
import com.ninevastudios.androidgoodies.multipicker.api.CameraVideoPicker;
import com.ninevastudios.androidgoodies.multipicker.api.ContactPicker;
import com.ninevastudios.androidgoodies.multipicker.api.FilePicker;
import com.ninevastudios.androidgoodies.multipicker.api.ImagePicker;
import com.ninevastudios.androidgoodies.multipicker.api.Picker;
import com.ninevastudios.androidgoodies.multipicker.api.VideoPicker;
import com.ninevastudios.androidgoodies.multipicker.api.callbacks.AudioPickerCallback;
import com.ninevastudios.androidgoodies.multipicker.api.callbacks.ContactPickerCallback;
import com.ninevastudios.androidgoodies.multipicker.api.callbacks.FilePickerCallback;
import com.ninevastudios.androidgoodies.multipicker.api.callbacks.ImagePickerCallback;
import com.ninevastudios.androidgoodies.multipicker.api.callbacks.VideoPickerCallback;
import com.ninevastudios.androidgoodies.multipicker.api.entity.ChosenAudio;
import com.ninevastudios.androidgoodies.multipicker.api.entity.ChosenContact;
import com.ninevastudios.androidgoodies.multipicker.api.entity.ChosenFile;
import com.ninevastudios.androidgoodies.multipicker.api.entity.ChosenImage;
import com.ninevastudios.androidgoodies.multipicker.api.entity.ChosenVideo;
import com.ninevastudios.androidgoodies.utils.Constants;
import com.ninevastudios.androidgoodies.utils.ImageUtils;
import com.ninevastudios.androidgoodies.utils.SharedPrefsHelper;

import org.godotengine.godot.Dictionary;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import static com.google.android.vending.expansion.downloader.Constants.TAG;

public class AGPickers {
	public static final int PICK_CAMERA = 0;
	public static final int PICK_GALLERY = 1;

	public static void pickImages(int pickType, int maxSize, boolean generateThumbnails, boolean allowMultiple) {
		switch (pickType) {
			case PICK_CAMERA:
				CameraImagePicker cameraImagePicker = new CameraImagePicker(AndroidGoodies.getGameActivity());
				cameraImagePicker.setImagePickerCallback(getImagePickerCallback());

				String outputPath = cameraImagePicker.pickImage();
				if (outputPath == null) {
					reportPickerError("Image path is not valid.");
					return;
				}

				SharedPrefsHelper.persistImagePickerSettings(maxSize, generateThumbnails, outputPath);
			case PICK_GALLERY:
				SharedPrefsHelper.persistImagePickerSettings(maxSize, generateThumbnails, null);

				ImagePicker picker = new ImagePicker(AndroidGoodies.getGameActivity());
				picker.setImagePickerCallback(getImagePickerCallback());
				if (allowMultiple) {
					picker.allowMultiple();
				}
				picker.pickImage();
		}
	}

	public static void pickVideos(int pickType, boolean generatePreviewImages, boolean allowMultiple) {
		switch (pickType) {
			case PICK_CAMERA:
				CameraVideoPicker cameraVideoPicker = new CameraVideoPicker(AndroidGoodies.getGameActivity());
				cameraVideoPicker.setVideoPickerCallback(getVideoPickerCallback());
				final String outputPath = cameraVideoPicker.pickVideo();

				if (outputPath == null) {
					reportPickerError("Video path is not valid.");
					return;
				}

				SharedPrefsHelper.persistVideoPickerSettings(pickType, generatePreviewImages, outputPath);
			case PICK_GALLERY:
				SharedPrefsHelper.persistVideoPickerSettings(pickType, generatePreviewImages, null);

				VideoPicker videoPicker = new VideoPicker(AndroidGoodies.getGameActivity());
				videoPicker.setVideoPickerCallback(getVideoPickerCallback());
				if (allowMultiple) {
					videoPicker.allowMultiple();
				}
				videoPicker.pickVideo();
		}
	}

	public static void pickFiles(String mimeType, boolean allowMultiple) {
		FilePicker filePicker = new FilePicker(AndroidGoodies.getGameActivity());
		filePicker.setFilePickerCallback(getFilePickerCallback());
		filePicker.setMimeType(mimeType);
		if (allowMultiple) {
			filePicker.allowMultiple();
		}
		filePicker.pickFile();
	}

	public static void pickContact(Activity activity) {
		ContactPicker picker = new ContactPicker(activity);
		picker.pickContact();
	}

	public static void pickAudio(Activity context, boolean allowMultiple) {
		try {
			AudioPicker audioPicker = new AudioPicker(context);
			if (allowMultiple) {
				audioPicker.allowMultiple();
			}
			audioPicker.setAudioPickerCallback(getAudioPickerCallback());
			audioPicker.pickAudio();
		} catch (Exception e) {
			reportPickerError(e.getMessage());
		}
	}

	public static void handleMainActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
		if (resultCode != Activity.RESULT_OK) {
			reportPickerError("Picker Activity result is not OK.");
			return;
		}

		switch (requestCode) {
			case Picker.PICK_CONTACT:
				handleContactReceived(intent, activity);
				break;
			case Picker.PICK_IMAGE_DEVICE:
			case Picker.PICK_IMAGE_CAMERA:
				handlePhotoReceived(intent, activity);
				break;
			case Picker.PICK_AUDIO:
				handleAudioReceived(intent, activity);
				break;
			case Picker.PICK_VIDEO_DEVICE:
			case Picker.PICK_VIDEO_CAMERA:
				handleVideoReceived(intent, activity);
				break;
			case Picker.PICK_FILE:
				handleFileReceived(intent, activity);
				break;
			default:
				Log.w(TAG, "Request code " + requestCode + " is not from Android Goodies plugin, ignoring results.");
				break;
		}
	}

	public static void handlePhotoReceived(Intent data, Activity context) {
		CameraImagePicker picker = new CameraImagePicker(context);
		SharedPrefsHelper.configureImagePicker(picker);
		picker.setImagePickerCallback(getImagePickerCallback());
		picker.submit(data);
	}

	public static void handleVideoReceived(Intent intent, Activity context) {
		int videoPickerType = SharedPrefsHelper.getVideoPickerType();

		VideoPicker videoPicker = new VideoPicker(context);
		SharedPrefsHelper.configureVideoPicker(videoPicker);
		videoPicker.setVideoPickerCallback(getVideoPickerCallback());
		videoPicker.submit(intent);
	}

	public static void handleFileReceived(Intent intent, Activity context) {
		FilePicker filePicker = new FilePicker(context);
		filePicker.setFilePickerCallback(getFilePickerCallback());
		filePicker.submit(intent);
	}

	public static void handleContactReceived(Intent intent, final Activity activity) {
		ContactPicker picker = new ContactPicker(activity);
		picker.setContactPickerCallback(getContactPickerCallback());
		picker.submit(intent);
	}

	public static void handleAudioReceived(Intent intent, Activity context) {
		AudioPicker audioPicker = new AudioPicker(context);
		audioPicker.setAudioPickerCallback(getAudioPickerCallback());
		audioPicker.submit(intent);
	}

	private static ImagePickerCallback getImagePickerCallback() {
		return new ImagePickerCallback() {
			@Override
			public void onImagesChosen(List<ChosenImage> images) {

				if (images.isEmpty()) {
					reportPickerError("No images were picked.");
					return;
				}

				ArrayList<Dictionary> result = new ArrayList<>();
				for (ChosenImage image: images) {
					Dictionary entry = parseChosenFile(image);
					Bitmap bitmap = ImageUtils.getBitmapFromFile(image.getOriginalPath());

					if (bitmap != null) {
						ByteArrayOutputStream stream = new ByteArrayOutputStream();
						bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
						byte[] byteArray = stream.toByteArray();
						entry.put("image_bytes", byteArray);
						entry.put("image_width", image.getWidth());
						entry.put("image_height", image.getHeight());
						bitmap.recycle();
					}

					result.add(entry);
				}

				AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_IMAGES_PICKED, result.toArray());
			}

			@Override
			public void onError(String message) {
				reportPickerError(message);
			}
		};
	}

	private static VideoPickerCallback getVideoPickerCallback() {
		return new VideoPickerCallback() {
			@Override
			public void onVideosChosen(List<ChosenVideo> videos) {
				if (videos.isEmpty()) {
					reportPickerError("No videos were picked.");
					return;
				}

				ArrayList<Dictionary> result = new ArrayList<>();
				for (ChosenVideo video: videos) {
					Dictionary entry = parseChosenFile(video);

					entry.put("video_duration", video.getDuration());
					entry.put("video_height", video.getHeight());
					entry.put("video_width", video.getWidth());
					entry.put("video_orientation", video.getOrientation());
					entry.put("video_preview_image_path", video.getPreviewImage());

					result.add(entry);
				}

				AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_VIDEOS_PICKED, result.toArray());
			}

			@Override
			public void onError(String message) {
				reportPickerError(message);
			}
		};
	}

	private static FilePickerCallback getFilePickerCallback() {
		return new FilePickerCallback() {
			@Override
			public void onFilesChosen(List<ChosenFile> files) {
				if (files.isEmpty()) {
					reportPickerError("No files were picked.");
					return;
				}

				ArrayList<Dictionary> result = new ArrayList<>();
				for (ChosenFile file: files) {
					Dictionary entry = parseChosenFile(file);
					result.add(entry);
				}

				AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_FILES_PICKED, result.toArray());
			}

			@Override
			public void onError(String message) {
				reportPickerError(message);
			}
		};
	}

	private static ContactPickerCallback getContactPickerCallback() {
		return new ContactPickerCallback() {
			@Override
			public void onContactChosen(ChosenContact contact) {
				//TODO
			}

			@Override
			public void onError(String message) {
				reportPickerError(message);
			}
		};
	}



	private static AudioPickerCallback getAudioPickerCallback() {
		return new AudioPickerCallback() {
			@Override
			public void onAudiosChosen(List<ChosenAudio> audios) {
				if (audios.isEmpty()) {
					reportPickerError("No audios were picked.");
					return;
				}

				ArrayList<Dictionary> result = new ArrayList<>();
				for (ChosenAudio audio: audios) {
					Dictionary entry = parseChosenFile(audio);

					entry.put("audio_duration", audio.getDuration());

					result.add(entry);
				}

				AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_AUDIO_PICKED, result.toArray());
			}

			@Override
			public void onError(String message) {
				reportPickerError(message);
			}
		};
	}

	private static void reportPickerError(String error) {
		AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_PICK_ERROR, error);
	}

	private static Dictionary parseChosenFile(ChosenFile chosenFile) {
		Dictionary entry = new Dictionary();

		entry.put("original_path", chosenFile.getOriginalPath());
		entry.put("created_at", chosenFile.getCreatedAt().getTime());
		entry.put("display_name", chosenFile.getDisplayName());
		entry.put("extension", chosenFile.getExtension());
		entry.put("mime_type", chosenFile.getMimeType());
		entry.put("size", chosenFile.getSize());

		return entry;
	}
}
