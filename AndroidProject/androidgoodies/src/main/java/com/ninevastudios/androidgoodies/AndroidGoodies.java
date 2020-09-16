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

	@NonNull
	public String getPluginName() {
		return TAG;
	}

	@NonNull
	public List<String> getPluginMethods() {
		return Arrays.asList(
				"showToast",
				"showButtonDialog");
	}

	@NonNull
	public Set<SignalInfo> getPluginSignals() {
		Set<SignalInfo> signals = new ArraySet<>();
		signals.add(new SignalInfo(SIGNAL_ON_POSITIVE_BUTTON_CLICKED));
		signals.add(new SignalInfo(SIGNAL_ON_NEGATIVE_BUTTON_CLICKED));
		signals.add(new SignalInfo(SIGNAL_ON_NEUTRAL_BUTTON_CLICKED));
		signals.add(new SignalInfo(SIGNAL_ON_DIALOG_CANCELLED));
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

	public void showButtonDialog(final String title, final String body, final String positiveButtonText,
	                             final String negativeButtonText, final String neutralButtonText,
	                             final int theme, boolean isCancellable) {
		AGNativeUi.showButtonDialog(title, body, positiveButtonText, negativeButtonText, neutralButtonText, theme, isCancellable);
	}

	//endregion
}

