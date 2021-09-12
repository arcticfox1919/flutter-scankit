import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'flutter_scankit.dart';

typedef ScanKitCallback = void Function(ScanKitController);

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


    return AndroidView(
        onPlatformViewCreated: (id) {
          callback(ScanKitController());
        },
        creationParamsCodec:const StandardMessageCodec(),
        creationParams: map,
        viewType: "ScanKitWidgetType");
  }

  List<int> _getFormatIndex(List<ScanTypes> scanTypes){
      return scanTypes.map((e) => e.index).toList();
  }
}

class ScanKitController {

  late MethodChannel _channel;

  final StreamController<String> _resultStreamController =
      StreamController.broadcast();

  final StreamController<bool> _visibleStreamController =
      StreamController.broadcast();

  Stream<String> get onResult => _resultStreamController.stream;

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

  Future<void> pauseContinuouslyScan() async {
    return await _channel.invokeMethod('pauseContinuouslyScan');
  }

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
      _eventSubscription.cancel();
  }

}


class _ScanEvent{
  static const result = 0;
  static const lightVisible =1;
}
