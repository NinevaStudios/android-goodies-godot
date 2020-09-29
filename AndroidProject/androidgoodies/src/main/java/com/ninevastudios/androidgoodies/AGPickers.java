package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.util.Log;

import com.ninevastudios.androidgoodies.multipicker.api.AudioPicker;
import com.ninevastudios.androidgoodies.multipicker.api.CacheLocation;
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
import com.ninevastudios.androidgoodies.multipicker.core.ImagePickerImpl;
import com.ninevastudios.androidgoodies.multipicker.core.VideoPickerImpl;
import com.ninevastudios.androidgoodies.utils.Constants;
import com.ninevastudios.androidgoodies.utils.SharedPrefsHelper;

import org.godotengine.godot.Dictionary;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.ByteBuffer;
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
				break;
			case PICK_GALLERY:
				SharedPrefsHelper.persistImagePickerSettings(maxSize, generateThumbnails, null);

				ImagePicker picker = new ImagePicker(AndroidGoodies.getGameActivity());
				picker.setImagePickerCallback(getImagePickerCallback());
				if (allowMultiple) {
					picker.allowMultiple();
				}
				picker.pickImage();
				break;
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
				break;
			case PICK_GALLERY:
				SharedPrefsHelper.persistVideoPickerSettings(pickType, generatePreviewImages, null);

				VideoPicker videoPicker = new VideoPicker(AndroidGoodies.getGameActivity());
				videoPicker.setVideoPickerCallback(getVideoPickerCallback());
				if (allowMultiple) {
					videoPicker.allowMultiple();
				}
				videoPicker.pickVideo();
				break;
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

	public static void pickContact() {
		ContactPicker picker = new ContactPicker(AndroidGoodies.getGameActivity());
		picker.pickContact();
	}

	public static void pickAudio(boolean allowMultiple) {
		try {
			AudioPicker audioPicker = new AudioPicker(AndroidGoodies.getGameActivity());
			if (allowMultiple) {
				audioPicker.allowMultiple();
			}
			audioPicker.setAudioPickerCallback(getAudioPickerCallback());
			audioPicker.pickAudio();
		} catch (Exception e) {
			reportPickerError(e.getMessage());
		}
	}

	public static void saveImageToGallery(String fileName, byte[] buffer, int width, int height) {
		final Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return;
		}

		Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
		ByteBuffer byteBuffer = ByteBuffer.wrap(buffer);
		bitmap.copyPixelsFromBuffer(byteBuffer);
		File root = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
		File file = new File(root, fileName + ".png");
		Log.d(Constants.LOG_TAG, file.getAbsolutePath());
		try {
			FileOutputStream out = new FileOutputStream(file);
			bitmap.compress(Bitmap.CompressFormat.PNG, 100, out);
			out.flush();
			out.close();

			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
				MediaScannerConnection.scanFile(activity, new String[]{file.toString()}, null,
						new MediaScannerConnection.OnScanCompletedListener() {
							public void onScanCompleted(String path, Uri uri) {
							}
						});
			} else {
				Uri uri = Uri.fromFile(file);
				Intent intent = new Intent(Intent.ACTION_MEDIA_MOUNTED, uri);
				activity.sendBroadcast(intent);
			}

			AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_IMAGE_SAVED);
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
				handlePhotoReceived(PICK_GALLERY, intent, activity);
				break;
			case Picker.PICK_IMAGE_CAMERA:
				handlePhotoReceived(PICK_CAMERA, intent, activity);
				break;
			case Picker.PICK_AUDIO:
				handleAudioReceived(intent, activity);
				break;
			case Picker.PICK_VIDEO_DEVICE:
				handleVideoReceived(PICK_GALLERY, intent, activity);
				break;
			case Picker.PICK_VIDEO_CAMERA:
				handleVideoReceived(PICK_CAMERA, intent, activity);
				break;
			case Picker.PICK_FILE:
				handleFileReceived(intent, activity);
				break;
			default:
				Log.w(TAG, "Request code " + requestCode + " is not from Android Goodies plugin, ignoring results.");
				break;
		}
	}

	public static void handlePhotoReceived(int pickType, Intent data, Activity context) {
		ImagePickerImpl picker;
		if (pickType == PICK_CAMERA) {
			picker = new CameraImagePicker(context);
		} else {
			picker = new ImagePicker(context);
		}

		SharedPrefsHelper.configureImagePicker(picker);
		picker.setCacheLocation(CacheLocation.INTERNAL_APP_DIR);
		picker.setImagePickerCallback(getImagePickerCallback());
		picker.submit(data);
	}

	public static void handleVideoReceived(int pickType, Intent intent, Activity context) {
		VideoPickerImpl picker;
		if (pickType == PICK_CAMERA) {
			picker = new CameraVideoPicker(context);
		} else {
			picker = new VideoPicker(context);
		}

		SharedPrefsHelper.configureVideoPicker(picker);
		picker.setCacheLocation(CacheLocation.INTERNAL_APP_DIR);
		picker.setVideoPickerCallback(getVideoPickerCallback());
		picker.submit(intent);
	}

	public static void handleFileReceived(Intent intent, Activity context) {
		FilePicker filePicker = new FilePicker(context);
		filePicker.setCacheLocation(CacheLocation.INTERNAL_APP_DIR);
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
		audioPicker.setCacheLocation(CacheLocation.INTERNAL_APP_DIR);
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

				Object[] result = new Object[images.size()];
				for (int i = 0; i < images.size(); i++) {
					ChosenImage image = images.get(i);
					Dictionary entry = parseChosenFile(image);

					entry.put("image_orientation", image.getOrientation());

					result[i] = entry;
				}

				AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_IMAGES_PICKED, (Object) result);
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

				Object[] result = new Object[videos.size()];
				for (int i = 0; i < videos.size(); i++) {
					ChosenVideo video = videos.get(i);
					Dictionary entry = parseChosenFile(video);

					entry.put("video_duration", video.getDuration());
					entry.put("video_height", video.getHeight());
					entry.put("video_width", video.getWidth());
					entry.put("video_orientation", video.getOrientation());
					entry.put("video_preview_image_path", video.getPreviewImage());

					result[i] = entry;
				}

				AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_VIDEOS_PICKED, (Object) result);
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

				Object[] result = new Object[files.size()];
				for (int i = 0; i < files.size(); i++) {
					Dictionary entry = parseChosenFile(files.get(i));
					result[i] = entry;
				}

				AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_FILES_PICKED, (Object) result);
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

				Object[] result = new Object[audios.size()];
				for (int i = 0; i < audios.size(); i++) {
					Dictionary entry = parseChosenFile(audios.get(i));
					entry.put("audio_duration", audios.get(i).getDuration());
					result[i] = entry;
				}

				AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_AUDIO_PICKED, (Object) result);
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
