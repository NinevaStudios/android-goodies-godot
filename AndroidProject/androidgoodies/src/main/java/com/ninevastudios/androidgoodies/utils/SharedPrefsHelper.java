package com.ninevastudios.androidgoodies.utils;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

import com.ninevastudios.androidgoodies.AndroidGoodies;
import com.ninevastudios.androidgoodies.multipicker.api.VideoPicker;
import com.ninevastudios.androidgoodies.multipicker.core.ImagePickerImpl;
import com.ninevastudios.androidgoodies.multipicker.core.VideoPickerImpl;

public class SharedPrefsHelper {
	public static final String EXTRAS_PHOTO_OUTPUT_PATH = "EXTRAS_PHOTO_OUTPUT_PATH";
	public static final String EXTRAS_VIDEO_OUTPUT_PATH = "EXTRAS_VIDEO_OUTPUT_PATH";
	private static final String FILE_KEY = "ANDROID_GOODIES_PREFS";
	private static final int MAX_SIZE_DEFAULT = 0;
	private static final String EXTRAS_GENERATE_THUMBNAILS = "EXTRAS_GENERATE_THUMBNAILS";
	private static final String EXTRAS_GENERATE_PREVIEW_IMAGES = "EXTRAS_GENERATE_PREVIEW_IMAGES";
	private static final String EXTRAS_MAX_SIZE = "EXTRAS_MAX_SIZE";
	private static final String VIDEO_PICKER_TYPE = "VIDEO_PICKER_TYPE";

	// region PHOTO_PICKER
	// Persist all settings that are sent from Unity as intent extras
	@SuppressLint("ApplySharedPref")
	public static void persistImagePickerSettings(int maxSize, boolean generateThumbnails, String photoOutputPath) {
		SharedPreferences.Editor editor = getPrefs().edit();
		editor.putInt(EXTRAS_MAX_SIZE, maxSize);
		editor.putBoolean(EXTRAS_GENERATE_THUMBNAILS, generateThumbnails);
		editor.putString(EXTRAS_PHOTO_OUTPUT_PATH, photoOutputPath);
		editor.commit();
	}

	@SuppressLint("ApplySharedPref")
	public static void persistVideoPickerSettings(int videoPickerType, boolean generatePreviewImages, String videoOutputPath) {
		SharedPreferences.Editor editor = getPrefs().edit();

		editor.putInt(VIDEO_PICKER_TYPE, videoPickerType);
		editor.putBoolean(EXTRAS_GENERATE_PREVIEW_IMAGES, generatePreviewImages);
		editor.putString(EXTRAS_VIDEO_OUTPUT_PATH, videoOutputPath);
		editor.commit();
	}

	public static int getVideoPickerType() {
		return getPrefs().getInt(VIDEO_PICKER_TYPE, -1);
	}

	private static int getMaxImageSize() {
		return getPrefs().getInt(EXTRAS_MAX_SIZE, MAX_SIZE_DEFAULT);
	}

	private static boolean shouldGenerateThumbnails() {
		return getPrefs().getBoolean(EXTRAS_GENERATE_THUMBNAILS, true);
	}

	private static boolean shouldGeneratePreviewImages() {
		return getPrefs().getBoolean(EXTRAS_GENERATE_PREVIEW_IMAGES, true);
	}

	public static String getPhotoOutputPath() {
		return getPrefs().getString(EXTRAS_PHOTO_OUTPUT_PATH, null);
	}

	public static String getVideoOutputPath() {
		return getPrefs().getString(EXTRAS_VIDEO_OUTPUT_PATH, null);
	}

	// endregion

	private static SharedPreferences getPrefs() {
		return AndroidGoodies.getGameActivity().getSharedPreferences(FILE_KEY, Context.MODE_PRIVATE);
	}

	public static void configureImagePicker(ImagePickerImpl picker) {
		int maxSize = getMaxImageSize();
		picker.ensureMaxSize(maxSize, maxSize);
		picker.shouldGenerateThumbnails(shouldGenerateThumbnails());
		if (getPhotoOutputPath() != null) {
			picker.reinitialize(getPhotoOutputPath());
		}
	}

	public static void configureVideoPicker(VideoPickerImpl picker) {
		picker.shouldGeneratePreviewImages(shouldGeneratePreviewImages());
		picker.reinitialize(getVideoOutputPath());
	}
}

