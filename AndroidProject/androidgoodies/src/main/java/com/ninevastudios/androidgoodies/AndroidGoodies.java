package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.collection.ArraySet;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;

import java.util.Arrays;
import java.util.List;
import java.util.Set;

public class AndroidGoodies extends GodotPlugin {

	public static final String SIGNAL_ON_CONFIRM_BUTTON_CLICKED = "onConfirmButtonClicked";

	public AndroidGoodies(Godot godot) {
		super(godot);
	}

	public void showToast(final String toast, final int length) {
		final Activity activity = getActivity();

		if (activity == null) {
			Log.d(getPluginName(), "Could not get Activity");
			return;
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Toast.makeText(activity, toast, length).show();
			}
		});
	}

	public void showConfirmationDialog(final String title, final String body, final String buttonText, final int theme) {
		final Activity activity = getActivity();

		if (activity == null) {
			Log.d(getPluginName(), "Could not get Activity");
			return;
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				AlertDialog.Builder builder = new AlertDialog.Builder(activity, theme);

				builder.setTitle(title);
				builder.setMessage(body);

				builder.setPositiveButton(buttonText, new DialogInterface.OnClickListener() {
					@Override
					public void onClick(DialogInterface dialog, int which) {
						onConfirmButtonClicked();
					}
				});

				final AlertDialog dialog = builder.create();
				dialog.show();
			}
		});
	}

	public void onConfirmButtonClicked() {
		this.emitSignal(SIGNAL_ON_CONFIRM_BUTTON_CLICKED);
	}

	@NonNull
	public String getPluginName() {
		return "AndroidGoodies";
	}

	@NonNull
	public List<String> getPluginMethods() {
		return Arrays.asList(
				"showToast",
				"showConfirmationDialog");
	}

	@NonNull
	public Set<SignalInfo> getPluginSignals() {
		Set<SignalInfo> signals = new ArraySet<>();
		signals.add(new SignalInfo(SIGNAL_ON_CONFIRM_BUTTON_CLICKED));
		return signals;
	}
}

