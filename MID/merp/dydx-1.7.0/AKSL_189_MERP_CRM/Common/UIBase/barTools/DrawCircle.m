//
//  DrawCircle.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-10-25.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "DrawCircle.h"

@implementation DrawCircle
+ (void)drawLine:(CGRect)rect Startx:(int) startx Starty:(int) starty Endx:(int) endx Endy:(int) endy Bound:(int) bound ColorRef:(CGColorRef) colorRef{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextClearRect(context, rect);
    CGContextBeginPath(context);
    int crx = endx-startx;
    int cry = endy-starty;
    if(crx==0){
    }else if(cry==0){
    }else{
    }
    CGContextMoveToPoint   (context, startx, starty);
    CGContextAddLineToPoint(context, endx, endy);
    CGContextAddLineToPoint(context, endx, endy+bound);
    CGContextAddLineToPoint(context, startx, starty+bound);
    CGContextClosePath(context);
    
    CGContextSetFillColorWithColor(context, colorRef);
    CGContextFillPath(context);
    NSLog(@"x:%dy:%d", startx, starty);
    NSLog(@"x:%dy:%d", endx, endy);
    NSLog(@"x:%dy:%d", endx, endy+bound);
    NSLog(@"x:%dy:%d", startx, starty+bound);

}
@end
