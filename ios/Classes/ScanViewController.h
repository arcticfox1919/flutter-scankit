//
//  ScanViewController.h
//  flutter_hms_scankit
//
//  Created by mac on 2022/6/29.
//

#import <Flutter/Flutter.h>
typedef  void(^scanResule)(NSString * _Nullable result);
NS_ASSUME_NONNULL_BEGIN

@interface ScanViewController : UIViewController
@property(nonatomic,copy)scanResule successResult;
@property(nonatomic,copy)scanResule failureResult;
@end

NS_ASSUME_NONNULL_END
