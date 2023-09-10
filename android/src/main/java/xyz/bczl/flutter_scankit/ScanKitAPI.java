// Autogenerated from Pigeon (v10.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package xyz.bczl.flutter_scankit;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression", "serial"})
public class ScanKitAPI {

  /** Error class for passing custom error details to Flutter via a thrown PlatformException. */
  public static class FlutterError extends RuntimeException {

    /** The error code. */
    public final String code;

    /** The error details. Must be a datatype supported by the api codec. */
    public final Object details;

    public FlutterError(@NonNull String code, @Nullable String message, @Nullable Object details) 
    {
      super(message);
      this.code = code;
      this.details = details;
    }
  }

  @NonNull
  protected static ArrayList<Object> wrapError(@NonNull Throwable exception) {
    ArrayList<Object> errorList = new ArrayList<Object>(3);
    if (exception instanceof FlutterError) {
      FlutterError error = (FlutterError) exception;
      errorList.add(error.code);
      errorList.add(error.getMessage());
      errorList.add(error.details);
    } else {
      errorList.add(exception.toString());
      errorList.add(exception.getClass().getSimpleName());
      errorList.add(
        "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    }
    return errorList;
  }
  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface ScanKitApi {

    @NonNull 
    Long createDefaultMode();

    void disposeDefaultMode(@NonNull Long dId);

    void disposeCustomizedMode(@NonNull Long cusId);

    @NonNull 
    Long startScan(@NonNull Long defaultId, @NonNull Long type, @NonNull Map<String, Object> options);

    void pauseContinuouslyScan(@NonNull Long cusId);

    void resumeContinuouslyScan(@NonNull Long cusId);

    void switchLight(@NonNull Long cusId);

    void pickPhoto(@NonNull Long cusId);

    @NonNull 
    Boolean getLightStatus(@NonNull Long cusId);

    @NonNull 
    Map<String, Object> decodeYUV(@NonNull byte[] yuv, @NonNull Long width, @NonNull Long height, @NonNull Map<String, Object> options);

    @NonNull 
    Map<String, Object> decode(@NonNull byte[] bytes, @NonNull Long width, @NonNull Long height, @NonNull Map<String, Object> options);

    @NonNull 
    Map<String, Object> decodeBitmap(@NonNull byte[] data, @NonNull Map<String, Object> options);

    @NonNull 
    byte[] encode(@NonNull String content, @NonNull Long width, @NonNull Long height, @NonNull Map<String, Object> options);

    /** The codec used by ScanKitApi. */
    static @NonNull MessageCodec<Object> getCodec() {
      return new StandardMessageCodec();
    }
    /**Sets up an instance of `ScanKitApi` to handle messages through the `binaryMessenger`. */
    static void setup(@NonNull BinaryMessenger binaryMessenger, @Nullable ScanKitApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.createDefaultMode", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                try {
                  Long output = api.createDefaultMode();
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.disposeDefaultMode", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number dIdArg = (Number) args.get(0);
                try {
                  api.disposeDefaultMode((dIdArg == null) ? null : dIdArg.longValue());
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.disposeCustomizedMode", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number cusIdArg = (Number) args.get(0);
                try {
                  api.disposeCustomizedMode((cusIdArg == null) ? null : cusIdArg.longValue());
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.startScan", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number defaultIdArg = (Number) args.get(0);
                Number typeArg = (Number) args.get(1);
                Map<String, Object> optionsArg = (Map<String, Object>) args.get(2);
                try {
                  Long output = api.startScan((defaultIdArg == null) ? null : defaultIdArg.longValue(), (typeArg == null) ? null : typeArg.longValue(), optionsArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.pauseContinuouslyScan", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number cusIdArg = (Number) args.get(0);
                try {
                  api.pauseContinuouslyScan((cusIdArg == null) ? null : cusIdArg.longValue());
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.resumeContinuouslyScan", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number cusIdArg = (Number) args.get(0);
                try {
                  api.resumeContinuouslyScan((cusIdArg == null) ? null : cusIdArg.longValue());
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.switchLight", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number cusIdArg = (Number) args.get(0);
                try {
                  api.switchLight((cusIdArg == null) ? null : cusIdArg.longValue());
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.pickPhoto", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number cusIdArg = (Number) args.get(0);
                try {
                  api.pickPhoto((cusIdArg == null) ? null : cusIdArg.longValue());
                  wrapped.add(0, null);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.getLightStatus", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                Number cusIdArg = (Number) args.get(0);
                try {
                  Boolean output = api.getLightStatus((cusIdArg == null) ? null : cusIdArg.longValue());
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.decodeYUV", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                byte[] yuvArg = (byte[]) args.get(0);
                Number widthArg = (Number) args.get(1);
                Number heightArg = (Number) args.get(2);
                Map<String, Object> optionsArg = (Map<String, Object>) args.get(3);
                try {
                  Map<String, Object> output = api.decodeYUV(yuvArg, (widthArg == null) ? null : widthArg.longValue(), (heightArg == null) ? null : heightArg.longValue(), optionsArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.decode", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                byte[] bytesArg = (byte[]) args.get(0);
                Number widthArg = (Number) args.get(1);
                Number heightArg = (Number) args.get(2);
                Map<String, Object> optionsArg = (Map<String, Object>) args.get(3);
                try {
                  Map<String, Object> output = api.decode(bytesArg, (widthArg == null) ? null : widthArg.longValue(), (heightArg == null) ? null : heightArg.longValue(), optionsArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.decodeBitmap", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                byte[] dataArg = (byte[]) args.get(0);
                Map<String, Object> optionsArg = (Map<String, Object>) args.get(1);
                try {
                  Map<String, Object> output = api.decodeBitmap(dataArg, optionsArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.ScanKitApi.encode", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                ArrayList<Object> wrapped = new ArrayList<Object>();
                ArrayList<Object> args = (ArrayList<Object>) message;
                String contentArg = (String) args.get(0);
                Number widthArg = (Number) args.get(1);
                Number heightArg = (Number) args.get(2);
                Map<String, Object> optionsArg = (Map<String, Object>) args.get(3);
                try {
                  byte[] output = api.encode(contentArg, (widthArg == null) ? null : widthArg.longValue(), (heightArg == null) ? null : heightArg.longValue(), optionsArg);
                  wrapped.add(0, output);
                }
 catch (Throwable exception) {
                  ArrayList<Object> wrappedError = wrapError(exception);
                  wrapped = wrappedError;
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
}