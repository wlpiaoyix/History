//
//  AKProgressView.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-21.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKProgressView : UIView

- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage;

@property (nonatomic, assign) double progress;
@end
