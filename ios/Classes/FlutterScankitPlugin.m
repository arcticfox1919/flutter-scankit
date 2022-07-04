#import "FlutterScankitPlugin.h"
//#import <ScanKitFrameWork/ScanKitFrameWork.h>
#import "QueuingEventSink.h"
#import "FLScanKitView.h"
//#import "FLScanKitUtilities.h"
#import "ScanViewController.h"
//DefaultScanDelegate,
@interface FlutterScankitPlugin ()<FlutterStreamHandler>{
    QueuingEventSink *_eventSink;
    FlutterMethodChannel *_channel;
    FlutterEventChannel *_eventChannel;
    id<FlutterPluginRegistrar> _registrar;
}
@end

@implementation FlutterScankitPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"xyz.icxl.flutter.hms.scankit/scan"
            binaryMessenger:[registrar messenger]];
  FlutterScankitPlugin* instance = [[FlutterScankitPlugin alloc] initWithRegistrar:registrar];
  [registrar addMethodCallDelegate:instance channel:channel];
    
    FLScanKitViewFactory* factory =
        [[FLScanKitViewFactory alloc]initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:factory withId:@"ScanKitWidgetType"];
}

-(instancetype)initWithRegistrar:(id<FlutterPluginRegistrar>)registrar{
    self = [super init];
    if (self) {
        _eventSink = [QueuingEventSink new];
        
        _eventChannel = [FlutterEventChannel eventChannelWithName:@"xyz.icxl.flutter.hms.scankit/result" binaryMessenger:[registrar messenger]];
        [_eventChannel setStreamHandler:self];
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"startScan" isEqualToString:call.method]) {
      ScanViewController * scanView = [[ScanViewController alloc]init];
      scanView.modalPresentationStyle =  UIModalPresentationFullScreen;
      scanView.successResult = ^(NSString * _Nullable result) {
          [self->_eventSink success:result];
       } ;
       [[self topViewControler]presentViewController:scanView animated:YES completion:nil];
  } else {
    result(FlutterMethodNotImplemented);
  }
}


- (UIViewController *)topViewControler{
    //获取根控制器
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *parent = root;
    while ((parent = root.presentedViewController) != nil ) {
        root = parent;
    }
    return root;
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events{
    [_eventSink setDelegate:events];
    return nil;
}


- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments{
    [_eventSink setDelegate:nil];
    return nil;
}

@end
