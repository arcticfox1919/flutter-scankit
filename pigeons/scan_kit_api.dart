import 'package:pigeon/pigeon.dart';

// #docregion config
@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/scan_kit_api.g.dart',
  dartOptions: DartOptions(),
  javaOut: 'android/src/main/java/xyz/bczl/flutter_scankit/ScanKitAPI.java',
  javaOptions: JavaOptions(package: 'xyz.bczl.flutter_scankit'),
  // Set this to a unique prefix for your plugin or application, per Objective-C naming conventions.
  objcOptions: ObjcOptions(prefix: 'SK'),
))
// #enddocregion config

@HostApi()
abstract class ScanKitApi {
  int createDefaultMode();

  void disposeDefaultMode(int dId);

  void disposeCustomizedMode(int cusId);

  int startScan(int defaultId, int type, Map<String, Object> options);

  void pauseContinuouslyScan(int cusId);

  void resumeContinuouslyScan(int cusId);

  void switchLight(int cusId);

  void pickPhoto(int cusId);

  bool getLightStatus(int cusId);

  Map<String, Object> decodeYUV(Uint8List yuv, int width,
      int height, Map<String, Object> options);

  Map<String, Object> decode(Uint8List bytes, int width, int height, Map<String, Object> options);

  Map<String, Object> decodeBitmap(Uint8List data, Map<String, Object> options);

  Uint8List encode(String content, int width, int height, Map<String, Object> options);
}
