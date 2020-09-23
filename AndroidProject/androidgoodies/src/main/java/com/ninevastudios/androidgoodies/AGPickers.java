package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.content.Intent;
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
import com.ninevastudios.androidgoodies.utils.SharedPrefsHelper;

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

				String outputPath = ((CameraImagePicker) cameraImagePicker).pickImage();
				if (outputPath == null) {
					//TODO
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
				cameraVideoPicker.setVideoPickerCallback(getVideoPickerCallback(pickType));
				final String outputPath = cameraVideoPicker.pickVideo();

				if (outputPath == null) {
					//TODO
					Log.e(Constants.LOG_TAG, "Failed to take video");
					return;
				}

				SharedPrefsHelper.persistVideoPickerSettings(pickType, generatePreviewImages, outputPath);
			case PICK_GALLERY:
				SharedPrefsHelper.persistVideoPickerSettings(pickType, generatePreviewImages, null);

				VideoPicker videoPicker = new VideoPicker(AndroidGoodies.getGameActivity());
				videoPicker.setVideoPickerCallback(getVideoPickerCallback(pickType));
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
			//TODO
		}
	}

	public static void handleMainActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
		switch (requestCode) {
			case Picker.PICK_CONTACT:
				handleContactReceived(resultCode, intent, activity);
				break;
			case Picker.PICK_IMAGE_DEVICE:
			case Picker.PICK_IMAGE_CAMERA:
				handlePhotoReceived(resultCode, intent, activity);
				break;
			case Picker.PICK_AUDIO:
				handleAudioReceived(resultCode, intent, activity);
				break;
			case Picker.PICK_VIDEO_DEVICE:
			case Picker.PICK_VIDEO_CAMERA:
				handleVideoReceived(resultCode, intent, activity);
				break;
			case Picker.PICK_FILE:
				handleFileReceived(resultCode, intent, activity);
				break;
			default:
				Log.w(TAG, "Request code " + requestCode + " is not from Android Goodies plugin, ignoring results.");
				break;
		}
	}

	public static void handlePhotoReceived(int resultCode, Intent data, Activity context) {
		if (resultCode != Activity.RESULT_OK) {
			//TODO
			return;
		}

		CameraImagePicker picker = new CameraImagePicker(context);
		SharedPrefsHelper.configureImagePicker(picker);
		picker.setImagePickerCallback(getImagePickerCallback());
		picker.submit(data);
	}

	public static void handleVideoReceived(int resultCode, Intent intent, Activity context) {
		int videoPickerType = SharedPrefsHelper.getVideoPickerType();

		if (resultCode != Activity.RESULT_OK) {
			//TODO
			return;
		}

		VideoPicker videoPicker = new VideoPicker(context);
		SharedPrefsHelper.configureVideoPicker(videoPicker);
		videoPicker.setVideoPickerCallback(getVideoPickerCallback(videoPickerType));
		videoPicker.submit(intent);
	}

	public static void handleFileReceived(int resultCode, Intent intent, Activity context) {
		if (resultCode != Activity.RESULT_OK) {
			//TODO
			return;
		}

		FilePicker filePicker = new FilePicker(context);
		filePicker.setFilePickerCallback(getFilePickerCallback());
		filePicker.submit(intent);
	}

	public static void handleContactReceived(int resultCode, Intent intent, final Activity activity) {
		if (resultCode != Activity.RESULT_OK) {
			//TODO
			return;
		}

		ContactPicker picker = new ContactPicker(activity);
		picker.setContactPickerCallback(getContactPickerCallback());
		picker.submit(intent);
	}

	public static void handleAudioReceived(int resultCode, Intent intent, Activity context) {
		if (resultCode != Activity.RESULT_OK) {
			//TODO
			return;
		}

		AudioPicker audioPicker = new AudioPicker(context);
		audioPicker.setAudioPickerCallback(getAudioPickerCallback());
		audioPicker.submit(intent);
	}

	private static ImagePickerCallback getImagePickerCallback() {
		return new ImagePickerCallback() {
			@Override
			public void onImagesChosen(List<ChosenImage> images) {
				ChosenImage img = images.get(0);

				if (img.getWidth() == 0 || img.getHeight() == 0) {
					//TODO
					return;
				}

				//TODO
			}

			@Override
			public void onError(String message) {
				//TODO
			}
		};
	}

	private static VideoPickerCallback getVideoPickerCallback(final int pickerType) {
		return new VideoPickerCallback() {
			@Override
			public void onVideosChosen(List<ChosenVideo> videos) {
				//TODO
			}

			@Override
			public void onError(String message) {
				//TODO
			}
		};
	}

	private static FilePickerCallback getFilePickerCallback() {
		return new FilePickerCallback() {
			@Override
			public void onFilesChosen(List<ChosenFile> files) {
				//TODO
			}

			@Override
			public void onError(String message) {
				//TODO
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
				//TODO
			}
		};
	}



	private static AudioPickerCallback getAudioPickerCallback() {
		return new AudioPickerCallback() {
			@Override
			public void onAudiosChosen(List<ChosenAudio> audios) {
				if (audios.isEmpty()) {
					//TODO
					return;
				}

				//TODO
			}

			@Override
			public void onError(String message) {
				//TODO
			}
		};
	}
}
