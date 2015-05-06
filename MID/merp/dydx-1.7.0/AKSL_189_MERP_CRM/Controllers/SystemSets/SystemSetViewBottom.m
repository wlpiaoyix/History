//
//  SystemSetViewBottom.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-2.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetViewBottom.h"

@implementation SystemSetViewBottom
+(SystemSetViewBottom*) init{
    SystemSetViewBottom *svb = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetViewBottom" owner:self options:nil] lastObject];
    svb.backgroundColor = [UIColor colorWithRed:0.525 green:0.718 blue:0.086 alpha:1];
    return svb;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.525 green:0.718 blue:0.086 alpha:1];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
