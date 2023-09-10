import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_scankit/src/scan_kit_api.g.dart';

import 'scan_kit_types.dart';

class ScanKit {
  final ScanKitApi _api;
  final Completer<int> _defaultModeId = Completer();
  final Map<String, Object> options = {};

  final StreamController<ScanResult> _resultSc = StreamController();

  StreamSubscription? _subscription;
  EventChannel? _resultChannel;

  ScanKit({bool? errorCheck, bool? photoMode, int? viewType})
      : _api = ScanKitApi() {
    if (errorCheck != null) {
      options['errorCheck'] = errorCheck;
    }
    if (photoMode != null) {
      options['photoMode'] = photoMode;
    }
    if (viewType != null) {
      options['viewType'] = viewType;
    }

    _api.createDefaultMode().then((val) {
      _resultChannel = EventChannel('xyz.bczl.scankit/result/$val');
      _subscription = _resultChannel!
          .receiveBroadcastStream()
          .map<ScanResult>((event){
            return event == null ? ScanResult.empty() : ScanResult.from(event);
      })
          .listen((event) {
        _resultSc.add(event);
      }, cancelOnError: false);
      _defaultModeId.complete(val);
    });
  }

  Future<void> dispose() async {
    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null;
      _resultSc.close();
    }
  }

  ///
  /// 华为ScanKit支持扫描13种全球主流的码制式，已支持的码制式：
  ///
  /// 一维码：EAN-8、EAN-13、UPC-A、UPC-E、Codabar、Code 39、Code 93、Code 128、ITF
  /// 二维码：QR Code、Data Matrix、PDF417、Aztec
  ///
  /// [scanTypes] 指定扫描的类型，可指定多种，见 [ScanTypes]
  ///
  Future<int> startScan({int scanTypes = scanTypeAll}) async {
    var id = await _defaultModeId.future;
    final int result = await _api.startScan(id, scanTypes, options);
    return result;
  }

  ///
  /// 监听结果
  ///
  Stream<ScanResult> get onResult => _resultSc.stream;
}
