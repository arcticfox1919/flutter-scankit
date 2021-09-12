//
//  FLScanKitUtilities.h
//  flutter_scankit
//
//  Created by Bruce Ying on 2021/9/12.
//

#import <Foundation/Foundation.h>
#import <ScanKitFrameWork/ScanKitFrameWork.h>

NS_ASSUME_NONNULL_BEGIN

#define FormatTypeSize 14
static uint scanFormatTypes[FormatTypeSize]={
    ALL, QR_CODE, AZTEC, DATA_MATRIX, PDF_417,CODE_39,
    CODE_93,CODE_128,EAN_13,EAN_8,ITF,UPC_A,UPC_E,CODABAR,
};

@interface FLScanKitUtilities : NSObject
+(uint)getScanFormatType:(NSArray *)typeIndex;
@end

NS_ASSUME_NONNULL_END
