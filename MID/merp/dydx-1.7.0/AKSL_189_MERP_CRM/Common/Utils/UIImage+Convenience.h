//
//  UIImage+Convenience.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-12-3.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Convenience)

-(UIImage*) setImageSize:(CGSize) size;
-(UIImage*) setImageSize:(float) width Height:(float) height;
-(UIImage*) cutImage:(CGRect) cutValue;
-(UIImage*) cutImageCenter:(CGSize) size;

@end
