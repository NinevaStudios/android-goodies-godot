package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.collection.ArraySet;

import com.ninevastudios.androidgoodies.multipicker.api.Picker;
import com.ninevastudios.androidgoodies.utils.Constants;

import org.godotengine.godot.Dictionary;
import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;

import java.util.Arrays;
import java.util.List;
import java.util.Set;

import static com.google.android.vending.expansion.downloader.Constants.TAG;

public class AndroidGoodies extends GodotPlugin {
	//region GODOT_IMPLEMENTATION

	static final String SIGNAL_ON_POSITIVE_BUTTON_CLICKED = "onPositiveButtonClicked";
	static final String SIGNAL_ON_NEGATIVE_BUTTON_CLICKED = "onNegativeButtonClicked";
	static final String SIGNAL_ON_NEUTRAL_BUTTON_CLICKED = "onNeutralButtonClicked";
	static final String SIGNAL_ON_DIALOG_CANCELLED = "onDialogCancelled";
	static final String SIGNAL_ON_DIALOG_ITEM_CLICKED = "onDialogItemClicked";
	static final String SIGNAL_ON_DIALOG_ITEM_SELECTED = "onDialogItemSelected";
	static final String SIGNAL_ON_IMAGES_PICKED = "onImagesPicked";
	static final String SIGNAL_ON_VIDEOS_PICKED = "onVideosPicked";
	static final String SIGNAL_ON_FILES_PICKED = "onFilesPicked";
	static final String SIGNAL_ON_CONTACT_PICKED = "onContactPicked";
	static final String SIGNAL_ON_AUDIO_PICKED = "onAudioPicked";

	@NonNull
	public String getPluginName() {
		return Constants.LOG_TAG;
	}

	@NonNull
	public List<String> getPluginMethods() {
		return Arrays.asList(
				"showToast",
				"showButtonDialog",
				"showItemsDialog",
				"showSingleChoiceDialog",
				"showMultipleChoiceDialog");
	}

	@NonNull
	public Set<SignalInfo> getPluginSignals() {
		Set<SignalInfo> signals = new ArraySet<>();
		signals.add(new SignalInfo(SIGNAL_ON_POSITIVE_BUTTON_CLICKED));
		signals.add(new SignalInfo(SIGNAL_ON_NEGATIVE_BUTTON_CLICKED));
		signals.add(new SignalInfo(SIGNAL_ON_NEUTRAL_BUTTON_CLICKED));
		signals.add(new SignalInfo(SIGNAL_ON_DIALOG_CANCELLED));
		signals.add(new SignalInfo(SIGNAL_ON_DIALOG_ITEM_CLICKED, Integer.class));
		signals.add(new SignalInfo(SIGNAL_ON_DIALOG_ITEM_SELECTED, Integer.class, Boolean.class));
		signals.add(new SignalInfo(SIGNAL_ON_IMAGES_PICKED, Object[].class));
		signals.add(new SignalInfo(SIGNAL_ON_VIDEOS_PICKED, Object[].class));
		signals.add(new SignalInfo(SIGNAL_ON_FILES_PICKED, Object[].class));
		signals.add(new SignalInfo(SIGNAL_ON_CONTACT_PICKED, Dictionary.class));
		signals.add(new SignalInfo(SIGNAL_ON_AUDIO_PICKED, Object[].class));
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

	boolean m_IsAvailableForPick;

	public void onMainActivityResult(int requestCode, int resultCode, Intent intent) {
		Log.d(Constants.LOG_TAG, ">>> onActivityResult: " + requestCode + " " + resultCode + " " + intent);
		m_IsAvailableForPick = true;

		AGPickers.handleMainActivityResult(getGameActivity(), requestCode, resultCode, intent);
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

	//endregion

	//region PICKERS

	public void pickImages(int pickerType, int maxSize, boolean generateThumbnails, boolean allowMultiple) {
		if (!m_IsAvailableForPick) {
			Log.w(TAG, "Activity is busy. Will not start picking.");
			return;
		}

		m_IsAvailableForPick = false;
		AGPickers.pickImages(pickerType, maxSize, generateThumbnails, allowMultiple);
	}

	//endregion
}

