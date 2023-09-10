import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_scankit/src/scan_kit_api.g.dart';
import 'scan_kit_types.dart';

class ScanKitDecoder {
  ScanKitApi _api;
  final Map<String, Object> options = {};

  ScanKitDecoder(
      {int scanTypes = scanTypeAll, bool? photoMode, bool? parseResult})
      : _api = ScanKitApi() {
    options['scanTypes'] = scanTypes;
    if (photoMode != null) {
      options['photoMode'] = photoMode;
    }
    if (parseResult != null) {
      options['parseResult'] = parseResult;
    }
  }

  final StreamController<DecodeEvent> _resultSc = StreamController();

  Stream<DecodeEvent> get onResult => _resultSc.stream;

  Future<void> decodeYUV(
      Uint8List yuv, int width, int height) async {
    var result = await _api.decodeYUV(yuv,width, height,options);
    if (result.isEmpty) {
      _resultSc.add(ResultEvent(ScanResult.empty()));
    } else {
      if (result.containsKey('zoomValue')) {
        _resultSc.add(ZoomEvent(result['zoomValue']));
      } else {
        _resultSc.add(ResultEvent(ScanResult.from(result)));
      }
    }
  }

  Future<void> decode(
      Uint8List bytes,int width, int height) async {
    var result = await _api.decode(bytes, width, height,options);
    if (result.isEmpty) {
      _resultSc.add(ResultEvent(ScanResult.empty()));
    } else {
      if (result.containsKey('zoomValue')) {
        _resultSc.add(ZoomEvent(result['zoomValue']));
      } else {
        _resultSc.add(ResultEvent(ScanResult.from(result)));
      }
    }
  }

  Future<ScanResult> decodeImage(Uint8List bytes) async {
    var result = await _api.decodeBitmap(bytes, options);
    if (result.isEmpty) {
      return ScanResult.empty();
    } else {
      return result.containsKey('zoomValue')
          ? ScanResult.empty()
          : ScanResult.from(result);
    }
  }

  Future dispose() async {
    await _resultSc.close();
  }
}

abstract class DecodeEvent<T> {
  final T value;

  DecodeEvent(this.value);
}

class ZoomEvent extends DecodeEvent<double> {
  ZoomEvent(value) : super(value);
}

class ResultEvent extends DecodeEvent<ScanResult> {
  ResultEvent(value) : super(value);
}
