
import 'dart:async';

import 'package:flutter/services.dart';

typedef ResultListener = void Function(String);

class FlutterScankit {

  static const MethodChannel _channel =
    const MethodChannel('xyz.bczl.flutter_scankit/scan');

  StreamSubscription ?_resultSubscription;

  late EventChannel _resultChannel;


  FlutterScankit(){
    _resultChannel = EventChannel('xyz.bczl.flutter_scankit/result');
  }

  ///
  /// 华为ScanKit支持扫描13种全球主流的码制式，已支持的码制式：
  ///
  /// 一维码：EAN-8、EAN-13、UPC-A、UPC-E、Codabar、Code 39、Code 93、Code 128、ITF
  /// 二维码：QR Code、Data Matrix、PDF417、Aztec
  ///
  /// [scanTypes] 指定扫描的类型，可指定多种，[ScanTypes.ALL]支持所有的,
  /// 其他类型，见 [ScanTypes]
  ///
  Future<int> startScan({required List<ScanTypes> scanTypes}) async {

    final int result = await _channel.invokeMethod(
        'startScan',{"scan_types":_getScanTypesIndex(scanTypes)});
    return result;
  }

  static List<int> _getScanTypesIndex(List<ScanTypes> scanTypes){
    if(scanTypes !=null && scanTypes.isNotEmpty){
      assert(!(scanTypes.length > 1 && scanTypes.any((e) => e == ScanTypes.ALL)),
      "The parameter `scanTypes` is wrong, it is not allowed to "
          "pass `ScanTypes.ALL` together with other enumerated types");
      return scanTypes.map((e) => e.index).toList();
    }
    throw Exception("_getScanTypesIndex: parameter 'scanTypes' cannot be null or empty");
  }

  ///
  /// 设置扫码结果回调
  ///
  void addResultListen(ResultListener onListen){
    _resultSubscription = _resultChannel.receiveBroadcastStream().cast<String>().listen(
        onListen,cancelOnError: false);

  }


  void dispose(){
    _resultSubscription?.cancel();
  }
}


enum ScanTypes {
  ALL,
  QRCODE,
  AZTEC,
  DATAMATRIX,
  PDF417,
  CODE39,
  CODE93,
  CODE128,
  EAN13,
  EAN8,
  ITF14,
  UPCCODE_A,
  UPCCODE_E,
  CODABAR,
}
