package xyz.bczl.flutter_scankit;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
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
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class ScanKitView implements PlatformView, LifecycleEventObserver,
        MethodChannel.MethodCallHandler, OnResultCallback, OnLightVisibleCallBack {

    public static final int REQUEST_CODE_PHOTO = 0X1113;
    
    private final EventChannel mEvenChannel;
    private final MethodChannel mChannel;
    private EventChannel.EventSink mEvents;
    private RemoteView remoteView;

    private final static int EVENT_SCAN_RESULT = 0;
    private final static int EVENT_LIGHT_VISIBLE = 1;
    
    private Activity mActivity;

    public ScanKitView(BinaryMessenger messenger, @Nullable Map<String, Object> creationParam, ActivityPluginBinding binding){
        Log.d("ScanKitView","ScanKitView create ...");

        mChannel = new MethodChannel(messenger,"xyz.bczl.flutter_scankit/ScanKitWidget");
        mChannel.setMethodCallHandler(this);

        mEvenChannel = new EventChannel(messenger, "xyz.bczl.flutter_scankit/event");
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

        binding.addActivityResultListener((int requestCode, int resultCode, Intent data)->{
            if (requestCode == REQUEST_CODE_PHOTO  && resultCode == Activity.RESULT_OK){
                if (mEvents == null) return true;
                try {
                    Bitmap bitmap = MediaStore.Images.Media.getBitmap(mActivity.getContentResolver(), data.getData());
                    HmsScan[] hmsScans = ScanUtil.decodeWithBitmap(mActivity, bitmap, new HmsScanAnalyzerOptions.Creator().setPhotoMode(true).create());
                    if (hmsScans != null && hmsScans.length > 0 && hmsScans[0] != null && !TextUtils.isEmpty(hmsScans[0].getOriginalValue())) {
                        sendEvent(EVENT_SCAN_RESULT,hmsScans[0].originalValue);
                    }else {
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

        ArrayList<Integer> list = (ArrayList<Integer>) creationParam.get("boundingBox");
        if (list != null){
            builder.setBoundingBox(new Rect(list.get(0),list.get(1),list.get(2),list.get(3)));
        }

        ArrayList<Integer> scanTypes = (ArrayList<Integer>) creationParam.get("format");

        if (scanTypes.size() == 1){
            builder.setFormat(scanTypes.get(0));
        }else {
            builder.setFormat(scanTypes.get(0),ScanKitUtilities.toArray(scanTypes));
        }

        builder.setContinuouslyScan((boolean) creationParam.get("continuouslyScan"));

        remoteView = builder.build();
        remoteView.setOnResultCallback(this);
        remoteView.setOnLightVisibleCallback(this);


        HiddenLifecycleReference reference =
                (HiddenLifecycleReference) binding.getLifecycle();
        Lifecycle lifecycle = reference.getLifecycle();
        lifecycle.addObserver(this);
    }

    @Override
    public View getView() {
        return remoteView;
    }

    @Override
    public void dispose() {
        mChannel.setMethodCallHandler(null);
        mEvenChannel.setStreamHandler(null);

        remoteView.onStop();
        remoteView.onDestroy();
        remoteView = null;
    }

    @Override
    public void onStateChanged(@NonNull LifecycleOwner source, @NonNull Lifecycle.Event event) {
        if (remoteView == null) return;

        switch (event){
            case ON_CREATE:
                remoteView.onCreate(new Bundle());
                Log.d("ScanKitView","onCreate");
                break;
            case ON_START:
                remoteView.onStart();
                Log.d("ScanKitView","onStart");
                break;
            case ON_RESUME:
                remoteView.onResume();
                Log.d("ScanKitView","onResume");
                break;
            case ON_PAUSE:
                remoteView.onPause();
                Log.d("ScanKitView","onPause");
                break;
            case ON_STOP:
                remoteView.onStop();
                Log.d("ScanKitView","onStop");
                break;
            case ON_DESTROY:
                remoteView.onDestroy();
                Log.d("ScanKitView","onDestroy");
                break;
            default:
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method){
            case "pauseContinuouslyScan":
                if (remoteView != null) remoteView.pauseContinuouslyScan();
                result.success(null);
                break;
            case "resumeContinuouslyScan":
                if (remoteView != null) remoteView.resumeContinuouslyScan();
                result.success(null);
                break;
            case "getLightStatus":
                if (remoteView != null) {
                    result.success(remoteView.getLightStatus());
                }
                result.success(false);
                break;
            case "switchLight":
                if (remoteView != null) remoteView.switchLight();
                result.success(null);
                break;
            case "pickPhoto":
                Intent pickIntent = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
                pickIntent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, "image/*");
                mActivity.startActivityForResult(pickIntent, REQUEST_CODE_PHOTO);
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void onResult(HmsScan[] result) {
        if (result != null && result.length > 0 && result[0] != null
                && !TextUtils.isEmpty(result[0].getOriginalValue())) {
            Log.d("ScanKitView","result size "+result.length);
            sendEvent(EVENT_SCAN_RESULT,result[0].getOriginalValue());
        }
    }

    @Override
    public void onVisibleChanged(boolean b) {
        sendEvent(EVENT_LIGHT_VISIBLE,b);
    }

    private void sendEvent(int event, Object val) {
        if(mEvents != null){
            Map<String, Object> param = new HashMap();
            param.put("event", event);
            param.put("value", val);

            mEvents.success(param);
        }
    }
}
