//
//  FLScanKitDefaultMode.m
//  flutter_scankit
//
//  Created by bruce on 2023/9/3.
//

#import "FLScanKitDefaultMode.h"
#import "FLScanKitUtilities.h"

@implementation FLScanKitDefaultMode{
    NSNumber * _currentId;
    FlutterEventSink _eventSink;
    FlutterEventChannel *_eventChannel;
}

-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                          withId:(NSNumber *)defaultId{
    self = [super init];
    if (self) {
        _currentId = defaultId;
        NSString *channelName = [NSString stringWithFormat:@"xyz.bczl.scankit/result/%@", defaultId];
        _eventChannel = [FlutterEventChannel eventChannelWithName:channelName binaryMessenger:messenger];
        [_eventChannel setStreamHandler:self];
    }
    return self;
}

- (nullable NSNumber *)startScanByType:(nonnull NSNumber *)type options:(nonnull NSDictionary<NSString *,id> *)options{
    BOOL photoVal = FALSE;
    NSNumber *photoMode = options[@"photoMode"];
    if(photoMode != nil){
        photoVal = [photoMode boolValue];
    }
    HmsScanOptions *hmsOptions = [[HmsScanOptions alloc] initWithScanFormatType:[type intValue] Photo:photoVal];
    
    UIViewController *topViewCtrl = [self topViewControler];
    HmsDefaultScanViewController *hmsDefault = [[HmsDefaultScanViewController alloc] initDefaultScanWithFormatType:hmsOptions];
    hmsDefault.defaultScanDelegate = self;
    
    hmsDefault.modalPresentationStyle = UIModalPresentationFullScreen;
    [topViewCtrl presentViewController:hmsDefault animated:YES completion:nil];
    //    [topViewCtrl.view addSubview:hmsDefault.view];
    //    [topViewCtrl addChildViewController:hmsDefault];
    //    [hmsDefault didMoveToParentViewController:topViewCtrl];
    return [NSNumber numberWithInt:0];
}

- (UIViewController *)topViewControler{
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (root.presentedViewController) {
        root = root.presentedViewController;
    }
    return root;
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events{
    _eventSink = events;
    return nil;
}


- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments{
    _eventSink = nil;
    return nil;
}

- (void)defaultScanDelegateForDicResult:(NSDictionary *)resultDic{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf sendResult:resultDic];
        }
    });
}

- (void)defaultScanImagePickerDelegateForImage:(UIImage *)image{
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [HmsBitMap bitMapForImage:image withOptions:[[HmsScanOptions alloc] initWithScanFormatType:ALL Photo:true]];
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf sendResult:dic];
        }
    });
}

-(void)sendResult:(NSDictionary *)resultDic{
    if (resultDic == nil){
        NSDictionary *dict = @{};
        self->_eventSink(dict);
        return;
    }
    
    NSString *text = resultDic[@"text"];
    NSString *format = resultDic[@"formatValue"];
    NSNumber *type = nil;
    if(format !=nil){
        type = getFormatDict()[format];
    }
    
    NSDictionary *scanResult = @{
        @"originalValue":text,
        @"scanType":type
    };
    self->_eventSink(scanResult);
}


@end
