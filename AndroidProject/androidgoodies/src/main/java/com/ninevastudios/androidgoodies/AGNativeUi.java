package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;
import android.widget.Toast;

public class AGNativeUi {

	public static void showToast(final String toast, final int length) {
		final Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(AndroidGoodies.TAG, "Activity was not found. Aborting.");
			return;
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Toast.makeText(activity, toast, length).show();
			}
		});
	}

	public static void showConfirmationDialog(final String title, final String body, final String buttonText, final int theme) {
		final Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(AndroidGoodies.TAG, "Activity was not found. Aborting.");
			return;
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				AlertDialog.Builder builder = getDialogBuilder(activity, title, body, theme);

				builder.setPositiveButton(buttonText, onPositiveButtonClickListener);

				showDialog(builder);
			}
		});
	}

	private static AlertDialog.Builder getDialogBuilder(Activity activity, String title, String body, int theme) {
		AlertDialog.Builder builder = new AlertDialog.Builder(activity, theme);

		builder.setTitle(title);
		builder.setMessage(body);

		return builder;
	}

	private static void showDialog(AlertDialog.Builder builder) {
		AlertDialog dialog = builder.create();
		dialog.show();
	}

	static DialogInterface.OnClickListener onPositiveButtonClickListener = new DialogInterface.OnClickListener() {
		@Override
		public void onClick(DialogInterface dialog, int which) {
			AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_POSITIVE_BUTTON_CLICKED);
		}
	};

	static DialogInterface.OnClickListener onNegativeButtonClickListener = new DialogInterface.OnClickListener() {
		@Override
		public void onClick(DialogInterface dialog, int which) {
			AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_NEGATIVE_BUTTON_CLICKED);
		}
	};

	static DialogInterface.OnClickListener onNeutralButtonClickListener = new DialogInterface.OnClickListener() {
		@Override
		public void onClick(DialogInterface dialog, int which) {
			AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_NEUTRAL_BUTTON_CLICKED);
		}
	};

	static DialogInterface.OnClickListener onItemClickListener = new DialogInterface.OnClickListener() {
		@Override
		public void onClick(DialogInterface dialog, int which) {
		}
	};

	static DialogInterface.OnClickListener onSingleChoiceItemClickListener = new DialogInterface.OnClickListener() {
		@Override
		public void onClick(DialogInterface dialog, int which) {
		}
	};

	static DialogInterface.OnMultiChoiceClickListener onMultiChoiceClickListener = new DialogInterface.OnMultiChoiceClickListener() {
		@Override
		public void onClick(DialogInterface dialog, int which, boolean isChecked) {
		}
	};

	static DialogInterface.OnCancelListener onCancelListener = new DialogInterface.OnCancelListener() {
		@Override
		public void onCancel(DialogInterface dialog) {
		}
	};
}
