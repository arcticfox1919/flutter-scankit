import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_scankit/src/scan_kit_api.g.dart';

import 'scan_kit_types.dart';

typedef ScanKitCallback = void Function(ScanKitController);

const _viewType = 'ScanKitWidgetType';

class ScanKitWidget extends StatelessWidget {
  final ScanKitController controller;
  final Rect? boundingBox;
  final int format;
  final bool continuouslyScan;

  ScanKitWidget(
      {required this.controller,
      this.boundingBox,
      int format = scanTypeAll,
      bool? continuouslyScan})
      : this.format = format,
        this.continuouslyScan = continuouslyScan ?? false;

  @override
  Widget build(BuildContext context) {
    var map = {};
    if (boundingBox != null) {
      map["boundingBox"] = [
        boundingBox!.left.toInt(),
        boundingBox!.top.toInt(),
        boundingBox!.width.toInt(),
        boundingBox!.height.toInt()
      ];
    }

    map["format"] = format;
    map["continuouslyScan"] = continuouslyScan;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
            onPlatformViewCreated: (id) {
              controller._initCustomMode(id);
            },
            creationParamsCodec: const StandardMessageCodec(),
            creationParams: map,
            viewType: _viewType);
      default:
        throw UnsupportedError("Not supported on the current platform!");
    }
  }
}

///
/// Some APIs see [here](https://developer.huawei.com/consumer/cn/doc/development/HMSCore-References/scan-remoteview4-0000001050167711)
///
class ScanKitController {
  final ScanKitApi _api;
  final Completer<int> _id = Completer();

  EventChannel? _eventChannel;

  final StreamController<ScanResult> _resultStreamController =
      StreamController();

  final StreamController<bool> _visibleStreamController =
      StreamController();

  Stream<ScanResult> get onResult => _resultStreamController.stream;

  ///
  /// Android support only
  ///
  /// see [here](https://developer.huawei.com/consumer/cn/doc/development/HMSCore-References/scan-remoteview4-0000001050167711#section7579143914819)
  ///
  Stream<bool> get onLightVisible => _visibleStreamController.stream;

  StreamSubscription? _eventSubscription;

  ScanKitController() : _api = ScanKitApi() {
    _id.future.then((value) {
      _eventChannel =
          EventChannel('xyz.bczl.scankit/embedded/result/$value');
      _eventSubscription = _eventChannel!
          .receiveBroadcastStream()
          .where((event) => event is Map)
          .listen(_eventHandler, cancelOnError: false);
    });
  }

  void _initCustomMode(int id) async {
    _id.complete(id);
  }

  _eventHandler(event) {
    if (event == null) return;

    final Map<dynamic, dynamic> map = event;
    switch (map["event"]) {
      case _ScanEvent.result:
        _resultStreamController.add(ScanResult.from(map['value']));
        break;
      case _ScanEvent.lightVisible:
        _visibleStreamController.add(map['value']);
        break;
      default:
    }
  }

  ///
  /// Android support only
  ///
  Future<void> pauseContinuouslyScan() async {
    await _api.pauseContinuouslyScan(await _id.future);
  }

  ///
  /// Android support only
  ///
  Future<void> resumeContinuouslyScan() async {
    await _api.resumeContinuouslyScan(await _id.future);
  }

  Future<void> switchLight() async {
    await _api.switchLight(await _id.future);
  }

  Future<void> pickPhoto() async {
    await _api.pickPhoto(await _id.future);
  }

  Future<bool> getLightStatus() async {
    return await _api.getLightStatus(await _id.future);
  }

  Future<void> dispose() async {
    if (_eventSubscription != null) {
      await _eventSubscription!.cancel();
      _eventSubscription = null;
    }
    await _api.disposeCustomizedMode(await _id.future);
    _resultStreamController.close();
    _visibleStreamController.close();
  }
}

class _ScanEvent {
  static const result = 0;
  static const lightVisible = 1;
}
