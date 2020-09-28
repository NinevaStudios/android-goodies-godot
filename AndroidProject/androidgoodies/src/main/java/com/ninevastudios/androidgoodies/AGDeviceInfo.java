package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.util.Log;

import static com.google.android.vending.expansion.downloader.Constants.TAG;

public class AGDeviceInfo {
	public static boolean hasSystemFeature(String feature) {
		Activity activity = AndroidGoodies.getGameActivity();
		if (activity == null) {
			Log.w(TAG, "Activity is null. Returning false.");
			return false;
		}

		return activity.getPackageManager().hasSystemFeature(feature);
	}

	public static String getApplicationPackageName() {
		Activity activity = AndroidGoodies.getGameActivity();
		if (activity == null) {
			Log.w(TAG, "Activity is null. Returning empty string.");
			return "";
		}

		return activity.getPackageName();
	}
}
