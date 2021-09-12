//
//  FLScanKitUtilities.m
//  flutter_scankit
//
//  Created by Bruce Ying on 2021/9/12.
//

#import "FLScanKitUtilities.h"

@implementation FLScanKitUtilities


+(uint)getScanFormatType:(NSArray *)typeIndex{
    NSUInteger len = typeIndex.count;
    NSNumber *item = typeIndex[0];
    uint ret = 0;
    if (len == 1 && item.intValue != scanFormatTypes[0]) {
        return scanFormatTypes[item.intValue];
    }else if(len == 1 && item.intValue == scanFormatTypes[0]){
        for (int i = 1; i<FormatTypeSize; i++) {
            ret |= scanFormatTypes[i];
        }
        return ret;
    }else{
        for (NSNumber *num in typeIndex) {
            ret |= scanFormatTypes[num.intValue];
        }
        return ret;
    }
}
@end
