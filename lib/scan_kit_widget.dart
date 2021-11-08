import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'flutter_scankit.dart';

typedef ScanKitCallback = void Function(ScanKitController);

const _viewType = 'ScanKitWidgetType';

class ScanKitWidget extends StatelessWidget {

  final ScanKitCallback callback;
  final Rect? boundingBox;
  final List<ScanTypes> format;
  final bool continuouslyScan;

  ScanKitWidget(
      {required this.callback, this.boundingBox, format, continuouslyScan})
      : this.format = format ?? [ScanTypes.ALL],
        this.continuouslyScan = continuouslyScan ?? true;

  @override
  Widget build(BuildContext context) {
    var map = {};
    if(boundingBox != null){
      map["boundingBox"] = [
        boundingBox!.left.toInt(),
        boundingBox!.top.toInt(),
        boundingBox!.right.toInt(),
        boundingBox!.bottom.toInt()
      ];
    }

    map["format"] = _getFormatIndex(format);
    map["continuouslyScan"] = continuouslyScan;

    switch(defaultTargetPlatform){
      case TargetPlatform.android:
        return AndroidView(
            onPlatformViewCreated: (id) {
              callback(ScanKitController());
            },
            creationParamsCodec:const StandardMessageCodec(),
            creationParams: map,
            viewType: _viewType);
      case TargetPlatform.iOS:
        return UiKitView(
            onPlatformViewCreated: (id) {
              callback(ScanKitController());
            },
            creationParamsCodec:const StandardMessageCodec(),
            creationParams: map,
            viewType: _viewType);
      default:
        throw UnsupportedError(
            "Not supported on the current platform!");
    }
  }

  List<int> _getFormatIndex(List<ScanTypes> scanTypes){
      return scanTypes.map((e) => e.index).toList();
  }
}

///
/// Some APIs see [here](https://developer.huawei.com/consumer/cn/doc/development/HMSCore-References/scan-remoteview4-0000001050167711)
///
class ScanKitController {

  late MethodChannel _channel;

  final StreamController<String> _resultStreamController =
      StreamController.broadcast();

  final StreamController<bool> _visibleStreamController =
      StreamController.broadcast();

  Stream<String> get onResult => _resultStreamController.stream;

  ///
  /// Android support only
  ///
  /// see [here](https://developer.huawei.com/consumer/cn/doc/development/HMSCore-References/scan-remoteview4-0000001050167711#section7579143914819)
  ///
  Stream<bool> get onLightVisible => _visibleStreamController.stream;


  late StreamSubscription _eventSubscription;

  ScanKitController() {
    var eventChannel = EventChannel('xyz.bczl.flutter_scankit/event');

    _eventSubscription = eventChannel.receiveBroadcastStream()
        .listen(_eventHandler,cancelOnError: false);

    _channel = const MethodChannel('xyz.bczl.flutter_scankit/ScanKitWidget');
  }

  _eventHandler(event){
    if(event == null) return;

    final Map<dynamic, dynamic> map = event;
    switch(map["event"]){
      case _ScanEvent.result:
        _resultStreamController.add(map['value']);
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
    return await _channel.invokeMethod('pauseContinuouslyScan');
  }

  ///
  /// Android support only
  ///
  Future<void> resumeContinuouslyScan() async {
    return await _channel.invokeMethod('resumeContinuouslyScan');
  }


  Future<void> switchLight() async {
    return await _channel.invokeMethod('switchLight');
  }


  Future<void> pickPhoto() async {
    return await _channel.invokeMethod('pickPhoto');
  }

  Future<bool> getLightStatus() async {
    return await _channel.invokeMethod('getLightStatus');
  }


  void dispose(){
      // _eventSubscription.cancel();
  }

}


class _ScanEvent{
  static const result = 0;
  static const lightVisible =1;
}
