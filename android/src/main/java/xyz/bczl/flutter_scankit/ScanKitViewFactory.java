package xyz.bczl.flutter_scankit;

import android.content.Context;
import android.graphics.Rect;
import android.util.Log;
import android.util.LongSparseArray;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.Map;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class ScanKitViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private final ActivityPluginBinding binding;
    private final LongSparseArray<ScanKitCustomMode> customModeList;


    public ScanKitViewFactory(LongSparseArray<ScanKitCustomMode> customModeList,@NonNull BinaryMessenger messenger,ActivityPluginBinding binding) {
        super(StandardMessageCodec.INSTANCE);
        this.customModeList = customModeList;
        this.messenger = messenger;
        this.binding = binding;
    }

    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        if (args instanceof Map) {
            final Map<String, Object> creationParams = (Map<String, Object>) args;
            ScanKitCustomMode mode = new ScanKitCustomMode(viewId,messenger,creationParams,binding);
            customModeList.put(viewId,mode);
            return new ScanKitView(viewId,customModeList);
        }
        throw new RuntimeException("ScanKitViewFactory create args error!");
    }
}
