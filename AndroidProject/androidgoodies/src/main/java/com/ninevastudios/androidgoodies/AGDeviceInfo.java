package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.content.pm.PackageManager;
import android.util.Log;

import com.ninevastudios.androidgoodies.utils.Constants;

public class AGDeviceInfo {
	public static boolean hasSystemFeature(String feature) {
		Activity activity = AndroidGoodies.getGameActivity();
		if (activity == null) {
			Log.w(Constants.LOG_TAG, "Activity is null. Returning false.");
			return false;
		}

		return activity.getPackageManager().hasSystemFeature(feature);
	}

	public static String getApplicationPackageName() {
		Activity activity = AndroidGoodies.getGameActivity();
		if (activity == null) {
			Log.w(Constants.LOG_TAG, "Activity is null. Returning empty string.");
			return "";
		}

		return activity.getPackageName();
	}

	public static boolean isPackageInstalled(String packageName) {
		Activity activity = AndroidGoodies.getGameActivity();
		if (activity == null) {
			Log.w(Constants.LOG_TAG, "Activity is null. Returning false.");
			return false;
		}

		try {
			activity.getPackageManager().getPackageInfo(packageName, PackageManager.GET_ACTIVITIES);
			return true;
		} catch (Exception e) {
			return false;
		}
	}
}
