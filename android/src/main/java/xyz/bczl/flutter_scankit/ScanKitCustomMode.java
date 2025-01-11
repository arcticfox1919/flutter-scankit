package xyz.bczl.flutter_scankit;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.ImageDecoder;
import android.graphics.Rect;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleEventObserver;
import androidx.lifecycle.LifecycleOwner;

import com.huawei.hms.hmsscankit.OnLightVisibleCallBack;
import com.huawei.hms.hmsscankit.OnResultCallback;
import com.huawei.hms.hmsscankit.RemoteView;
import com.huawei.hms.hmsscankit.ScanUtil;
import com.huawei.hms.ml.scan.HmsScan;
import com.huawei.hms.ml.scan.HmsScanAnalyzerOptions;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

@SuppressWarnings("deprecation")
public class ScanKitCustomMode implements LifecycleEventObserver, OnResultCallback, OnLightVisibleCallBack {
    public static final int REQUEST_CODE_PHOTO = 0X1113;
    private int scanTypes = 0;
    private RemoteView remoteView;
    private final EventChannel mEvenChannel;
    private EventChannel.EventSink mEvents;

    private final static int EVENT_SCAN_RESULT = 0;
    private final static int EVENT_LIGHT_VISIBLE = 1;
    private Activity mActivity;

    @SuppressWarnings("unchecked")
    ScanKitCustomMode(int viewId, BinaryMessenger messenger, @Nullable Map<String, Object> creationParam, ActivityPluginBinding binding) {
        mEvenChannel = new EventChannel(messenger, "xyz.bczl.scankit/embedded/result/" + viewId);
        mEvenChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                mEvents = events;
            }

            @Override
            public void onCancel(Object arguments) {
                mEvents = null;
            }
        });

        binding.addActivityResultListener((int requestCode, int resultCode, Intent data) -> {
            if (requestCode == REQUEST_CODE_PHOTO && resultCode == Activity.RESULT_OK) {
                if (mEvents == null) return true;
                try {
                    Bitmap bitmap;
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        ImageDecoder.Source source = ImageDecoder.createSource(mActivity.getContentResolver(), data.getData());
                        ImageDecoder.OnHeaderDecodedListener listener = (decoder, info, source1) -> decoder.setMutableRequired(true);
                        bitmap = ImageDecoder.decodeBitmap(source, listener);
                    } else {
                        bitmap = MediaStore.Images.Media.getBitmap(mActivity.getContentResolver(), data.getData());
                    }
                    HmsScanAnalyzerOptions.Creator creator = new HmsScanAnalyzerOptions.Creator();
                    creator.setPhotoMode(true);

                    int[] args = ScanKitUtilities.getArrayFromFlags(scanTypes);
                    int var1 = args[0];
                    int[] var2 = Arrays.copyOfRange(args, 1, args.length);
                    creator.setHmsScanTypes(var1, var2);

                    HmsScan[] hmsScans = ScanUtil.decodeWithBitmap(mActivity, bitmap, creator.create());
                    if (hmsScans != null && hmsScans.length > 0 && hmsScans[0] != null && !TextUtils.isEmpty(hmsScans[0].getOriginalValue())) {
                        sendEvent(EVENT_SCAN_RESULT, new ScanResult(hmsScans[0].originalValue, ScanKitUtilities.scanTypeToFlags(hmsScans[0].scanType)));
                    } else {
                        mEvents.success(null);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
                return true;
            }
            return false;
        });

        mActivity = binding.getActivity();

        RemoteView.Builder builder = new RemoteView.Builder();
        builder.setContext(mActivity);

        if (creationParam.get("boundingBox") instanceof ArrayList) {
            ArrayList<Integer> list = (ArrayList<Integer>) creationParam.get("boundingBox");
            if (list != null) {
                DisplayMetrics displayMetrics = new DisplayMetrics();
                mActivity.getWindowManager().getDefaultDisplay().getMetrics(displayMetrics);
                float density = displayMetrics.density;
                int left = (int) (list.get(0) * density);
                int top = (int) (list.get(1) * density);
                int width = (int) (list.get(2) * density);
                int height = (int) (list.get(3) * density);
                builder.setBoundingBox(new Rect(left, top, left + width, top + height));
            }
        }

        scanTypes = (int) creationParam.get("format");
        int[] args = ScanKitUtilities.getArrayFromFlags(scanTypes);
        int var1 = args[0];
        int[] var2 = Arrays.copyOfRange(args, 1, args.length);
        builder.setFormat(var1, var2);
        builder.setContinuouslyScan((boolean) creationParam.get("continuouslyScan"));

        remoteView = builder.build();
        remoteView.setOnResultCallback(this);
        remoteView.setOnLightVisibleCallback(this);


        HiddenLifecycleReference reference = (HiddenLifecycleReference) binding.getLifecycle();
        Lifecycle lifecycle = reference.getLifecycle();
        lifecycle.addObserver(this);
    }

    public void pauseContinuouslyScan() {
        if (remoteView != null) remoteView.pauseContinuouslyScan();
    }

    public void resumeContinuouslyScan() {
        if (remoteView != null) remoteView.resumeContinuouslyScan();
    }

    public void switchLight() {
        if (remoteView != null) remoteView.switchLight();
    }

    public void pickPhoto() {
        if (mActivity != null) {
            Intent pickIntent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
            pickIntent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, "image/*");
            mActivity.startActivityForResult(pickIntent, REQUEST_CODE_PHOTO);
        }
    }

    public Boolean getLightStatus() {
        if (remoteView != null) {
            return remoteView.getLightStatus();
        }
        return false;
    }

    public void dispose() {
        if (remoteView != null) {
            remoteView.onPause();
            remoteView.onStop();
            remoteView.onDestroy();
            remoteView = null;
        }
    }

    @Override
    public void onStateChanged(@NonNull LifecycleOwner source, @NonNull Lifecycle.Event event) {
        if (remoteView == null) return;
        switch (event) {
            case ON_CREATE:
                remoteView.onCreate(new Bundle());
                break;
            case ON_START:
                remoteView.onStart();
                break;
            case ON_RESUME:
                remoteView.onResume();
                break;
            case ON_PAUSE:
                remoteView.onPause();
                break;
            case ON_STOP:
                remoteView.onStop();
                break;
            case ON_DESTROY:
                remoteView.onDestroy();
                break;
            default:
        }
    }

    @Override
    public void onVisibleChanged(boolean b) {
        sendEvent(EVENT_LIGHT_VISIBLE, b);
    }

    @Override
    public void onResult(HmsScan[] result) {
        if (result != null && result.length > 0
                && result[0] != null
                && !TextUtils.isEmpty(result[0].getOriginalValue())) {
            sendEvent(
                    EVENT_SCAN_RESULT,
                    new ScanResult(
                            result[0].originalValue,
                            ScanKitUtilities.scanTypeToFlags(result[0].scanType)));
        }
    }

    private void sendEvent(int event, Object result) {
        if (mEvents != null) {
            Map<String, Object> param = new HashMap<>();
            param.put("event", event);

            if (result instanceof ScanResult) {
                param.put("value", ((ScanResult) result).toMap());
            } else {
                param.put("value", result);
            }
            mEvents.success(param);
        }
    }

    public View getView() {
        return remoteView;
    }
}
