package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.util.Log;

import com.ninevastudios.androidgoodies.utils.Constants;

public class AGProgressDialog {
	
	private static DialogInterface.OnCancelListener onCancelListener = new DialogInterface.OnCancelListener() {
		@Override
		public void onCancel(DialogInterface dialog) {
			AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_DIALOG_CANCELLED);
		}
	};
	
	private static DialogInterface.OnDismissListener onDismissListener = new DialogInterface.OnDismissListener() {
		@Override
		public void onDismiss(DialogInterface dialog) {
			AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_PROGRESS_DIALOG_DISMISSED);
		}
	};

	private static ProgressDialog _progressDialog;

	public static void show(final String title, final String message, final int progress, final int maxValue, final int theme, final boolean isCancellable, final boolean isIndeterminate) {
		final Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return;
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				_progressDialog = new ProgressDialog(activity, theme);

				_progressDialog.setCancelable(isCancellable);
				_progressDialog.setIndeterminate(isIndeterminate);
				_progressDialog.setTitle(title);
				_progressDialog.setMessage(message);
				_progressDialog.setProgress(progress);
				_progressDialog.setMax(maxValue);
				_progressDialog.setProgressStyle(isIndeterminate ? ProgressDialog.STYLE_SPINNER : ProgressDialog.STYLE_HORIZONTAL);

				_progressDialog.setOnCancelListener(onCancelListener);
				_progressDialog.setOnDismissListener(onDismissListener);

				_progressDialog.show();
			}
		});
	}

	public static void dismiss() {
		final Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return;
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				_progressDialog.dismiss();
				_progressDialog = null;
			}
		});
	}

	public static void setProgress(final int progress) {
		final Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return;
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				_progressDialog.setProgress(progress);
			}
		});
	}
	
	public static void pause() {
		final Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return;
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				if (_progressDialog != null) {
					_progressDialog.hide();
				}
			}
		});

	}
	
	public static void resume() {
		final Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
			return;
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				if (_progressDialog != null) {
					_progressDialog.show();
				}
			}
		});
	}
}
