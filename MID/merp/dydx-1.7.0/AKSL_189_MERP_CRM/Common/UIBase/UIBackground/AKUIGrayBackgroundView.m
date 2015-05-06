//
//  AKUIGrayBackgroundView.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-10.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "AKUIGrayBackgroundView.h"

@implementation AKUIGrayBackgroundView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
    // Drawing code
    CGContextSetFillColorWithColor(context,[UIColor colorWithRed:0.878 green:0.898 blue:0.922 alpha:1].CGColor);
    CGContextFillRect(context, rect);
    
}


@end
