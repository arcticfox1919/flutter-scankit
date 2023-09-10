package xyz.bczl.flutter_scankit;

import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;

import com.huawei.hms.hmsscankit.ScanUtil;
import com.huawei.hms.ml.scan.HmsScan;
import com.huawei.hms.ml.scan.HmsScanAnalyzerOptions;

import java.util.Arrays;
import java.util.Map;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

@SuppressWarnings("deprecation")
public class ScanKitDefaultMode {
    private final Activity mActivity;
    private final int id;
    private final EventChannel mResultChannel;
    private EventChannel.EventSink mEvents;

    ScanKitDefaultMode(int id, ActivityPluginBinding binding, BinaryMessenger binaryMessenger){
        this.id = id;
        this.mActivity = binding.getActivity();

        mResultChannel = new EventChannel(binaryMessenger, "xyz.bczl.scankit/result/"+id);
        mResultChannel.setStreamHandler(new EventChannel.StreamHandler() {
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
            Log.d("ActivityResult", "requestCode=" + requestCode + "  resultCode=" + resultCode);
            if (requestCode == id){
                if (resultCode != Activity.RESULT_OK || data == null) {
                    setResult(null);
                    return true;
                }

                int errorCode = data.getIntExtra(ScanUtil.RESULT_CODE,ScanUtil.SUCCESS);
                Log.d("ActivityResult", "errorCode=" + errorCode);
                if(errorCode == ScanUtil.SUCCESS){
                    HmsScan obj = data.getParcelableExtra(ScanUtil.RESULT);
                    if (obj != null) {
                        setResult(new ScanResult(obj.originalValue, obj.scanType));
                    } else {
                        setError("101", "[onActivityResult]: scan_result is null");
                    }
                }else {
                    setError(""+errorCode,"[onActivityResult]:scan error");
                }
                return true;
            }
            return  false;
        });
    }

    public int startScan(@NonNull Long type, @NonNull Map<String, Object> options) {
        if(mActivity == null){
            throw new ScanKitAPI.FlutterError("100","Activity is null",null);
        }

        int[] args = ScanKitUtilities.getArrayFromFlags(type.intValue());
        int var1 = args[0];
        int[] var2 = Arrays.copyOfRange(args, 1, args.length);
        Object errorCheck = options.get("errorCheck");
        Object photoMode = options.get("photoMode");
        Object viewType = options.get("viewType");

        HmsScanAnalyzerOptions.Creator creator = new HmsScanAnalyzerOptions.Creator();
        creator.setHmsScanTypes(var1,var2);
        if(errorCheck != null){
            creator.setErrorCheck((Boolean) errorCheck);
        }
        if(photoMode != null){
            creator.setPhotoMode((Boolean) photoMode);
        }
        if(viewType != null){
            creator.setViewType((Integer) viewType);
        }
        return ScanUtil.startScan(mActivity, id, creator.create());
    }

    void setResult(ScanResult result){
        if(mEvents != null){
            if(result != null){
                mEvents.success(result.toMap());
            }else {
                mEvents.success(null);
            }
        }
    }

    void setError(String code, String msg){
        if(mEvents != null){
            mEvents.error(code,msg, null);
        }
    }

    void dispose(){
//        mResultChannel.setStreamHandler(null);
    }
}

