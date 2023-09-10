//
//  FLScanKitView.h
//  flutter_scankit
//
//  Created by Bruce Ying on 2021/9/12.
//

#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import "FLScanKitCustomMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface FLScanKitView : NSObject <FlutterPlatformView>

-(instancetype)initWithFrame:(CGRect)frame
              viewIdentifier:(NSNumber*)viewID
                cusModeCache:(NSMutableDictionary<NSNumber*, FLScanKitCustomMode*>*)cache
                   arguments:(id _Nullable)args;


- (nonnull UIView *)view;

@end

@interface FLScanKitViewFactory : NSObject <FlutterPlatformViewFactory>
-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger
                    cusModeCache:(NSMutableDictionary<NSNumber*, FLScanKitCustomMode*>*)cache;
@end

NS_ASSUME_NONNULL_END
