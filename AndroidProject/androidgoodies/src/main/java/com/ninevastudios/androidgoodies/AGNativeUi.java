package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;
import android.widget.Toast;

import static com.ninevastudios.androidgoodies.AndroidGoodies.TAG;

public class AGNativeUi {

	public static void showToast(final String toast, final int length) {
		final Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(TAG, "Activity was not found. Aborting.");
			return;
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Toast.makeText(activity, toast, length).show();
			}
		});
	}

	public static void showButtonDialog(final String title, final String body, final String positiveButtonText,
	                                    final String negativeButtonText, final String neutralButtonText,
	                                    final int theme, final boolean isCancellable) {
		final Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(TAG, "Activity was not found. Aborting.");
			return;
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				AlertDialog.Builder builder = getDialogBuilder(activity, title, body, theme, isCancellable);

				if (positiveButtonText != null) {
					builder.setPositiveButton(positiveButtonText, onPositiveButtonClickListener);
				}
				if (negativeButtonText != null) {
					builder.setNegativeButton(negativeButtonText, onNegativeButtonClickListener);
				}
				if (neutralButtonText != null) {
					builder.setNeutralButton(neutralButtonText, onNeutralButtonClickListener);
				}

				showDialog(builder);
			}
		});
	}

	public static void showItemsDialog(final String title, final String[] items, final int theme, final boolean isCancellable) {
		final Activity activity = AndroidGoodies.getGameActivity();

		if (activity == null) {
			Log.e(TAG, "Activity was not found. Aborting.");
			return;
		}

		if (items == null || items.length < 1) {
			Log.e(TAG, "Items array is empty");
			return;
		}

		activity.runOnUiThread(new Runnable() {
			@Override
			public void run() {
				AlertDialog.Builder builder = getDialogBuilder(activity, title, null, theme, isCancellable);

				builder.setItems(items, onItemClickListener);

				showDialog(builder);
			}
		});
	}

	private static AlertDialog.Builder getDialogBuilder(Activity activity, String title, String body, int theme, boolean isCancellable) {
		AlertDialog.Builder builder = new AlertDialog.Builder(activity, theme);

		builder.setTitle(title);

		if (body != null) {
			builder.setMessage(body);
		}

		builder.setCancelable(isCancellable);
		builder.setOnCancelListener(onCancelListener);

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
			AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_DIALOG_ITEM_CLICKED, which);
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
			AndroidGoodies.getInstance().emitSignalCallback(AndroidGoodies.SIGNAL_ON_DIALOG_CANCELLED);
		}
	};
}
