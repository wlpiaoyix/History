//
//  PopUpBasisView.m
//  DXAlertView
//
//  Created by wlpiaoyi on 14-4-9.
//  Copyright (c) 2014年 xiekw. All rights reserved.
//

#import "PopUpBasisView.h"

#define SCREEN_W      CGRectGetWidth([UIScreen mainScreen].bounds)
#define SCREEN_H     CGRectGetHeight([UIScreen mainScreen].bounds)
@implementation PopUpBasisView{
@private
    UIView *contextView;//用来装加入进来的视图
    CGRect contextBaseFrame;//原本的frame
    UIButton *closeButton;//关闭按钮
    bool hasCloseButton;//是否要显示关闭按钮
    dispatch_block_t afterCloseBolock;//关闭之后要作的事情
}
+(PopUpBasisView*) initWithTargetView:(UIView*) targetView{
    //==>init PopUp
    PopUpBasisView  *popUp = [PopUpBasisView new];
    [popUp initParam];
    //<==
    return popUp;
}
-(void) initParam{
    self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    self.backgroundColor = [UIColor colorWithRed:0.129 green:0.137 blue:0.169 alpha:0.6];
    //<==
    //==>
    self->contextView = [UIView new];
    self->contextView.backgroundColor = [UIColor clearColor];
    self->contextView.tag = arc4random() % 999999999;
    [self->contextView setClipsToBounds:YES];
    [self addSubview:self->contextView];
    //<==
    //==>
    UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
    [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
    xButton.frame = CGRectMake(0, 0, 32, 32);
    [xButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    self->closeButton = xButton;
}
-(void) setHasCloseButton:(bool) _hasCloseButton_ {
    self->hasCloseButton = _hasCloseButton_;
}
-(void) setAfterCloseBolock:(dispatch_block_t) _afterCloseBolock_{
    self->afterCloseBolock = _afterCloseBolock_;
}
-(void) close{
    [self removeFromSuperview];
    if(self->afterCloseBolock)self->afterCloseBolock();
}
- (void)show{
    UIViewController *topVC = [PopUpBasisView appRootViewController];
    [topVC.view addSubview:self];
}
-(void) addSubview:(UIView *)view{
    if (view.hash==self->contextView.hash) {
        [super addSubview:self->contextView];
    }else{
        for (UIView *_view_ in [self->contextView subviews]) {
            [_view_ removeFromSuperview];
        }
        
        CGRect r = self->contextView.frame;
        CGRect r2 = view.frame;
        
        r.size.width = r2.size.width+r2.origin.x*2;
        r.size.height = r2.size.height+r2.origin.y*2;
        r.origin.x = (SCREEN_W-r.size.width)/2;
        r.origin.y = (SCREEN_H-r.size.height)/2;
        
        self->contextView.frame = r;
        [self->contextView addSubview:view];
        
        if (self->hasCloseButton) {
            CGRect rb = self->closeButton.frame;
            rb.origin.y = 0;
            rb.origin.x = r.size.width-rb.size.width;
            self->closeButton.frame = rb;
            [self->contextView addSubview:self->closeButton];
        }
        self->contextBaseFrame = self->contextView.frame;
    }
}
- (void)removeFromSuperview{
    [self hiddenRorate];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    [self showRotate];
    [super willMoveToSuperview:newSuperview];
}
-(void) hiddenRorate{
    self.alpha = 1;
    self->contextView.frame = self->contextBaseFrame;
    self->contextView.transform  = CGAffineTransformMakeRotation(0);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect r = self->contextView.frame;
        r.size = CGSizeMake(0, 0);
        r.origin = CGPointMake((self->contextBaseFrame.origin.x+self->contextBaseFrame.size.width)/2, (self->contextBaseFrame.origin.y+self->contextBaseFrame.size.height)/2);
        self->contextView.frame = r;
        self->contextView.transform = CGAffineTransformMakeRotation(M_PI);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.alpha = 1;
        [super removeFromSuperview];
    }];
}
-(void) showRotate{
    self.alpha = 0;
    CGRect r = self->contextView.frame;
    r.size = CGSizeMake(0, 0);
    r.origin = CGPointMake((self->contextBaseFrame.origin.x+self->contextBaseFrame.size.width)/2, (self->contextBaseFrame.origin.y+self->contextBaseFrame.size.height)/2);
    self->contextView.frame = r;
    self.alpha = 0;
    self->contextView.transform = CGAffineTransformMakeRotation(M_PI);
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->contextView.transform = CGAffineTransformMakeRotation(0);
        self->contextView.frame = self->contextBaseFrame;
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
//    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
//        self->contextView.transform = CGAffineTransformMakeRotation(-M_PI*0.44444445);
//        self->contextView.frame = CGRectMake(self->contextBaseFrame.origin.x+(r.origin.x-self->contextBaseFrame.origin.x)*1/4, self->contextBaseFrame.origin.y+(r.origin.y-self->contextBaseFrame.origin.y)*1/4, self->contextBaseFrame.size.width-(self->contextBaseFrame.size.width-r.size.width)*3/4, self->contextBaseFrame.size.height-(self->contextBaseFrame.size.height-r.size.height)*3/4);
//        self.alpha = 0.25;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
//            self->contextView.transform = CGAffineTransformMakeRotation(-M_PI*0.99999);
//            self->contextView.frame = CGRectMake(self->contextBaseFrame.origin.x+(r.origin.x-self->contextBaseFrame.origin.x)/2, self->contextBaseFrame.origin.y+(r.origin.y-self->contextBaseFrame.origin.y)/2, self->contextBaseFrame.size.width-(self->contextBaseFrame.size.width-r.size.width)/2, self->contextBaseFrame.size.height-(self->contextBaseFrame.size.height-r.size.height)/2);
//            self.alpha = 0.5;
//        } completion:^(BOOL finished) {
//            self->contextView.transform = CGAffineTransformMakeRotation(M_PI*0.99999);
//            [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                self->contextView.transform = CGAffineTransformMakeRotation(M_PI*0.444445);
//                self->contextView.frame = CGRectMake(self->contextBaseFrame.origin.x+(r.origin.x-self->contextBaseFrame.origin.x)*3/4, self->contextBaseFrame.origin.y+(r.origin.y-self->contextBaseFrame.origin.y)*3/4, self->contextBaseFrame.size.width-(self->contextBaseFrame.size.width-r.size.width)*1/4, self->contextBaseFrame.size.height-(self->contextBaseFrame.size.height-r.size.height)*1/4);
//                self.alpha = 1;
//            } completion:^(BOOL finished) {
//            }];
//        }];
//    }];

    
}
+ (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
@end
@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
