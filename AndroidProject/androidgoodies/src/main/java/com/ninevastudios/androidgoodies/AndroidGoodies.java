package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.support.annotation.NonNull;
import android.support.v4.util.ArraySet;
import android.util.Log;
import android.widget.Toast;

import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.GodotPlugin;
import org.godotengine.godot.plugin.SignalInfo;

import java.util.Arrays;
import java.util.List;
import java.util.Set;

public class AndroidGoodies extends GodotPlugin {
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

	@NonNull
	public String getPluginName() {
		return "AndroidGoodies";
	}

	@NonNull
	public List<String> getPluginMethods() {
		return Arrays.asList("showToast");
	}

	@NonNull
	public Set<SignalInfo> getPluginSignals() {
		Set<SignalInfo> signals = new ArraySet<>();
		signals.add(new SignalInfo("showToast", String.class, Integer.class));
		return signals;
	}
}

