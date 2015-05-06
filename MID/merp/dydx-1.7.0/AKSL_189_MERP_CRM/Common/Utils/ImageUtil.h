//
//  ImageUtil.h
//  anbaby
//
//  Created by MacChao on 13-8-21.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtil : NSObject

+(UIImage*) grayscale:(UIImage*)anImage type:(char)type;
+ (UIImage *) scaleFromImage:(UIImage *)image toSize:(CGSize)size;
+(UIImage *)scaleFromImage:(UIImage *)image MaxHeight:(CGFloat)maxh MaxWidth:(CGFloat)maxw;
+(void)saveIamge:(UIImage *)image fileName:(NSString *)filename;
@end
