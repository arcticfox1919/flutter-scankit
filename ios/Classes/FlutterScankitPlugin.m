#import "FlutterScankitPlugin.h"
#import <ScanKitFrameWork/ScanKitFrameWork.h>
#import "FLScanKitView.h"
#import "FLScanKitUtilities.h"
#import "ScanKitAPI.g.h"
#import "FLScanKitDefaultMode.h"
#import "FLScanKitCustomMode.h"
#import "FLScanKitBitmapMode.h"

@interface FlutterScankitPlugin ()<DefaultScanDelegate,SKScanKitApi>{
    id<FlutterPluginRegistrar> _registrar;
    
    NSMutableDictionary<NSNumber *, FLScanKitDefaultMode *> *_defaultModeDict;
    NSMutableDictionary<NSNumber *, FLScanKitCustomMode *> *_cusModeDict;
    int _defaultModeId;
}

@property (nonatomic, readonly) NSMutableDictionary<NSNumber *, FLScanKitCustomMode *> *cusModeDict;

@end

@implementation FlutterScankitPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterScankitPlugin* instance = [[FlutterScankitPlugin alloc] initWithRegistrar:registrar];
    SKScanKitApiSetup(registrar.messenger, instance);
    
    FLScanKitViewFactory* factory =
    [[FLScanKitViewFactory alloc] initWithMessenger:registrar.messenger cusModeCache:instance.cusModeDict];
    [registrar registerViewFactory:factory withId:@"ScanKitWidgetType"];
}

-(instancetype)initWithRegistrar:(id<FlutterPluginRegistrar>)registrar{
    self = [super init];
    if (self) {
        _registrar = registrar;
        _defaultModeDict = [[NSMutableDictionary alloc] init];
        _cusModeDict = [[NSMutableDictionary alloc] init];
        _defaultModeId = 0;
    }
    return self;
}

- (void)dealloc {
    [_defaultModeDict removeAllObjects];
}

- (nullable NSNumber *)createDefaultModeWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    _defaultModeId++;
    NSNumber *kId = [NSNumber numberWithInt:_defaultModeId];
    FLScanKitDefaultMode *mode = [[FLScanKitDefaultMode alloc] initWithMessenger:_registrar.messenger withId:kId];
    [_defaultModeDict setObject:mode forKey:kId];
    return kId;
}


- (nullable NSNumber *)startScanDefaultId:(nonnull NSNumber *)defaultId type:(nonnull NSNumber *)type options:(nonnull NSDictionary<NSString *,id> *)options error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    FLScanKitDefaultMode *mode = _defaultModeDict[defaultId];
    if(mode !=nil){
        return [mode startScanByType:type options:options];
    }
    
    if(error != NULL){
        *error = [FlutterError errorWithCode:@"100"
                                     message:@"FLScanKitDefaultMode dose not exist!"
                                     details:nil];
    }
    return [NSNumber numberWithInt:-1];
}

- (void)disposeCustomizedModeCusId:(nonnull NSNumber *)cusId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    FLScanKitCustomMode *mode = _cusModeDict[cusId];
    if(mode != nil){
        [_cusModeDict removeObjectForKey:cusId];
        [mode dispose];
    }
}

- (void)disposeDefaultModeDId:(NSNumber *)dId error:(FlutterError *_Nullable *_Nonnull)error {
    [_defaultModeDict removeObjectForKey:dId];
}

- (nullable NSDictionary<NSString *, id> *)decodeYUVYuv:(FlutterStandardTypedData *)yuv width:(NSNumber *)width height:(NSNumber *)height options:(NSDictionary<NSString *, id> *)options error:(FlutterError *_Nullable *_Nonnull)error {
    if(error != NULL){
        *error = [FlutterError errorWithCode:@"notImplemented"
                                     message:@"F[decodeYUVYuv] Method not implemented!"
                                     details:nil];
    }
    return [NSDictionary dictionary];
}

- (nullable NSDictionary<NSString *, id> *)decodeBytes:(FlutterStandardTypedData *)bytes width:(NSNumber *)width height:(NSNumber *)height options:(NSDictionary<NSString *, id> *)options error:(FlutterError *_Nullable *_Nonnull)error{
    return [FLScanKitBitmapMode decodeBytes:bytes width:width height:height options:options error:error];
}

- (nullable NSDictionary<NSString *, id> *)decodeBitmapData:(FlutterStandardTypedData *)data options:(NSDictionary<NSString *, id> *)options error:(FlutterError *_Nullable *_Nonnull)error{
    return [FLScanKitBitmapMode decodeBitmapData:data options:options error:error];
}

- (nullable FlutterStandardTypedData *)encodeContent:(nonnull NSString *)content width:(nonnull NSNumber *)width height:(nonnull NSNumber *)height options:(nonnull NSDictionary<NSString *,id> *)options error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    return [FLScanKitBitmapMode encodeContent:content width:width height:height options:options error:error];
}

- (nullable NSNumber *)getLightStatusCusId:(nonnull NSNumber *)cusId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    FLScanKitCustomMode *mode = _cusModeDict[cusId];
    if(mode != nil){
        return [mode getLightStatusAndError:error];
    }
    return [NSNumber numberWithBool:FALSE];
}

- (void)switchLightCusId:(nonnull NSNumber *)cusId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    FLScanKitCustomMode *mode = _cusModeDict[cusId];
    if(mode != nil){
        [mode switchLightAndError:error];
    }
}

- (void)pickPhotoCusId:(nonnull NSNumber *)cusId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    FLScanKitCustomMode *mode = _cusModeDict[cusId];
    if(mode != nil){
        [mode pickPhotoAndError:error];
    }
}

- (void)pauseContinuouslyScanCusId:(nonnull NSNumber *)cusId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {}


- (void)resumeContinuouslyScanCusId:(nonnull NSNumber *)cusId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {}
@end
