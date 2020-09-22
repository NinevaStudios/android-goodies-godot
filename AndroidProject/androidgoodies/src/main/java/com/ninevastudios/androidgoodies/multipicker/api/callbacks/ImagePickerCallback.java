package com.ninevastudios.androidgoodies.multipicker.api.callbacks;

import com.ninevastudios.androidgoodies.multipicker.api.entity.ChosenImage;

import java.util.List;

/**
 * Created by kbibek on 2/23/16.
 */
public interface ImagePickerCallback extends PickerCallback {
    void onImagesChosen(List<ChosenImage> images);
}
