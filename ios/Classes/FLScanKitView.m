//
//  FLScanKitView.m
//  flutter_scankit
//
//  Created by Bruce Ying on 2021/9/12.
//

#import <ScanKitFrameWork/ScanKitFrameWork.h>
#import "FLScanKitView.h"
#import "FLScanKitUtilities.h"
#import "FLScanKitCustomMode.h"


@interface FLScanKitView (){
    NSMutableDictionary<NSNumber*, FLScanKitCustomMode*>* _cache;
    FLScanKitCustomMode *_mode;
    NSNumber *_id ;
}

@end

@implementation FLScanKitView{
    UIView *_view;
    HmsCustomScanViewController *customScanVC;
}

-(instancetype)initWithFrame:(CGRect)frame
              viewIdentifier:(NSNumber*)viewID
                cusModeCache:(NSMutableDictionary<NSNumber*, FLScanKitCustomMode*>*)cache
                   arguments:(id _Nullable)args{
    
    if(self = [super init]){
        _cache = cache;
        _id = viewID;
        _mode = cache[viewID];
        _view = [self createNativeView:args];
        _mode.view = _view;
    }
    return self;
}

-(nonnull UIView *)createNativeView:(id _Nullable)arguments{
    NSDictionary *args = arguments;
    NSNumber *scanTypes = args[@"format"];
    BOOL continuouslyScan = [args[@"continuouslyScan"] boolValue];
    
    HmsScanOptions *options = [[HmsScanOptions alloc] initWithScanFormatType:[scanTypes intValue] Photo:FALSE];
    
    customScanVC = [[HmsCustomScanViewController alloc] initCustomizedScanWithFormatType:options];
    customScanVC.customizedScanDelegate = _mode;
    customScanVC.backButtonHidden = true;
    customScanVC.continuouslyScan = continuouslyScan;
    
    NSArray *box = args[@"boundingBox"];
    if(box){
        double left = [box[0] doubleValue];
        double top = [box[1] doubleValue];
        double width = [box[2] doubleValue];
        double height = [box[3] doubleValue];
        customScanVC.cutArea = CGRectMake(
                                          left,
                                          top,
                                          width,
                                          height);
    }
    
    return customScanVC.view;
}

- (nonnull UIView *)view{
    return _view;
}

//- (void)dealloc {
//    if(_id != nil){
//        [_cache removeObjectForKey:_id];
//    }
//}

@end

@implementation FLScanKitViewFactory{
    NSObject<FlutterBinaryMessenger>* _messenger;
    NSMutableDictionary<NSNumber*, FLScanKitCustomMode*>* _cache;
}

-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                    cusModeCache:(NSMutableDictionary<NSNumber*, FLScanKitCustomMode*>*)cache{
    self = [super init];
    if(self){
        _messenger = messenger;
        _cache = cache;
    }
    return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args{
    NSNumber *vId = [NSNumber numberWithLongLong:viewId];
    FLScanKitCustomMode *mode = [[FLScanKitCustomMode alloc] initWithMessenger:_messenger viewId:vId];
    [_cache setObject:mode forKey:vId];
    return [[FLScanKitView alloc]initWithFrame:frame
                                viewIdentifier:vId
                                  cusModeCache:_cache
                                     arguments:args];
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec{
    return [FlutterStandardMessageCodec sharedInstance];
}

@end
