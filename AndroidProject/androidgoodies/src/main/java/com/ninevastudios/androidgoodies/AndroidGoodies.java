package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.media.AudioAttributes;
import android.os.BatteryManager;
import android.os.Build;
import android.os.VibrationEffect;
import android.os.Vibrator;
import android.util.Log;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.collection.ArraySet;
import androidx.core.content.ContextCompat;

import com.ninevastudios.androidgoodies.utils.Constants;

import org.godotengine.godot.Dictionary;
import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;

import java.util.Arrays;
import java.util.List;
import java.util.Set;

public class AndroidGoodies extends GodotPlugin {
	//region GODOT_IMPLEMENTATION

	static final String SIGNAL_ON_POSITIVE_BUTTON_CLICKED = "onPositiveButtonClicked";
	static final String SIGNAL_ON_NEGATIVE_BUTTON_CLICKED = "onNegativeButtonClicked";
	static final String SIGNAL_ON_NEUTRAL_BUTTON_CLICKED = "onNeutralButtonClicked";
	static final String SIGNAL_ON_DIALOG_CANCELLED = "onDialogCancelled";
	static final String SIGNAL_ON_PROGRESS_DIALOG_DISMISSED = "onProgressDialogDismissed";
	static final String SIGNAL_ON_DIALOG_ITEM_CLICKED = "onDialogItemClicked";
	static final String SIGNAL_ON_DIALOG_ITEM_SELECTED = "onDialogItemSelected";

	static final String SIGNAL_ON_IMAGES_PICKED = "onImagesPicked";
	static final String SIGNAL_ON_VIDEOS_PICKED = "onVideosPicked";
	static final String SIGNAL_ON_FILES_PICKED = "onFilesPicked";
	static final String SIGNAL_ON_CONTACT_PICKED = "onContactPicked";
	static final String SIGNAL_ON_AUDIO_PICKED = "onAudioPicked";
	static final String SIGNAL_ON_IMAGE_SAVED = "onImageSaved";
	static final String SIGNAL_ON_PICK_ERROR = "onPickError";

	static final String SIGNAL_ON_PERMISSION_GRANTED = "onPermissionGranted";

	static final int REQUEST_PERMISSIONS = 100500;

	@NonNull
	public String getPluginName() {
		return Constants.LOG_TAG;
	}

	@NonNull
	public List<String> getPluginMethods() {
		return Arrays.asList(
				// Native UI
				"showToast",
				"showButtonDialog",
				"showItemsDialog",
				"showSingleChoiceDialog",
				"showMultipleChoiceDialog",
				"showProgressDialog",
				"setProgressForProgressDialog",
				"dismissProgressDialog",
				// Pickers
				"pickImages",
				"pickVideos",
				"pickFiles",
				"pickAudio",
				"saveImageToGallery",
				//Device Info
				"hasSystemFeature",
				"getBuildVersionBaseOs",
				"getBuildVersionCodeName",
				"getBuildVersionRelease",
				"getBuildVersionSdkInt",
				"getBuildBoard",
				"getBuildBootloader",
				"getBuildBrand",
				"getBuildDevice",
				"getBuildDisplay",
				"getBuildHardware",
				"getBuildManufacturer",
				"getBuildModel",
				"getBuildProduct",
				"getBuildRadioVersion",
				"getBuildSerial",
				"getBuildTags",
				"getBuildType",
				"getApplicationPackageName",
				"isPackageInstalled",
				//Sharing
				"shareText",
				"shareImage",
				"shareTextWithImage",
				"shareVideo",
				"sendSmsViaMessagingApp",
				"sendSmsDirectly",
				"sendEMail",
				"sendEMailWithMultipleImages",
				"saveImageToCache",
				//Hardware
				"enableFlashlight",
				"hasVibrator",
				"hasAmplitudeControl",
				"vibrate",
				"stopVibration",
				"computeRemainingChargeTime",
				"getBatteryCapacity",
				"getBatteryChargeCounter",
				"getAverageBatteryCurrent",
				"getImmediateBatteryCurrent",
				"getBatteryCurrent",
				"getBatteryEnergyCounter",
				"getBatteryStatus",
				"isBatteryLow",
				"getBatteryHealth",
				"getBatteryLevel",
				"getBatteryPluggedState",
				"isBatteryPresent",
				"getBatteryScale",
				"getBatteryTechnology",
				"getBatteryTemperature",
				"getBatteryVoltage",
				// Other
				"requestPermission");
	}

	@NonNull
	public Set<SignalInfo> getPluginSignals() {
		Set<SignalInfo> signals = new ArraySet<>();
		// Native UI
		signals.add(new SignalInfo(SIGNAL_ON_POSITIVE_BUTTON_CLICKED));
		signals.add(new SignalInfo(SIGNAL_ON_NEGATIVE_BUTTON_CLICKED));
		signals.add(new SignalInfo(SIGNAL_ON_NEUTRAL_BUTTON_CLICKED));
		signals.add(new SignalInfo(SIGNAL_ON_DIALOG_CANCELLED));
		signals.add(new SignalInfo(SIGNAL_ON_DIALOG_ITEM_CLICKED, Integer.class));
		signals.add(new SignalInfo(SIGNAL_ON_DIALOG_ITEM_SELECTED, Integer.class, Boolean.class));
		signals.add(new SignalInfo(SIGNAL_ON_PROGRESS_DIALOG_DISMISSED));
		// Pickers
		signals.add(new SignalInfo(SIGNAL_ON_IMAGES_PICKED, Object[].class));
		signals.add(new SignalInfo(SIGNAL_ON_VIDEOS_PICKED, Object[].class));
		signals.add(new SignalInfo(SIGNAL_ON_FILES_PICKED, Object[].class));
		signals.add(new SignalInfo(SIGNAL_ON_CONTACT_PICKED, Dictionary.class));
		signals.add(new SignalInfo(SIGNAL_ON_AUDIO_PICKED, Object[].class));
		signals.add(new SignalInfo(SIGNAL_ON_IMAGE_SAVED));
		signals.add(new SignalInfo(SIGNAL_ON_PICK_ERROR, String.class));
		// Other
		signals.add(new SignalInfo(SIGNAL_ON_PERMISSION_GRANTED, String.class, Boolean.class));
		return signals;
	}

	//endregion

	//region HELPERS

	public AndroidGoodies(Godot godot) {
		super(godot);
		instance = this;
	}

	private static AndroidGoodies instance;

	static AndroidGoodies getInstance() {
		return instance;
	}

	void emitSignalCallback(String signal, final Object... signalArgs) {
		this.emitSignal(signal, signalArgs);
	}

	public static Activity getGameActivity() {
		if (instance == null) {
			return null;
		}

		return instance.getActivity();
	}

	boolean m_IsAvailableForPick = true;

	public void onMainActivityResult(int requestCode, int resultCode, Intent intent) {
		Log.d(Constants.LOG_TAG, ">>> onActivityResult: " + requestCode + " " + resultCode + " " + intent);
		m_IsAvailableForPick = true;

		AGPickers.handleMainActivityResult(getGameActivity(), requestCode, resultCode, intent);
	}

	public void requestPermission(String permission) {
		if (ContextCompat.checkSelfPermission(getActivity(), permission) == PackageManager.PERMISSION_GRANTED) {
			emitSignal(SIGNAL_ON_PERMISSION_GRANTED, permission, true);
		} else {
			if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
				getActivity().requestPermissions(new String[]{permission}, REQUEST_PERMISSIONS);
			} else {
				emitSignal(SIGNAL_ON_PERMISSION_GRANTED, permission, false);
			}
		}
	}

	public void onMainRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
		if (requestCode != REQUEST_PERMISSIONS) {
			Log.d(Constants.LOG_TAG, "Permission was not requested by Android Goodies, ignoring.");
			return;
		}

		for (int i = 0; i < permissions.length; i++) {
			emitSignal(SIGNAL_ON_PERMISSION_GRANTED, permissions[i], grantResults[i] == PackageManager.PERMISSION_GRANTED);
		}
	}

	public void onMainPause() {
		AGProgressDialog.pause();
	}

	public void onMainResume() {
		AGProgressDialog.resume();
	}

	//endregion

	//region NATIVE_UI

	public void showToast(final String toast, final int length) {
		AGNativeUi.showToast(toast, length);
	}

	public void showButtonDialog(String title, String body, String positiveButtonText,
	                             String negativeButtonText, String neutralButtonText,
	                             int theme, boolean isCancellable) {
		AGNativeUi.showButtonDialog(title, body, positiveButtonText, negativeButtonText, neutralButtonText, theme, isCancellable);
	}

	public void showItemsDialog(String title, String[] items, int theme, boolean isCancellable) {
		AGNativeUi.showItemsDialog(title, items, theme, isCancellable);
	}

	public void showSingleChoiceDialog(String title, String[] items, int selectedIndex, String positiveButtonText,
	                                   String negativeButtonText, String neutralButtonText,
	                                   int theme, boolean isCancellable) {
		AGNativeUi.showSingleChoiceDialog(title, items, selectedIndex, positiveButtonText,
				negativeButtonText, neutralButtonText, theme, isCancellable);
	}

	public void showMultipleChoiceDialog(String title, String[] items, int[] selected, String positiveButtonText,
	                                     String negativeButtonText, String neutralButtonText,
	                                     int theme, boolean isCancellable) {
		AGNativeUi.showMultipleChoiceDialog(title, items, selected, positiveButtonText,
				negativeButtonText, neutralButtonText, theme, isCancellable);
	}

	public void showProgressDialog(String title, String message, int progress, int maxValue, int theme, boolean isCancellable, boolean isIndeterminate) {
		AGProgressDialog.show(title, message, progress, maxValue, theme, isCancellable, isIndeterminate);
	}

	public void setProgressForProgressDialog(int progress) {
		AGProgressDialog.setProgress(progress);
	}

	public void dismissProgressDialog() {
		AGProgressDialog.dismiss();
	}

	//endregion

	//region PICKERS

	public void pickImages(int pickerType, int maxSize, boolean generateThumbnails, boolean allowMultiple) {
		if (!m_IsAvailableForPick) {
			Log.w(Constants.LOG_TAG, "Activity is busy. Will not start picking.");
			return;
		}

		m_IsAvailableForPick = false;
		AGPickers.pickImages(pickerType, maxSize, generateThumbnails, allowMultiple);
	}

	public void pickVideos(int pickerType, boolean generatePreviewImages, boolean allowMultiple) {
		if (!m_IsAvailableForPick) {
			Log.w(Constants.LOG_TAG, "Activity is busy. Will not start picking.");
			return;
		}

		m_IsAvailableForPick = false;
		AGPickers.pickVideos(pickerType, generatePreviewImages, allowMultiple);
	}

	public void pickFiles(String mimeType, boolean allowMultiple) {
		if (!m_IsAvailableForPick) {
			Log.w(Constants.LOG_TAG, "Activity is busy. Will not start picking.");
			return;
		}

		m_IsAvailableForPick = false;
		AGPickers.pickFiles(mimeType, allowMultiple);
	}

	public void pickAudio(boolean allowMultiple) {
		if (!m_IsAvailableForPick) {
			Log.w(Constants.LOG_TAG, "Activity is busy. Will not start picking.");
			return;
		}

		m_IsAvailableForPick = false;
		AGPickers.pickAudio(allowMultiple);
	}

	public void saveImageToGallery(String fileName, byte[] buffer, int width, int height) {
		AGPickers.saveImageToGallery(fileName, buffer, width, height);
	}

	//endregion

	//region DEVICE_INFO

	public boolean hasSystemFeature(String feature) {
		return AGDeviceInfo.hasSystemFeature(feature);
	}

	@RequiresApi(api = Build.VERSION_CODES.M)
	public String getBuildVersionBaseOs() {
		return Build.VERSION.BASE_OS;
	}

	public String getBuildVersionCodeName() {
		return Build.VERSION.CODENAME;
	}

	public String getBuildVersionRelease() {
		return Build.VERSION.RELEASE;
	}

	public int getBuildVersionSdkInt() {
		return Build.VERSION.SDK_INT;
	}

	public String getBuildBoard() {
		return Build.BOARD;
	}

	public String getBuildBootloader() {
		return Build.BOOTLOADER;
	}

	public String getBuildBrand() {
		return Build.BRAND;
	}

	public String getBuildDevice() {
		return Build.DEVICE;
	}

	public String getBuildDisplay() {
		return Build.DISPLAY;
	}

	public String getBuildHardware() {
		return Build.HARDWARE;
	}

	public String getBuildManufacturer() {
		return Build.MANUFACTURER;
	}

	public String getBuildModel() {
		return Build.MODEL;
	}

	public String getBuildProduct() {
		return Build.PRODUCT;
	}

	public String getBuildRadioVersion() {
		return Build.getRadioVersion();
	}

	public String getBuildSerial() {
		return Build.SERIAL;
	}

	public String getBuildTags() {
		return Build.TAGS;
	}

	public String getBuildType() {
		return Build.TYPE;
	}

	public String getApplicationPackageName() {
		return AGDeviceInfo.getApplicationPackageName();
	}

	public boolean isPackageInstalled(String packageName) {
		return AGDeviceInfo.isPackageInstalled(packageName);
	}

	//endregion

	//region SHARING

	public void shareText(String subject, String textBody,
	                      boolean withChooser, String chooserTitle) {
		AGShare.shareText(subject, textBody, withChooser, chooserTitle);
	}

	public void shareImage(String imagePath, boolean withChooser,
	                       String chooserTitle) {
		AGShare.shareImage(imagePath, withChooser, chooserTitle);
	}

	public void shareTextWithImage(String subject, String textBody,
	                               String imagePath, boolean withChooser, String chooserTitle) {
		AGShare.shareTextWithImage(subject, textBody, imagePath, withChooser, chooserTitle);
	}

	public void shareVideo(final String videoPath, final boolean withChooser,
	                       final String chooserTitle) {
		AGShare.shareVideo(videoPath, withChooser, chooserTitle);
	}

	public void sendSmsViaMessagingApp(String phoneNumber, String message,
	                                   boolean withChooser, String chooserTitle) {
		AGShare.sendSmsViaMessagingApp(phoneNumber, message, withChooser, chooserTitle);
	}

	public void sendSmsDirectly(String phoneNumber, String message) {
		AGShare.sendSmsDirectly(phoneNumber, message);
	}

	public void sendEMail(String subject, String textBody, String imagePath,
	                      String[] recipients, String[] cc, String[] bcc,
	                      boolean withChooser, String chooserTitle) {
		AGShare.sendEMail(subject, textBody, imagePath, recipients, cc, bcc, withChooser, chooserTitle);
	}

	public void sendEMailWithMultipleImages(String subject, String[] extraImagePaths,
	                                        String[] recipients, String[] cc, String[] bcc,
	                                        boolean withChooser, String chooserTitle) {
		AGShare.sendEMail(subject, extraImagePaths, recipients, cc, bcc, withChooser, chooserTitle);
	}

	public String saveImageToCache(byte[] data, int width, int height) {
		return AGShare.saveImageToCache(data, width, height);
	}

	//endregion

	//region HARDWARE

	public void enableFlashlight(final boolean enable) {
		AGHardware.enableFlashlight(enable);
	}

	public boolean hasVibrator() {
		return AGHardware.hasVibrator();
	}

	public boolean hasAmplitudeControl() {
		return AGHardware.hasAmplitudeControl();
	}

	public void vibrate(int[] durations, int[] amplitudes, int repeat, int usage, int flags, int contentType) {
		AGHardware.vibrate(durations, amplitudes, repeat, usage, flags, contentType);
	}

	public void stopVibration() {
		AGHardware.stopVibration();
	}

	public int computeRemainingChargeTime() {
		return AGHardware.computeRemainingChargeTime();
	}

	public int getBatteryCapacity() {
		return AGHardware.getBatteryCapacity();
	}

	public int getBatteryChargeCounter() {
		return AGHardware.getBatteryChargeCounter();
	}

	public int getAverageBatteryCurrent() {
		return AGHardware.getAverageBatteryCurrent();
	}

	public int getBatteryCurrent() {
		return AGHardware.getBatteryCurrent();
	}

	public int getBatteryEnergyCounter() {
		return AGHardware.getBatteryEnergyCounter();
	}

	public int getBatteryStatus() {
		return AGHardware.getBatteryStatus();
	}

	public boolean isBatteryLow() {
		return AGHardware.isBatteryLow();
	}

	public int getBatteryHealth() {
		return AGHardware.getBatteryHealth();
	}

	public int getBatteryLevel() {
		return AGHardware.getBatteryLevel();
	}

	public int getBatteryPluggedState() {
		return AGHardware.getBatteryPluggedState();
	}

	public boolean isBatteryPresent() {
		return AGHardware.isBatteryPresent();
	}

	public int getBatteryScale() {
		return AGHardware.getBatteryScale();
	}

	public String getBatteryTechnology() {
		return AGHardware.getBatteryTechnology();
	}

	public int getBatteryTemperature() {
		return AGHardware.getBatteryTemperature();
	}

	public int getBatteryVoltage() {
		return AGHardware.getBatteryVoltage();
	}

	//endregion
}

