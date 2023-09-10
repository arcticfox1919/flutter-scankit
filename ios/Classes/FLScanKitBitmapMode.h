//
//  FLScanKitBitmapMode.h
//  flutter_scankit
//
//  Created by bruce on 2023/9/3.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <ScanKitFrameWork/ScanKitFrameWork.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLScanKitBitmapMode : NSObject

+ (nullable FlutterStandardTypedData *)encodeContent:(nonnull NSString *)content width:(nonnull NSNumber *)width height:(nonnull NSNumber *)height options:(nonnull NSDictionary<NSString *,id> *)options error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error;

+ (nullable NSDictionary<NSString *, id> *)decodeBytes:(FlutterStandardTypedData *)bytes width:(NSNumber *)width height:(NSNumber *)height options:(NSDictionary<NSString *, id> *)options error:(FlutterError *_Nullable *_Nonnull)error;

+ (nullable NSDictionary<NSString *, id> *)decodeBitmapData:(FlutterStandardTypedData *)data options:(NSDictionary<NSString *, id> *)options error:(FlutterError *_Nullable *_Nonnull)error;


@end

NS_ASSUME_NONNULL_END
