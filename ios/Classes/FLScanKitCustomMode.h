//
//  FLScanKitCustomMode.h
//  flutter_scankit
//
//  Created by bruce on 2023/9/3.
//
#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <ScanKitFrameWork/ScanKitFrameWork.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLScanKitCustomMode : NSObject<CustomizedScanDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate,FlutterStreamHandler>

@property (nonatomic, strong, nullable) UIView *view;

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                          viewId:(NSNumber*)vId;

- (nullable NSNumber *)getLightStatusAndError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error;


- (void)pickPhotoAndError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error;

- (void)switchLightAndError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error;

- (void)dispose;

@end

NS_ASSUME_NONNULL_END
