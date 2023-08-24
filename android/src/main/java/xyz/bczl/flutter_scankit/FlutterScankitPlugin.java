package xyz.bczl.flutter_scankit;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
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

  private FlutterPluginBinding mPluginBinding;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    mPluginBinding = flutterPluginBinding;
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
    if (mActivity == null) {
      result.error("100","Activity is null",null);
      return;
    }

    if (call.method.equals("startScan")) {
      ArrayList<Integer> scanTypes = call.argument("scan_types");
      HmsScanAnalyzerOptions options;
      if (scanTypes.size() == 1) {
        options = new HmsScanAnalyzerOptions.Creator().setHmsScanTypes(ScanKitUtilities.single(scanTypes)).create();
      } else {
        options = new HmsScanAnalyzerOptions.Creator().setHmsScanTypes(ScanKitUtilities.first(scanTypes), ScanKitUtilities.toArray(scanTypes)).create();
      }
      result.success(ScanUtil.startScan(mActivity, REQUEST_CODE_SCAN_ONE, options));
    } else if (call.method.equals("scanImage")) {
      String path = call.argument("path");
       ArrayList<Integer> scanTypes = call.argument("scan_types");
      HmsScanAnalyzerOptions options;
      if (scanTypes.size() == 1) {
        options = new HmsScanAnalyzerOptions.Creator().setHmsScanTypes(ScanKitUtilities.single(scanTypes)).create();
      } else {
        options = new HmsScanAnalyzerOptions.Creator().setHmsScanTypes(ScanKitUtilities.first(scanTypes), ScanKitUtilities.toArray(scanTypes)).create();
      }

      Bitmap bitmap = BitmapFactory.decodeFile(path);
       HmsScan[] hmsScans = ScanUtil.decodeWithBitmap(mActivity, bitmap, options);

      if (hmsScans != null && hmsScans.length > 0) {
        result.success(hmsScans[0].originalValue);
      } else {
        result.success(null);
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    mChannel.setMethodCallHandler(null);
    mResultChannel.setStreamHandler(null);
    mPluginBinding = null;
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

    // register platform view
    if(mPluginBinding != null){
      mPluginBinding.getPlatformViewRegistry().registerViewFactory(
              "ScanKitWidgetType", new ScanKitViewFactory(
                      mPluginBinding.getBinaryMessenger(),binding));
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
}
