package xyz.bczl.flutter_scankit;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;

import com.huawei.hms.hmsscankit.ScanUtil;
import com.huawei.hms.ml.scan.HmsScan;
import com.huawei.hms.ml.scan.HmsScanAnalyzerOptions;

import java.util.ArrayList;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterScankitPlugin */
public class FlutterScankitPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel mChannel;
  private EventChannel mResultChannel;
  private Activity mActivity;
  private EventChannel.EventSink mEvents;

  private static final int REQUEST_CODE_SCAN_ONE = 0X01;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    mChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "xyz.bczl.flutter_scankit/scan");
    mChannel.setMethodCallHandler(this);
    mResultChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "xyz.bczl.flutter_scankit/result");
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
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("startScan")) {
      if (mActivity == null) {
        result.error("100","Activity is null",null);
        return;
      }

      ArrayList<Integer> scanTypes = call.argument("scan_types");
      HmsScanAnalyzerOptions options;
      if (scanTypes.size() == 1){
        options = new HmsScanAnalyzerOptions.Creator().setHmsScanTypes(scanTypes.get(0)).create();
      }else {
        options = new HmsScanAnalyzerOptions.Creator().setHmsScanTypes(scanTypes.get(0),toArray(scanTypes)).create();
      }
      result.success(ScanUtil.startScan(mActivity, REQUEST_CODE_SCAN_ONE, options));
    } else {
      result.notImplemented();
    }
  }

  private int[] toArray(ArrayList<Integer> scanTypes){
    int len = scanTypes.size() - 1;
    int[] arr = new int[len];
    for (int i = 0; i < len; i++) {
      arr[i] = ScanKitConstants.SCAN_TYPES[scanTypes.get(i+1)];
    }
    return arr;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    mChannel.setMethodCallHandler(null);
    mResultChannel.setStreamHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    mActivity = binding.getActivity();

    binding.addActivityResultListener((int requestCode, int resultCode, Intent data)->{
      if(requestCode == REQUEST_CODE_SCAN_ONE){
        if (mEvents == null) return true;
        Log.d("ActivityResult","resultCode="+resultCode);
        if (resultCode != Activity.RESULT_OK || data == null) {
          mEvents.success(null);
          return true;
        }

        HmsScan obj = data.getParcelableExtra(ScanUtil.RESULT);
        if (obj != null) {
          mEvents.success(obj.originalValue);
        }else {
          mEvents.error("101",
                  "[onActivityResult]: SCAN_RESULT is null",null);
        }
        return true;
      }
      return false;
    });
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
}
