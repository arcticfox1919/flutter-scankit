//
//  FLScanKitView.h
//  flutter_scankit
//
//  Created by Bruce Ying on 2021/9/12.
//

#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface FLScanKitView : NSObject <FlutterPlatformView,FlutterStreamHandler>

-(instancetype)initWithFrame:(CGRect)frame
                            viewIdentifier:(int64_t)viewID
                            arguments:(id _Nullable)args
    binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;


- (nonnull UIView *)view;

@end

@interface FLScanKitViewFactory : NSObject <FlutterPlatformViewFactory>
-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

NS_ASSUME_NONNULL_END
