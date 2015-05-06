//
//  UIBaseButtomShowView.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 12/12/13.
//  Copyright (c) 2013 AKSL. All rights reserved.
//

#import "UIBaseButtomShowView.h"
#import "UIView+convenience.h"
#import "UIBaseButtomShowViewConfigure.h"

@interface UIBaseButtomShowView()
@property (setter = setTextSize:)  float textSize;
@property (copy,getter = getFontName, setter = setFontName:) NSString * fontName;
@property (setter = setTextAlignment:) int textAlignment;
@property (copy, getter = getBackgroundColorLable, setter = setBackgroundColorLable:) UIColor *backgroundColorLable;
@property (setter = setLableAque:) float lableAque;
@property (strong, nonatomic) UIFont *fontLable;
@property (strong, nonatomic) UILabel *lableText;
@end
@implementation UIBaseButtomShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
/**
 对各个属性设值，如果是空就设为默认值
 */
-(void) checkDefault{
    if(!self.textAlignment)self.textAlignment = NSTextAlignmentCenter;
    if(!self.backgroundColorLable||self.backgroundColorLable == nil)self.backgroundColorLable = [UIBaseButtomShowViewConfigure getBackGroundColor];
    if(!self.lableAque)self.lableAque = [UIBaseButtomShowViewConfigure getLableAque];
    self.fontLable = [UIFont fontWithName:self.fontName?self.fontName:self.lableText.font.familyName size:self.textSize?self.textSize:[UIBaseButtomShowViewConfigure getTextSize]];
}
-(void) showText:(NSString*) text{
    self.lableText = [[UILabel alloc]init];
    [self checkDefault];
   bool flag =  [[UIBaseButtomShowViewConfigure getLock] tryLock];
    if(!flag){
        return;
    }
    @try {
        self.lableText.lineBreakMode = NSLineBreakByWordWrapping;
        self.lableText.backgroundColor = self.backgroundColorLable;
        self.lableText.textAlignment = self.textAlignment;
        self.lableText.font = self.fontLable;
        self.lableText.numberOfLines = 0;
        self.lableText.text = text;
        CGRect r = [[UIScreen mainScreen] applicationFrame];
        self.lableText.frameWidth = r.size.width;
        CGSize size=[text sizeWithFont:self.fontLable constrainedToSize:CGSizeMake(self.lableText.frame.size.width, 1000)];
        size.width = 320.0f;
        size.height +=33.0f;
        self.lableText.frameSize = size;
        
        self.frameX = 0.0f;
        self.frameY = r.size.height;
        self.frameHeight = size.height;
        self.frameSize = size;
        
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIBaseButtomShowViewConfigure getBorderColor];
        
        [self addSubview:self.lableText];
        
        self.opaque = YES;
        self.alpha = self.lableAque;
        
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
        
        [UIView animateWithDuration:0.5f animations:^{
            self.frameY -=self.frameHeight;
        }];
        NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                     selector:@selector(setSelfHidden:)
                                                       object:nil];
        [myThread start];
        [myThread release];
    }
    @catch (NSException *exception) {
        NSLog(@"EXCUE lock has exception:%@",[exception name]);
        [[UIBaseButtomShowViewConfigure getLock] unlock];
    }
    @finally {
        [self.backgroundColorLable release];
        [self.fontName release];
        [self.fontLable release];
        [self.lableText release];
        [text release];
    }
}
-(void) setSelfHidden:(NSNumber*) timeInterval{
    [NSThread sleepForTimeInterval:timeInterval?timeInterval.floatValue:3.0f];
    @try {
        [UIView animateWithDuration:0.5f animations:^{
            self.frameY +=self.frameHeight;
        }];
        NSThread * myThread =  [[NSThread alloc] initWithTarget:self
                                                       selector:@selector(setSelfRemove:)
                                                         object:nil];
        [myThread start];
        [myThread release];
    }
    @catch (NSException *exception) {
        [[UIBaseButtomShowViewConfigure getLock] unlock];
        [self removeFromSuperview];
    }
}
-(void) setSelfRemove:(NSNumber*) timeInterval{
    [NSThread sleepForTimeInterval:timeInterval?timeInterval.floatValue:0.5f];
    @try {
        [self removeFromSuperview];
    }
    @finally {
        [[UIBaseButtomShowViewConfigure getLock] unlock];
    }
}
-(oneway void) release{
    NSLog(@"(release)show view in current thread hash is :%d",[[NSThread currentThread] hash]);
    [super release];
}
-(void) dealloc{
    NSLog(@"(delloc) show view in current thread has is :%d",[[NSThread currentThread] hash]);
    [super dealloc];
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
