//
//  UIImage+Convenience.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-12-3.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "UIImage+Convenience.h"

@implementation UIImage (Convenience)

-(UIImage*) setImageSize:(CGSize) size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(UIImage*) setImageSize:(float) width Height:(float) height{
    CGSize r = CGSizeMake(width, height);
    return [self setImageSize:r];
}
-(UIImage*) cutImage:(CGRect) cutValue{
    if(![self isKindOfClass:[UIImage class]]){// like the java's instandOf
        return nil;
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage],cutValue);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    return  image;
}
-(UIImage*) cutImageCenter:(CGSize) size{
    float x = (self.size.width-size.width)/2;
    float y = (self.size.height-size.height)/2;
    CGRect r = CGRectMake(x, y, size.width, size.height);
    return [self cutImage:r];
 }
@end
