//
//  FLScanKitView.m
//  flutter_scankit
//
//  Created by Bruce Ying on 2021/9/12.
//

#import <ScanKitFrameWork/ScanKitFrameWork.h>
#import "FLScanKitView.h"
#import "FLScanKitUtilities.h"
#import "QueuingEventSink.h"


@interface FLScanKitView ()<CustomizedScanDelegate,
    UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    HmsCustomScanViewController *customScanVC;
    FlutterEventChannel *_eventChannel;
    QueuingEventSink *_eventSink;
    UIImagePickerController *_imagePickerController;
    NSArray *scanTypes;
}

@end

@implementation FLScanKitView{
    UIView *_view;
}

-(instancetype)initWithFrame:(CGRect)frame
                            viewIdentifier:(int64_t)viewID
                            arguments:(id _Nullable)args
    binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;{
    
    if(self = [super init]){
        [self setupFlutterChannel:messenger];
        _view = [self createNativeView:args];
    }
    return self;
}

-(void)setupFlutterChannel:(NSObject<FlutterBinaryMessenger>*)messenger{
    FlutterMethodChannel* channel = [FlutterMethodChannel
        methodChannelWithName:@"xyz.bczl.flutter_scankit/ScanKitWidget"
              binaryMessenger:messenger];
    
    __block typeof(self) weakSelf = self;
    [channel setMethodCallHandler:^(FlutterMethodCall *call,
                                       FlutterResult result){
        if ([@"switchLight" isEqualToString:call.method]) {
            [weakSelf switchLight];
            result(nil);
        }else if([@"pickPhoto" isEqualToString:call.method]){
            [weakSelf pickPhoto];
            result(nil);
        }else if([@"getLightStatus" isEqualToString:call.method]){
            result([NSNumber numberWithBool:[weakSelf getLightStatus]]);
        }
    }];
    
    _eventSink = [[QueuingEventSink alloc]init];
    _eventChannel = [FlutterEventChannel eventChannelWithName:@"xyz.bczl.flutter_scankit/event" binaryMessenger:messenger];
    [_eventChannel setStreamHandler:self];
}

-(nonnull UIView *)createNativeView:(id _Nullable)arguments{
    NSDictionary *args = arguments;
    scanTypes = args[@"format"];
    
    BOOL continuouslyScan = [args[@"continuouslyScan"] boolValue];
    
    HmsScanOptions *options = [[HmsScanOptions alloc] initWithScanFormatType:[FLScanKitUtilities getScanFormatType:scanTypes] Photo:FALSE];
    
    customScanVC = [[HmsCustomScanViewController alloc] initCustomizedScanWithFormatType:options];
    customScanVC.customizedScanDelegate = self;
    customScanVC.backButtonHidden = true;
    customScanVC.continuouslyScan = continuouslyScan;
    
    NSArray *box = args[@"boundingBox"];
    if(box){
        CGFloat scale = [UIScreen mainScreen].scale;
        double screenWidth = [UIScreen mainScreen].bounds.size.width * scale;
        double screenheight = [UIScreen mainScreen].bounds.size.height * scale;
        
        double left = [box[0] doubleValue];
        double top = [box[1] doubleValue];
        double right = [box[2] doubleValue];
        double bottom = [box[3] doubleValue];
        customScanVC.cutArea = CGRectMake(
                                          left,
                                          top,
                                          screenWidth - right - left,
                                          screenheight - bottom - top);
    }
    
    return customScanVC.view;
}

- (void)customizedScanDelegateForResult:(NSDictionary *)resultDic{
    __block typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf sendEvent:resultDic];
//     [customScanVC backAction];
    });
}

-(void)sendEvent:(NSDictionary *)resultDic{
    if (resultDic == nil){
        return;
    }
    
    NSString *string = [NSString stringWithFormat:@"%@", resultDic[@"text"]];
    if ([string length] == 0){
        return;
    }
    
    NSDictionary *dict = @{
        @"event":@0,
        @"value":resultDic[@"text"]
    };
    
    [self->_eventSink success: dict];
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

- (void)switchLight{
    AVCaptureDevice *flashLight =
        [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([flashLight isTorchAvailable] &&
        [flashLight isTorchModeSupported:AVCaptureTorchModeOn]){
        BOOL success = [flashLight lockForConfiguration:nil];
        if (success){
            if ([flashLight isTorchActive]){
                [flashLight setTorchMode:AVCaptureTorchModeOff];
            }else{
                [flashLight setTorchMode:AVCaptureTorchModeOn];
            }
            [flashLight unlockForConfiguration];
        }
    }
}

-(BOOL)getLightStatus{
    AVCaptureDevice *flashLight =
        [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    return [flashLight isTorchActive];
}

-(void)pickPhoto{
    if (_imagePickerController == nil) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = NO;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    UIViewController *root = [self topViewControler];
    [root presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSDictionary *dic = [HmsBitMap bitMapForImage:image withOptions:[[HmsScanOptions alloc] initWithScanFormatType:[FLScanKitUtilities getScanFormatType:scanTypes] Photo:true]];
    
    [self sendEvent:dic];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)topViewControler{
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *parent = root;
    while ((parent = root.presentedViewController) != nil ) {
        root = parent;
    }
    return root;
}

- (nonnull UIView *)view{
    return _view;
}

@end

@implementation FLScanKitViewFactory{
    NSObject<FlutterBinaryMessenger>* _messenger;

}

-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger{
    self = [super init];
    if(self){
        _messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args{
    return [[FLScanKitView alloc]initWithFrame:frame
                                viewIdentifier:viewId
                                     arguments:args
                               binaryMessenger:_messenger];
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

@end
