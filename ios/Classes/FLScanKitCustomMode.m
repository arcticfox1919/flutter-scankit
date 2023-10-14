//
//  FLScanKitCustomMode.m
//  flutter_scankit
//
//  Created by bruce on 2023/9/3.
//

#import "FLScanKitCustomMode.h"
#import "FLScanKitUtilities.h"

@implementation FLScanKitCustomMode{
    FlutterEventChannel *_eventChannel;
    FlutterEventSink _eventSink;
    UIImagePickerController *_imagePickerController;
}


-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                          viewId:(NSNumber*)vId{
    self = [super init];
    if(self){
        NSString *channelName = [NSString stringWithFormat:@"xyz.bczl.scankit/embedded/result/%@", vId];
        _eventChannel = [FlutterEventChannel eventChannelWithName:channelName binaryMessenger:messenger];
        [_eventChannel setStreamHandler:self];
    }
    return self;
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

- (nullable NSNumber *)getLightStatusAndError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    AVCaptureDevice *flashLight =
        [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    return [NSNumber numberWithBool:[flashLight isTorchActive]];
}


- (void)pickPhotoAndError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
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

- (void)switchLightAndError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSDictionary *dic = [HmsBitMap bitMapForImage:image withOptions:[[HmsScanOptions alloc] initWithScanFormatType:0 Photo:true]];
    
    [self sendEvent:dic];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)customizedScanDelegateForResult:(NSDictionary *)resultDic{
    __block typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(self) strongSelf = weakSelf;
        if(strongSelf != nil){
            [strongSelf sendEvent:resultDic];
        }
    });
}

-(void)sendEvent:(NSDictionary *)resultDic{
    if(_eventSink == nil){
        return;
    }

    if (resultDic == nil){
        NSDictionary *dict = @{
            @"event":@0,
            @"value":@{}
        };
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
    
    NSDictionary *dict = @{
        @"event":@0,
        @"value":scanResult
    };
    self->_eventSink(dict);
}

- (UIViewController *)topViewControler{
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (root.presentedViewController) {
        root = root.presentedViewController;
    }
    return root;
}

-(void)dispose{
    if(self.view !=nil){
        [self.view removeFromSuperview];
        self.view = nil;
    }
}

@end
