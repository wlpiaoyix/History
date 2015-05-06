//
//  DrawCircle.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-10-25.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawCircle : NSObject
+ (void)drawLine:(CGRect)rect Startx:(int) startx Starty:(int) starty Endx:(int) endx Endy:(int) endy Bound:(int) bound ColorRef:(CGColorRef) colorRef;
@end
