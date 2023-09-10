package xyz.bczl.flutter_scankit;

import android.app.Activity;
import android.util.LongSparseArray;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;

/**
 * FlutterScankitPlugin
 */
public class FlutterScanKitPlugin implements FlutterPlugin, ScanKitAPI.ScanKitApi, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private FlutterPluginBinding mPluginBinding;
    private ActivityPluginBinding mBinding;
    private Activity mActivity;

    private final AtomicLong defaultModeId = new AtomicLong(0);

    private final LongSparseArray<ScanKitDefaultMode> defaultModeList = new LongSparseArray<>();
    private final LongSparseArray<ScanKitCustomMode> customModeList = new LongSparseArray<>();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        ScanKitAPI.ScanKitApi.setup(binding.getBinaryMessenger(), this);
        mPluginBinding = binding;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        ScanKitAPI.ScanKitApi.setup(binding.getBinaryMessenger(), null);
        defaultModeList.clear();
        customModeList.clear();
        mPluginBinding = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        mBinding = binding;
        mActivity = binding.getActivity();
        // register platform view
        if (mPluginBinding != null) {
            mPluginBinding.getPlatformViewRegistry().registerViewFactory(
                    "ScanKitWidgetType", new ScanKitViewFactory(
                            customModeList,
                            mPluginBinding.getBinaryMessenger(),
                            binding));
        }
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        mActivity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        mActivity = null;
    }

    @NonNull
    @Override
    public Long createDefaultMode() {
        long val = defaultModeId.incrementAndGet();
        defaultModeList.put(
                val,
                new ScanKitDefaultMode(
                        (int) val,
                        mBinding,
                        mPluginBinding.getBinaryMessenger()));
        return val;
    }

    @Override
    public void disposeDefaultMode(@NonNull Long id) {
        ScanKitDefaultMode mode = defaultModeList.get(id);
        if (mode != null) {
            customModeList.remove(id);
            mode.dispose();
        }
    }

    @Override
    public void disposeCustomizedMode(@NonNull Long cusId) {
        ScanKitCustomMode mode = customModeList.get(cusId);
        if (mode != null) {
            customModeList.remove(cusId);
            mode.dispose();
        }
    }

    @NonNull
    @Override
    public Long startScan(@NonNull Long defaultId, @NonNull Long type, @NonNull Map<String, Object> options) {
        ScanKitDefaultMode mode = defaultModeList.get(defaultId);
        if (mode != null) return ((long) mode.startScan(type, options));

        throw new ScanKitAPI.FlutterError("100", "ScanKitDefaultMode does not exist, " +
                "please check if it was initialized successfully!", null);
    }

    @Override
    public void pauseContinuouslyScan(@NonNull Long cusId) {
        ScanKitCustomMode mode = customModeList.get(cusId);
        if (mode != null) {
            mode.pauseContinuouslyScan();
        }
    }

    @Override
    public void resumeContinuouslyScan(@NonNull Long cusId) {
        ScanKitCustomMode mode = customModeList.get(cusId);
        if (mode != null) {
            mode.resumeContinuouslyScan();
        }
    }

    @Override
    public void switchLight(@NonNull Long cusId) {
        ScanKitCustomMode mode = customModeList.get(cusId);
        if (mode != null) {
            mode.switchLight();
        }
    }

    @Override
    public void pickPhoto(@NonNull Long cusId) {
        ScanKitCustomMode mode = customModeList.get(cusId);
        if (mode != null) {
            mode.pickPhoto();
        }
    }

    @NonNull
    @Override
    public Boolean getLightStatus(@NonNull Long cusId) {
        ScanKitCustomMode mode = customModeList.get(cusId);
        if (mode != null) {
            return mode.getLightStatus();
        }
        return false;
    }

    @NonNull
    @Override
    public Map<String, Object> decodeYUV(@NonNull byte[] yuv,
                                      @NonNull Long width, @NonNull Long height,
                                      @NonNull Map<String, Object> options) {
        if (mActivity == null) {
            throw new ScanKitAPI.FlutterError("102", "decode: Activity is null!", "");
        }
        return ScanKitBitmapMode.decode(mActivity, yuv, width, height,options);
    }

    @NonNull
    @Override
    public Map<String, Object> decode(@NonNull byte[] bytes, @NonNull Long width, @NonNull Long height, @NonNull Map<String, Object> options) {
        throw new ScanKitAPI.FlutterError("notImplemented", "[decode] Method not implemented!", "");
    }

    @NonNull
    @Override
    public Map<String, Object> decodeBitmap(@NonNull byte[] data, @NonNull Map<String, Object> options) {
        if (mActivity == null) {
            throw new ScanKitAPI.FlutterError("102", "decode: Activity is null!", "");
        }
        return ScanKitBitmapMode.decodeBitmap(mActivity, data,options);
    }

    @NonNull
    @Override
    public byte[] encode(@NonNull String content, @NonNull Long width, @NonNull Long height, @NonNull Map<String, Object> options) {
        return ScanKitBitmapMode.encode(content,width,height,options);
    }
}
