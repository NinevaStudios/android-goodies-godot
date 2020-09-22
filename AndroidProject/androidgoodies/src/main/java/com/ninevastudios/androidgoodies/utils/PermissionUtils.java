package com.ninevastudios.androidgoodies.utils;

import android.app.Activity;
import android.content.Intent;

import androidx.core.app.ActivityCompat;

public final class PermissionUtils {

	private static final String EXTRAS_PERMISSIONS = "EXTRAS_PERMISSIONS";

	public static void requestPermissions(Intent data, Activity activity, int requestCode) {
		String[] permissions = data.getStringArrayExtra(EXTRAS_PERMISSIONS);
		ActivityCompat.requestPermissions(activity, permissions, requestCode);
	}

	public static void handleRequestPermissionsResult(String[] permissions, int[] grantResults) {
		//TODO
	}
}
