//
//  FLScanKitBitmapMode.m
//  flutter_scankit
//
//  Created by bruce on 2023/9/3.
//

#import "FLScanKitBitmapMode.h"
#import "FLScanKitUtilities.h"

@implementation FLScanKitBitmapMode

+ (nullable FlutterStandardTypedData *)encodeContent:(nonnull NSString *)content width:(nonnull NSNumber *)width height:(nonnull NSNumber *)height options:(nonnull NSDictionary<NSString *,id> *)options error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    CGFloat w = [width floatValue];
    CGFloat h = [height floatValue];
    CGSize size = CGSizeMake(w, h);
    NSNumber *scanTypes = options[@"scanTypes"];
    NSError *nsErr = nil;
    if(scanTypes != nil){
        UIImage *image = [HmsMultiFormatWriter createCodeWithString:content size:size CodeFomart:[scanTypes intValue] error:&nsErr];
        
        if(nsErr != nil && error != NULL){
            *error = [FlutterError errorWithCode:@"110"
                                         message:[nsErr localizedDescription]
                                         details:nil];
            return nil;
        }
        
        NSData *imageData = UIImagePNGRepresentation(image);
        if (!imageData) {
            *error = [FlutterError errorWithCode:@"UNAVAILABLE"
                                         message:@"Image data not available"
                                         details:nil];
            return nil;
        }
        return [FlutterStandardTypedData typedDataWithBytes:imageData];
    }else{
        if(error != NULL){
            *error = [FlutterError errorWithCode:@"110"
                                         message:@"[encodeContent] scanTypes is null!"
                                         details:nil];
        }
    }
    return nil;
}

+ (nullable NSDictionary<NSString *, id> *)decodeBytes:(FlutterStandardTypedData *)bytes width:(NSNumber *)width height:(NSNumber *)height options:(NSDictionary<NSString *, id> *)options error:(FlutterError *_Nullable *_Nonnull)error{
    size_t w = [width unsignedLongValue];
    size_t h = [height unsignedLongValue];
    NSNumber *scanTypes = options[@"scanTypes"];
    NSData* data = bytes.data;
    if(scanTypes != nil){
        CVPixelBufferRef pixelBuffer = NULL;
        // 创建 CVPixelBuffer
        CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault, w, h, kCVPixelFormatType_32BGRA, NULL, &pixelBuffer);
        if (result != kCVReturnSuccess) {
            if(error != NULL){
                *error = [FlutterError errorWithCode:@"CREATE_FAILED"
                                             message:@"Failed to create CVPixelBufferRef!"
                                             details:nil];
            }
            return [NSDictionary dictionary];
        }

        // 锁定像素缓冲区的基地址
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);

        // 获取像素缓冲区的基地址
        void *baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer);

        // 将数据复制到像素缓冲区
        memcpy(baseAddress, data.bytes, data.length);

        // 解锁像素缓冲区的基地址
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        
        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgImage = [context createCGImage:ciImage fromRect:[ciImage extent]];

        UIImage *image = [UIImage imageWithCGImage:cgImage];
        if(image != nil){
            CGImageRelease(cgImage);
        }
        
        
//        // 创建 CVPixelBufferRef
//        CVPixelBufferRef pixelBuffer = NULL;
//        CVReturn status = CVPixelBufferCreateWithBytes(NULL, w, h, kCVPixelFormatType_32BGRA, (void*)data.bytes, bytesPerRow, NULL, NULL, NULL, &pixelBuffer);
//        if (status != kCVReturnSuccess) {
//            if(error != NULL){
//                *error = [FlutterError errorWithCode:@"CREATE_SAMPLE_BUFFER_FAILED"
//                                             message:@"Failed to create sample buffer!"
//                                             details:nil];
//            }
//            return nil;
//        }
//
//        // 创建 CMVideoFormatDescriptionRef 对象
//        CMVideoFormatDescriptionRef formatDescription;
//        CMVideoFormatDescriptionCreateForImageBuffer(NULL, pixelBuffer, &formatDescription);
//
//        // 创建 CMSampleBuffer
//        CMSampleBufferRef sampleBuffer = NULL;
//        CMSampleTimingInfo sampleTiming = {0};
//        OSStatus osStatus = CMSampleBufferCreateReadyWithImageBuffer(kCFAllocatorDefault, pixelBuffer, formatDescription, &sampleTiming, &sampleBuffer);
//        if (osStatus != noErr) {
//            if(error != NULL){
//                *error = [FlutterError errorWithCode:@"CREATE_CMSampleBufferRef_FAILED"
//                                             message:@"CMSampleBufferCreateReadyWithImageBuffer failed!"
//                                             details:nil];
//            }
//            return nil;
//        }

        HmsScanOptions *hmsOption = [[HmsScanOptions alloc] initWithScanFormatType:[scanTypes intValue]];
//        NSDictionary *dict = [HmsBitMap bitMapForSampleBuffer:sampleBuffer withOptions:hmsOption];
        NSDictionary *dict = [HmsBitMap bitMapForImage:image withOptions:hmsOption];
//        if (sampleBuffer != NULL) {
//            CFRelease(sampleBuffer);
//        }
//
//        if (formatDescription != NULL) {
//            CFRelease(formatDescription);
//        }
        if (pixelBuffer != NULL) {
            CVPixelBufferRelease(pixelBuffer);
        }
        return [FLScanKitBitmapMode getResult:dict];
    }
    return  [NSDictionary dictionary];
}

+ (nullable NSDictionary<NSString *, id> *)decodeBitmapData:(FlutterStandardTypedData *)data options:(NSDictionary<NSString *, id> *)options error:(FlutterError *_Nullable *_Nonnull)error{
    
    NSNumber *scanTypes = options[@"scanTypes"];
    if(scanTypes != nil){
        HmsScanOptions *hmsOption = [[HmsScanOptions alloc] initWithScanFormatType:[scanTypes intValue]];
        UIImage* img = [UIImage imageWithData:data.data];
        NSDictionary *dict = [HmsBitMap bitMapForImage:img withOptions:hmsOption];
        return [FLScanKitBitmapMode getResult:dict];
    }
    return [NSDictionary dictionary];
}

+ (nullable NSDictionary<NSString *, id> *)getResult:(NSDictionary *)res{
    NSDictionary *r = @{};
    if (res == nil){
        return r;
    }
    
    NSString *text = res[@"text"];
    NSString *format = res[@"formatValue"];
    NSNumber *zoomValue = res[@"zoomValue"];
    NSNumber *fixedVal = [NSNumber numberWithFloat:1.0];
    if ([zoomValue compare:fixedVal] == NSOrderedDescending) {
        NSLog(@"zoomValue is greater than fixedVal");
        r = @{
            @"zoomValue":zoomValue
        };
    }else{
        if (text != nil && ![text isEqualToString:@""]) {
            NSNumber *type = [NSNumber numberWithInt:ALL];
            if(format !=nil){
                type = getFormatDict()[format];
            }
            
            r = @{
                @"originalValue":text,
                @"scanType":type
            };
        }
    }
    return r;
}

@end
