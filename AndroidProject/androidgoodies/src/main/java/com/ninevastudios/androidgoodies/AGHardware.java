package com.ninevastudios.androidgoodies;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.hardware.Camera;
import android.hardware.camera2.CameraManager;
import android.media.AudioAttributes;
import android.os.BatteryManager;
import android.os.Build;
import android.os.VibrationEffect;
import android.os.Vibrator;

import androidx.annotation.Keep;

import android.util.Log;

import com.ninevastudios.androidgoodies.utils.Constants;

@Keep
public class AGHardware {
	private static Camera _camera;
	private static final int UNKNOWN = -1;

	@Keep
	public static void enableFlashlight(final boolean enable) {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return;
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
			enableFlashlightNew(activity, enable);
		} else {
			enableFlashlightOld(activity, enable);
		}
	}

	@Keep
	public static boolean hasVibrator() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return false;
		}

		Vibrator vibrator = (Vibrator) activity.getSystemService(Context.VIBRATOR_SERVICE);
		if (vibrator == null) {
			Log.e(Constants.LOG_TAG, "Vibrator service was not found.");
			return false;
		}

		return vibrator.hasVibrator();
	}

	@Keep
	public static boolean hasAmplitudeControl() {
		if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
			Log.e(Constants.LOG_TAG, "hasAmplitudeControl is not available on this device.");
			return false;
		}

		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return false;
		}

		Vibrator vibrator = (Vibrator) activity.getSystemService(Context.VIBRATOR_SERVICE);
		if (vibrator == null) {
			Log.e(Constants.LOG_TAG, "Vibrator service was not found.");
			return false;
		}

		return vibrator.hasAmplitudeControl();
	}

	@Keep
	public static void vibrate(long[] durations, int[] amplitudes, int repeat, int usage, int flags, int contentType) {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return;
		}

		Vibrator vibrator = (Vibrator) activity.getSystemService(Context.VIBRATOR_SERVICE);
		if (vibrator == null) {
			Log.e(Constants.LOG_TAG, "Vibrator service was not found.");
			return;
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
			VibrationEffect effect = VibrationEffect.createWaveform(durations, amplitudes, repeat);
			AudioAttributes attributes = new AudioAttributes.Builder()
					.setUsage(usage)
					.setFlags(flags)
					.setContentType(contentType)
					.build();
			vibrator.vibrate(effect, attributes);
		} else {
			vibrator.vibrate(durations, repeat);
		}

	}

	@Keep
	public static void stopVibration() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return;
		}

		Vibrator vibrator = (Vibrator) activity.getSystemService(Context.VIBRATOR_SERVICE);

		if (vibrator == null) {
			Log.e(Constants.LOG_TAG, "Vibrator service was not found.");
			return;
		}

		vibrator.cancel();
	}

	@Keep
	public static long computeRemainingChargeTime() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return UNKNOWN;
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
			BatteryManager manager = (BatteryManager) activity.getSystemService(Context.BATTERY_SERVICE);

			long result = manager != null ? manager.computeChargeTimeRemaining() : UNKNOWN;
			Log.d(Constants.LOG_TAG, String.valueOf(result));
			return result;
		}

		return UNKNOWN;
	}

	@Keep
	public static int getBatteryCapacity() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return UNKNOWN;
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
			BatteryManager manager = (BatteryManager) activity.getSystemService(Context.BATTERY_SERVICE);
			return manager != null ? manager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY) : UNKNOWN;
		}

		return UNKNOWN;
	}

	@Keep
	public static int getBatteryChargeCounter() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return UNKNOWN;
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
			BatteryManager manager = (BatteryManager) activity.getSystemService(Context.BATTERY_SERVICE);
			return manager != null ? manager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER) : UNKNOWN;
		}

		return UNKNOWN;
	}

	@Keep
	public static int getAverageBatteryCurrent() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return UNKNOWN;
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
			BatteryManager manager = (BatteryManager) activity.getSystemService(Context.BATTERY_SERVICE);
			return manager != null ? manager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_AVERAGE) : UNKNOWN;
		}

		return UNKNOWN;
	}

	@Keep
	public static int getImmediateBatteryCurrent() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return UNKNOWN;
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
			BatteryManager manager = (BatteryManager) activity.getSystemService(Context.BATTERY_SERVICE);
			return manager != null ? manager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW) : UNKNOWN;
		}

		return UNKNOWN;
	}

	@Keep
	public static int getBatteryCurrent() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return UNKNOWN;
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
			BatteryManager manager = (BatteryManager) activity.getSystemService(Context.BATTERY_SERVICE);
			return manager != null ? manager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW) : UNKNOWN;
		}

		return UNKNOWN;
	}

	@Keep
	public static long getBatteryEnergyCounter() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return UNKNOWN;
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
			BatteryManager manager = (BatteryManager) activity.getSystemService(Context.BATTERY_SERVICE);
			long result = manager != null ? manager.getLongProperty(BatteryManager.BATTERY_PROPERTY_ENERGY_COUNTER) : UNKNOWN;
			result = result == Long.MIN_VALUE ? UNKNOWN : result;
			Log.d(Constants.LOG_TAG, String.valueOf(result));
			return result;
		}

		return UNKNOWN;
	}

	@Keep
	public static int getBatteryStatus() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return UNKNOWN;
		}

		IntentFilter filter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
		Intent batteryIntent = activity.registerReceiver(null, filter);
		if (batteryIntent == null) {
			return BatteryManager.BATTERY_STATUS_UNKNOWN;
		}

		return batteryIntent.getIntExtra(BatteryManager.EXTRA_STATUS, BatteryManager.BATTERY_STATUS_UNKNOWN);
	}

	@Keep
	public static boolean isBatteryLow() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return false;
		}

		IntentFilter filter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
		Intent batteryIntent = activity.registerReceiver(null, filter);
		if (batteryIntent == null) {
			return false;
		}

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
			return batteryIntent.getBooleanExtra(BatteryManager.EXTRA_BATTERY_LOW, false);
		}

		return false;
	}

	@Keep
	public static int getBatteryHealth() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return BatteryManager.BATTERY_HEALTH_UNKNOWN;
		}

		IntentFilter filter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
		Intent batteryIntent = activity.registerReceiver(null, filter);
		if (batteryIntent == null) {
			return BatteryManager.BATTERY_HEALTH_UNKNOWN;
		}

		return batteryIntent.getIntExtra(BatteryManager.EXTRA_HEALTH, BatteryManager.BATTERY_HEALTH_UNKNOWN);
	}

	@Keep
	public static int getBatteryLevel() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return UNKNOWN;
		}

		IntentFilter filter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
		Intent batteryIntent = activity.registerReceiver(null, filter);
		if (batteryIntent == null) {
			return UNKNOWN;
		}

		return batteryIntent.getIntExtra(BatteryManager.EXTRA_LEVEL, UNKNOWN);
	}

	@Keep
	public static int getBatteryPluggedState() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return 0;
		}

		IntentFilter filter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
		Intent batteryIntent = activity.registerReceiver(null, filter);
		if (batteryIntent == null) {
			return 0;
		}

		return batteryIntent.getIntExtra(BatteryManager.EXTRA_PLUGGED, 0);
	}

	@Keep
	public static boolean isBatteryPresent() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return false;
		}

		IntentFilter filter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
		Intent batteryIntent = activity.registerReceiver(null, filter);
		if (batteryIntent == null) {
			return false;
		}

		return batteryIntent.getBooleanExtra(BatteryManager.EXTRA_PRESENT, false);
	}

	@Keep
	public static int getBatteryScale() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return UNKNOWN;
		}

		IntentFilter filter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
		Intent batteryIntent = activity.registerReceiver(null, filter);
		if (batteryIntent == null) {
			return UNKNOWN;
		}

		return batteryIntent.getIntExtra(BatteryManager.EXTRA_SCALE, UNKNOWN);
	}

	@Keep
	public static String getBatteryTechnology() {
		String unknownString = "Unknown";

		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return unknownString;
		}

		IntentFilter filter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
		Intent batteryIntent = activity.registerReceiver(null, filter);
		if (batteryIntent == null) {
			return unknownString;
		}

		String result = batteryIntent.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY);
		return result == null ? unknownString : result;
	}

	@Keep
	public static int getBatteryTemperature() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return Integer.MIN_VALUE;
		}

		IntentFilter filter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
		Intent batteryIntent = activity.registerReceiver(null, filter);
		if (batteryIntent == null) {
			return Integer.MIN_VALUE;
		}

		return batteryIntent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, Integer.MIN_VALUE);
	}

	@Keep
	public static int getBatteryVoltage() {
		Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return 0;
		}

		IntentFilter filter = new IntentFilter(Intent.ACTION_BATTERY_CHANGED);
		Intent batteryIntent = activity.registerReceiver(null, filter);
		if (batteryIntent == null) {
			return 0;
		}

		return batteryIntent.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 0);
	}

	private static void enableFlashlightOld(Activity activity, final boolean enable) {
		try {
			activity.runOnUiThread(new Runnable() {
				@Override
				public void run() {
					if (enable) {
						_camera = Camera.open();
						Camera.Parameters cameraParameters = _camera.getParameters();
						cameraParameters.setFlashMode(Camera.Parameters.FLASH_MODE_ON);
						_camera.setParameters(cameraParameters);
						_camera.startPreview();
					} else {
						if (_camera != null) {
							_camera.stopPreview();
							_camera.release();
							_camera = null;
						}
					}
				}
			});
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@TargetApi(Build.VERSION_CODES.M)
	private static void enableFlashlightNew(Activity activity, final boolean enable) {
		try {
			CameraManager cameraManager = (CameraManager) activity.getSystemService(Context.CAMERA_SERVICE);
			if (cameraManager != null) {
				String cameraId = cameraManager.getCameraIdList()[0];
				cameraManager.setTorchMode(cameraId, enable);
			} else {
				Log.d(Constants.LOG_TAG, "enableFlashlight: could not get camera manager");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
