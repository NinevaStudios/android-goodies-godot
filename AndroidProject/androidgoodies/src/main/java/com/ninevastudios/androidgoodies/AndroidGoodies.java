package com.ninevastudios.androidgoodies;

import android.app.Activity;

import androidx.annotation.NonNull;
import androidx.collection.ArraySet;

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
	static final String SIGNAL_ON_DIALOG_ITEM_CLICKED = "onDialogItemClicked";

	@NonNull
	public String getPluginName() {
		return TAG;
	}

	@NonNull
	public List<String> getPluginMethods() {
		return Arrays.asList(
				"showToast",
				"showButtonDialog",
				"showItemsDialog",
				"showSingleChoiceDialog");
	}

	@NonNull
	public Set<SignalInfo> getPluginSignals() {
		Set<SignalInfo> signals = new ArraySet<>();
		signals.add(new SignalInfo(SIGNAL_ON_POSITIVE_BUTTON_CLICKED));
		signals.add(new SignalInfo(SIGNAL_ON_NEGATIVE_BUTTON_CLICKED));
		signals.add(new SignalInfo(SIGNAL_ON_NEUTRAL_BUTTON_CLICKED));
		signals.add(new SignalInfo(SIGNAL_ON_DIALOG_CANCELLED));
		signals.add(new SignalInfo(SIGNAL_ON_DIALOG_ITEM_CLICKED, Integer.class));
		return signals;
	}

	//endregion

	//region HELPERS

	public static String TAG = "AndroidGoodies";

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

	//endregion
}

