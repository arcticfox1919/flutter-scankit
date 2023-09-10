import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_scankit/flutter_scankit.dart';

import 'scan_kit_api.g.dart';

class ScanKitEncoder {
  int width;
  int height;
  ScanKitApi _api;
  final Map<String, Object> options = {};

  ScanKitEncoder(this.width, this.height, ScanTypes scanTypes,
      {Color? backgroundColor, Color? color, int? margin})
      : _api = ScanKitApi() {
    options['scanTypes'] = scanTypes.bit;
    if (backgroundColor != null) {
      options['bgColor'] = backgroundColor.value;
    }
    if (color != null) {
      options['color'] = color.value;
    }
    if (margin != null) {
      options['margin'] = margin;
    }
  }

  set backgroundColor(Color? color){
    if(color !=null){
      options['bgColor'] = color.value;
    }
  }

  set color(Color? color){
    if(color !=null){
      options['color'] = color.value;
    }
  }

  set margin(int? margin){
    if(margin !=null){
      options['margin'] = margin;
    }
  }

  Color? get backgroundColor =>
      options['bgColor'] != null ? Color(options['bgColor'] as int) : null;

  Color? get color =>
      options['color'] != null ? Color(options['color'] as int) : null;

  int? get margin => options['margin'] as int?;

  Future<Uint8List> encode(String content) async {
    return await _api.encode(content, width, height, options);
  }
}
