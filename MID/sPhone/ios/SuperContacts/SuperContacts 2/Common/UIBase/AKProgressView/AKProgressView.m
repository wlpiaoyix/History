//
//  AKProgressView.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-21.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "AKProgressView.h"

@implementation AKProgressView {
    UIImageView * _backgroundImageView;
    UIImageView * _foregroundImageView;
    CGFloat minimumForegroundWidth;
    CGFloat availableWidth;
    UILabel * lable;
}

-(id)initWithFrame:(CGRect)frame{
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"progressview_bg"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    UIImage *foregroundImage = [[UIImage imageNamed:@"progressview_forground"]resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.image = backgroundImage;
        [self addSubview:_backgroundImageView];
        
        _foregroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _foregroundImageView.image = foregroundImage;
        [self addSubview:_foregroundImageView];
        
        UIEdgeInsets insets = foregroundImage.capInsets;
        minimumForegroundWidth = insets.left + insets.right;
        
        availableWidth = self.bounds.size.width - minimumForegroundWidth;
        lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, self.bounds.size.height)];
        lable.textAlignment = NSTextAlignmentRight;
        lable.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        
        self.progress = 0.5;
        
    }
    return self;

}
- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage foregroundImage:(UIImage *)foregroundImage
{
    [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [foregroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.image = backgroundImage;
        [self addSubview:_backgroundImageView];
        
        _foregroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _foregroundImageView.image = foregroundImage;
        [self addSubview:_foregroundImageView];
        
        UIEdgeInsets insets = foregroundImage.capInsets;
        minimumForegroundWidth = insets.left + insets.right;
        
        availableWidth = self.bounds.size.width - minimumForegroundWidth;
        
        self.progress = 0.5;
    }
    return self;
}

- (void)setProgress:(double)progress
{
    _progress = progress;
    
    CGRect frame = _foregroundImageView.frame;
    frame.size.width = roundf(minimumForegroundWidth + availableWidth * progress);
    _foregroundImageView.frame = frame;
}


@end
