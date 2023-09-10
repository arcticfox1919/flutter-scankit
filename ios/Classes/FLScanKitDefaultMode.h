//
//  FLScanKitDefaultMode.h
//  flutter_scankit
//
//  Created by bruce on 2023/9/3.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <ScanKitFrameWork/ScanKitFrameWork.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLScanKitDefaultMode : NSObject<DefaultScanDelegate,FlutterStreamHandler>

-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                          withId:(NSNumber *)defaultId;

- (nullable NSNumber *)startScanByType:(nonnull NSNumber *)type options:(nonnull NSDictionary<NSString *,id> *)options;
@end

NS_ASSUME_NONNULL_END
