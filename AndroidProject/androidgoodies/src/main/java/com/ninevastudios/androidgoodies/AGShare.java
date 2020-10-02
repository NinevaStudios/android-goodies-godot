package com.ninevastudios.androidgoodies;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.telephony.SmsManager;
import android.util.Log;

import androidx.core.content.FileProvider;

import com.ninevastudios.androidgoodies.utils.Constants;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.UUID;

public class AGShare {
    private static final int maxSmsLength = 140;
    private static final String mimeTypeTextPlain = "text/plain";
    private static final String mimeTypeImageAll = "image/*";
    private static final String mimeTypeVideoAll = "video/*";
    private static final String mimeTypeAllFiles = "*/*";
    private static final String extraSmsBody = "sms_body";
    private static final String extraAddress = "address";

    public static void shareText(String subject, String textBody,
                                 boolean withChooser, String chooserTitle) {
        launchShareIntent(withChooser, chooserTitle,
                createShareTextIntent(subject, textBody));
    }


    public static void shareImage(String imagePath, boolean withChooser,
                                  String chooserTitle) {
        launchShareIntent(withChooser, chooserTitle,
                createShareImageIntent(imagePath));
    }


    public static void shareTextWithImage(String subject, String textBody,
                                          String imagePath, boolean withChooser, String chooserTitle) {
        launchShareIntent(withChooser, chooserTitle,
                createShareTextWithImageIntent(subject, textBody, imagePath));
    }


    public static void shareVideo(final String videoPath, final boolean withChooser,
                                  final String chooserTitle) {
        Activity activity = AndroidGoodies.getGameActivity();

        if (activity == null) {
            Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
            return;
        }

        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                launchShareIntent(withChooser, chooserTitle, createShareVideoIntent(videoPath));
            }
        });
    }


    public static void sendSmsViaMessagingApp(String phoneNumber, String message,
                                              boolean withChooser, String chooserTitle) {
        launchShareIntent(withChooser, chooserTitle, createSmsIntent(phoneNumber, message));
    }


    public static void sendSmsDirectly(String phoneNumber, String message) {
        SmsManager smsManager = SmsManager.getDefault();
        if (message.length() <= maxSmsLength) {
            smsManager.sendTextMessage(phoneNumber, null, message, null, null);
        } else {
            ArrayList<String> messages = smsManager.divideMessage(message);
            smsManager.sendMultipartTextMessage(phoneNumber, null, messages, null, null);
        }
    }


    public static void sendEMail(String subject, String textBody, String imagePath,
                                 String[] recipients, String[] cc, String[] bcc,
                                 boolean withChooser, String chooserTitle) {
        Intent intent = createEMailIntent(subject, textBody, recipients, cc, bcc);

        if (!imagePath.isEmpty()) {
            Uri path = Uri.fromFile(new File(imagePath));
            intent.putExtra(Intent.EXTRA_STREAM, path);
        }

        try {
            launchShareIntent(withChooser, chooserTitle, intent);
        } catch (Exception e) {
            Log.d(Constants.LOG_TAG, e.getMessage());
        }
    }

    public static void sendEMail(String subject, String[] extraImagePaths, String[] recipients, String[] cc, String[] bcc, boolean withChooser, String chooserTitle) {
        Activity activity = AndroidGoodies.getGameActivity();

        if (activity == null) {
            Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
            return;
        }

        Intent intent = createMultiImageEMailIntent(subject, recipients, cc, bcc);
        ArrayList<Uri> paths = new ArrayList<>();

        if (extraImagePaths.length > 0) {
            for (String extraImagePath : extraImagePaths) {
                Uri arrayPath = FileProvider.getUriForFile(activity, getAuthority(), new File(extraImagePath));
                paths.add(arrayPath);
            }
            intent.putParcelableArrayListExtra(Intent.EXTRA_STREAM, paths);
        }

        try {
            launchShareIntent(withChooser, chooserTitle, intent);
        } catch (Exception e) {
            Log.d(Constants.LOG_TAG, e.getMessage());
        }
    }

    public static String saveImageToCache(byte[] data, int width, int height) {
        Activity activity = AndroidGoodies.getGameActivity();

        if (activity == null) {
            Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
            return "";
        }

        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        ByteBuffer byteBuffer = ByteBuffer.wrap(data);
        bitmap.copyPixelsFromBuffer(byteBuffer);
        File root = activity.getCacheDir();
        File file = new File(root, UUID.randomUUID().toString() + ".png");

        Log.d(Constants.LOG_TAG, file.getAbsolutePath());

        try {
            FileOutputStream out = new FileOutputStream(file);
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, out);
            out.flush();
            out.close();
            return file.getAbsolutePath();
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    private static Intent createShareTextIntent(String subject, String textBody) {
        return new Intent(Intent.ACTION_SEND)
                .setType(mimeTypeTextPlain)
                .putExtra(Intent.EXTRA_SUBJECT, subject)
                .putExtra(Intent.EXTRA_TEXT, textBody);
    }

    private static Intent createShareImageIntent(String imagePath) {
        Activity activity = AndroidGoodies.getGameActivity();

        if (activity == null) {
            Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
            return null;
        }

        Uri path = FileProvider.getUriForFile(activity, getAuthority(), new File(imagePath));

        return new Intent(Intent.ACTION_SEND)
                .setType(mimeTypeImageAll)
                .putExtra(Intent.EXTRA_STREAM, path);
    }

    private static Intent createShareTextWithImageIntent(String subject, String textBody, String imagePath) {
        Activity activity = AndroidGoodies.getGameActivity();

        if (activity == null) {
            Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
            return null;
        }

        Uri path = FileProvider.getUriForFile(activity, getAuthority(), new File(imagePath));

        return new Intent(Intent.ACTION_SEND)
                .setType(mimeTypeAllFiles)
                .putExtra(Intent.EXTRA_STREAM, path)
                .putExtra(Intent.EXTRA_SUBJECT, subject)
                .putExtra(Intent.EXTRA_TEXT, textBody);
    }

    private static Intent createShareVideoIntent(String videoPath) {
        Activity activity = AndroidGoodies.getGameActivity();

        if (activity == null) {
            Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
            return null;
        }

        Uri path = FileProvider.getUriForFile(activity, getAuthority(), new File(videoPath));

        return new Intent(Intent.ACTION_SEND)
                .setType(mimeTypeVideoAll)
                .putExtra(Intent.EXTRA_STREAM, path);
    }

    public static String getAuthority() {
        Activity activity = AndroidGoodies.getGameActivity();

        if (activity == null) {
            Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
            return "";
        }

        return activity.getPackageName() + ".multipicker.fileprovider";
    }

    private static Intent createSmsIntent(String phoneNumber, String message) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            intent.setData(Uri.parse("sms:" + phoneNumber));
        } else {
            intent.setType("vnd.android-dir/mms-sms");
            intent.putExtra(extraAddress, phoneNumber);
        }
        intent.putExtra(extraSmsBody, message);
        return intent;
    }

    private static Intent createEMailIntent(String subject, String textBody, String[] recipients,
                                            String[] cc, String[] bcc) {
        return new Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:"))
                .putExtra(Intent.EXTRA_SUBJECT, subject)
                .putExtra(Intent.EXTRA_TEXT, textBody)
                .putExtra(Intent.EXTRA_EMAIL, recipients)
                .putExtra(Intent.EXTRA_CC, cc)
                .putExtra(Intent.EXTRA_BCC, bcc);
    }

    private static Intent createMultiImageEMailIntent(String subject, String[] recipients,
                                                      String[] cc, String[] bcc) {

        return new Intent(Intent.ACTION_SEND_MULTIPLE)
                .setData(Uri.parse("mailto:"))
                .setType("plain/text")
                .putExtra(Intent.EXTRA_SUBJECT, subject)
                .putExtra(Intent.EXTRA_EMAIL, recipients)
                .putExtra(Intent.EXTRA_CC, cc)
                .putExtra(Intent.EXTRA_BCC, bcc);
    }

    private static void launchShareIntent(boolean withChooser, String chooserTitle, Intent intent) {
        Activity activity = AndroidGoodies.getGameActivity();

        if (activity == null) {
            Log.e(Constants.LOG_TAG, "Activity was not found. Aborting.");
            return;
        }

        if (withChooser) {
            Intent chooserIntent = Intent.createChooser(intent, chooserTitle);
            activity.startActivity(chooserIntent);
        } else {
            activity.startActivity(intent);
        }
    }
}
