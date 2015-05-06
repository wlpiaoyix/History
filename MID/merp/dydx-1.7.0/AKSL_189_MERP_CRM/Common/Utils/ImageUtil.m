//
//  ImageUtil.m
//  anbaby
//
//  Created by MacChao on 13-8-21.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil


+(UIImage*) grayscale:(UIImage*)anImage type:(char)type{
    
    CGImageRef  imageRef;
    
    imageRef = anImage.CGImage;
    
    
    
    
    size_t width  = CGImageGetWidth(imageRef);
    
    size_t height = CGImageGetHeight(imageRef);
    
    
    
    
        
    size_t                  bitsPerComponent;
    
    bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    
    
    
    size_t                  bitsPerPixel;
    
    bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    
    
    
   
    
    size_t                  bytesPerRow;
    
    bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    
    
    
    
    CGColorSpaceRef         colorSpace;
    
    colorSpace = CGImageGetColorSpace(imageRef);
    
    
  
    
    CGBitmapInfo            bitmapInfo;
    
    bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    
   
    
    bool                    shouldInterpolate;
    
    shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    
    
    
    CGColorRenderingIntent  intent;
    
    intent = CGImageGetRenderingIntent(imageRef);
    
    
    
    CGDataProviderRef   dataProvider;
    
    dataProvider = CGImageGetDataProvider(imageRef);
    
    
    
    
    CFDataRef   data;
    
    UInt8*      buffer;
    
    data = CGDataProviderCopyData(dataProvider);
    
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    
    
    
    NSUInteger  x, y;
    
    for (y = 0; y < height; y++) {
        
        for (x = 0; x < width; x++) {
            
            UInt8*  tmp;
            
            tmp = buffer + y * bytesPerRow + x * 4;             
            
            
            // RGB値を取得
            
            UInt8 red,green,blue;
            
            red = *(tmp + 0);
            
            green = *(tmp + 1);
            
            blue = *(tmp + 2);
            
            
            
            UInt8 brightness;
            
            
            
            switch (type) {
                    
                case 1://モノクロ
                    
                    // 輝度計算
                    
                    brightness = (77 * red + 28 * green + 151 * blue) / 256;
                    
                    
                    
                    *(tmp + 0) = brightness;
                    
                    *(tmp + 1) = brightness;
                    
                    *(tmp + 2) = brightness;
                    
                    break;
                    
                    
                    
                case 2:
                    
                    *(tmp + 0) = red;
                    
                    *(tmp + 1) = green * 0.7;
                    
                    *(tmp + 2) = blue * 0.4;
                    
                    break;
                    
                    
                    
                case 3:
                    
                    *(tmp + 0) = 255 - red;
                    
                    *(tmp + 1) = 255 - green;
                    
                    *(tmp + 2) = 255 - blue;
                    
                    break;
                    
                    
                    
                default:
                    
                    *(tmp + 0) = red;
                    
                    *(tmp + 1) = green;
                    
                    *(tmp + 2) = blue;
                    
                    break;
                    
            }
            
            
            
        }
        
    }
    
    

    
    CFDataRef   effectedData;
    
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    
    
    
       
    CGDataProviderRef   effectedDataProvider;
    
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    
    
    
   
    
    CGImageRef  effectedCgImage;
    
    UIImage*    effectedImage;
    
    effectedCgImage = CGImageCreate(
                                    
                                    width, height,
                                    
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    
                                    NULL, shouldInterpolate, intent);
    
    effectedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    
    
    
    
    CGImageRelease(effectedCgImage);
    
    CFRelease(effectedDataProvider);
    
    CFRelease(effectedData);
    
    CFRelease(data);
    
    
    
    
    return effectedImage;
}

//UIImage放大(缩小)到指定大小
+ (UIImage *) scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)scaleFromImage:(UIImage *)image MaxHeight:(CGFloat)maxh MaxWidth:(CGFloat)maxw{
    CGFloat h = image.size.height;
    CGFloat w = image.size.width;
    CGFloat s = h/w;
    if (h>maxh) {
        h = maxh;
        w = h/s;
        if (w>maxw) {
            w = maxw;
            h = w*s;
        }
        return [ImageUtil scaleFromImage:image toSize:CGSizeMake(w,h)];
    }else if(w>maxw){
        w = maxw;
        h =w*s;
        return [ImageUtil scaleFromImage:image toSize:CGSizeMake(w,h)];
    }
     
    return image;
}
+(void)saveIamge:(UIImage *)image fileName:(NSString *)filename{
    filename = [ConfigManage getFilePath:filename];
    NSData *data = UIImageJPEGRepresentation(image, 0.7);
    [data writeToFile:filename atomically:TRUE];
}

@end
