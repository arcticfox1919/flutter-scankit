// Autogenerated from Pigeon (v10.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import "ScanKitAPI.g.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSArray *wrapResult(id result, FlutterError *error) {
  if (error) {
    return @[
      error.code ?: [NSNull null], error.message ?: [NSNull null], error.details ?: [NSNull null]
    ];
  }
  return @[ result ?: [NSNull null] ];
}
static id GetNullableObjectAtIndex(NSArray *array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}

NSObject<FlutterMessageCodec> *SKScanKitApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

void SKScanKitApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<SKScanKitApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.createDefaultMode"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(createDefaultModeWithError:)], @"SKScanKitApi api (%@) doesn't respond to @selector(createDefaultModeWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        NSNumber *output = [api createDefaultModeWithError:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.disposeDefaultMode"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(disposeDefaultModeDId:error:)], @"SKScanKitApi api (%@) doesn't respond to @selector(disposeDefaultModeDId:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_dId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api disposeDefaultModeDId:arg_dId error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.disposeCustomizedMode"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(disposeCustomizedModeCusId:error:)], @"SKScanKitApi api (%@) doesn't respond to @selector(disposeCustomizedModeCusId:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_cusId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api disposeCustomizedModeCusId:arg_cusId error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.startScan"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(startScanDefaultId:type:options:error:)], @"SKScanKitApi api (%@) doesn't respond to @selector(startScanDefaultId:type:options:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_defaultId = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_type = GetNullableObjectAtIndex(args, 1);
        NSDictionary<NSString *, id> *arg_options = GetNullableObjectAtIndex(args, 2);
        FlutterError *error;
        NSNumber *output = [api startScanDefaultId:arg_defaultId type:arg_type options:arg_options error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.pauseContinuouslyScan"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(pauseContinuouslyScanCusId:error:)], @"SKScanKitApi api (%@) doesn't respond to @selector(pauseContinuouslyScanCusId:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_cusId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api pauseContinuouslyScanCusId:arg_cusId error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.resumeContinuouslyScan"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(resumeContinuouslyScanCusId:error:)], @"SKScanKitApi api (%@) doesn't respond to @selector(resumeContinuouslyScanCusId:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_cusId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api resumeContinuouslyScanCusId:arg_cusId error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.switchLight"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(switchLightCusId:error:)], @"SKScanKitApi api (%@) doesn't respond to @selector(switchLightCusId:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_cusId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api switchLightCusId:arg_cusId error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.pickPhoto"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(pickPhotoCusId:error:)], @"SKScanKitApi api (%@) doesn't respond to @selector(pickPhotoCusId:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_cusId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api pickPhotoCusId:arg_cusId error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.getLightStatus"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getLightStatusCusId:error:)], @"SKScanKitApi api (%@) doesn't respond to @selector(getLightStatusCusId:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_cusId = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        NSNumber *output = [api getLightStatusCusId:arg_cusId error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.decodeYUV"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(decodeYUVYuv:width:height:options:error:)], @"SKScanKitApi api (%@) doesn't respond to @selector(decodeYUVYuv:width:height:options:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        FlutterStandardTypedData *arg_yuv = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_width = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_height = GetNullableObjectAtIndex(args, 2);
        NSDictionary<NSString *, id> *arg_options = GetNullableObjectAtIndex(args, 3);
        FlutterError *error;
        NSDictionary<NSString *, id> *output = [api decodeYUVYuv:arg_yuv width:arg_width height:arg_height options:arg_options error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.decode"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(decodeBytes:width:height:options:error:)], @"SKScanKitApi api (%@) doesn't respond to @selector(decodeBytes:width:height:options:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        FlutterStandardTypedData *arg_bytes = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_width = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_height = GetNullableObjectAtIndex(args, 2);
        NSDictionary<NSString *, id> *arg_options = GetNullableObjectAtIndex(args, 3);
        FlutterError *error;
        NSDictionary<NSString *, id> *output = [api decodeBytes:arg_bytes width:arg_width height:arg_height options:arg_options error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.decodeBitmap"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(decodeBitmapData:options:error:)], @"SKScanKitApi api (%@) doesn't respond to @selector(decodeBitmapData:options:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        FlutterStandardTypedData *arg_data = GetNullableObjectAtIndex(args, 0);
        NSDictionary<NSString *, id> *arg_options = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        NSDictionary<NSString *, id> *output = [api decodeBitmapData:arg_data options:arg_options error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.ScanKitApi.encode"
        binaryMessenger:binaryMessenger
        codec:SKScanKitApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(encodeContent:width:height:options:error:)], @"SKScanKitApi api (%@) doesn't respond to @selector(encodeContent:width:height:options:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSString *arg_content = GetNullableObjectAtIndex(args, 0);
        NSNumber *arg_width = GetNullableObjectAtIndex(args, 1);
        NSNumber *arg_height = GetNullableObjectAtIndex(args, 2);
        NSDictionary<NSString *, id> *arg_options = GetNullableObjectAtIndex(args, 3);
        FlutterError *error;
        FlutterStandardTypedData *output = [api encodeContent:arg_content width:arg_width height:arg_height options:arg_options error:&error];
        callback(wrapResult(output, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}
