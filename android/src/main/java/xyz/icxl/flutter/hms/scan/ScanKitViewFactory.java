package xyz.icxl.flutter.hms.scan;

import android.content.Context;

import androidx.annotation.NonNull;

import java.util.Map;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class ScanKitViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private ActivityPluginBinding binding;


    public ScanKitViewFactory(@NonNull BinaryMessenger messenger,ActivityPluginBinding binding) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
        this.binding = binding;
    }

    @Override
    public PlatformView create(Context context, int viewId, Object args) {
        final Map<String, Object> creationParams = (Map<String, Object>) args;
        return new ScanKitView(messenger, creationParams,binding);
    }
}
