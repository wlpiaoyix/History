//
//  MovableView.m
//  ShiShang
//
//  Created by wlpiaoyi on 14-11-15.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "MovableView.h"
#import "UIView+Expand.h"
#import "DeviceOrientationListener.h"
#import "Utils.h"
@interface MovableView(){
    CallBackVendorTouchOpt callbackBegin;
    CallBackVendorTouchOpt callbackMove;
    CallBackVendorTouchOpt callbackEnd;
    NSDictionary *dicscrollenabled;
}
@property (nonatomic,assign) MovableView *touchView;
@property (nonatomic,assign) UIView *orgView;
@property (nonatomic) CGPoint offPoint;
@end

@implementation MovableView
-(id) init{
    if (self=[super init]) {
        [self initparams];
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self initparams];
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self initparams];
    }
    return self;
}
-(void) initparams{
    self.exclusiveTouch = YES;
    dicscrollenabled = [NSMutableDictionary new];
    _flagShouldTouchMove = true;
}
-(void) addSubview:(UIView *)view{
    [super addSubview:view];
    if([view isKindOfClass:[MovableView class]]){
        ((MovableView*)view).flagShouldTouchMove = NO;
    }
//    if ([view conformsToProtocol:@protocol(VendorMoveSubViewDelegate)]) {
//        if (!_moveViews) {
//            _moveViews = [NSMutableArray new];
//        }
//        [_moveViews addObject:view];
//    }
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (!_flagShouldTouchMove&&[self.superview isKindOfClass:[self class]]) {
        return;
    }
    for (NSString *key in [dicscrollenabled allKeys]) {
        [dicscrollenabled setValue:nil forKey:key];
    }
    CGPoint point;
    @try {
        UITouch *touch = touches.anyObject;
        point = [touch locationInView: [touch view]];
        
        _touchView = self;
        _orgView = self.superview;
        
        point = [touch locationInView: _orgView];
        _offPoint = point;
        if (callbackBegin) {
            callbackBegin(_touchView.frame);
        }
        [self setScrollView:self enabled:NO deep:0];
    }
    @finally {
    }
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if (!_flagShouldTouchMove&&[self.superview isKindOfClass:[self class]]) {
        return;
    }
    if (_touchView) {
        UITouch *touch = touches.anyObject;
        CGPoint point = [touch locationInView: _orgView];
        float widhtOrg;
        float heightOrg;
        if ([systemVersion floatValue]<8.0f) {
            switch ([DeviceOrientationListener getSingleInstance].orientation) {
                    // Device oriented vertically, home button on the bottom
                case UIDeviceOrientationPortrait:{
                    widhtOrg = _orgView.frameWidth;
                    heightOrg = _orgView.frameHeight;
                }
                    break;
                    // Device oriented vertically, home button on the top
                case UIDeviceOrientationPortraitUpsideDown:{
                    widhtOrg = _orgView.frameWidth;
                    heightOrg = _orgView.frameHeight;
                }
                    break;
                    // Device oriented horizontally, home button on the right
                case UIDeviceOrientationLandscapeLeft:{
                    widhtOrg = _orgView.frameHeight;
                    heightOrg = _orgView.frameWidth;
                }
                    break;
                    // Device oriented horizontally, home button on the left
                case UIDeviceOrientationLandscapeRight:{
                    widhtOrg = _orgView.frameHeight;
                    heightOrg = _orgView.frameWidth;
                }
                    break;
                default:{
                    widhtOrg = _orgView.frameWidth;
                    heightOrg = _orgView.frameHeight;
                }
                    break;
            }
        }else{
            widhtOrg = _orgView.frameWidth;
            heightOrg = _orgView.frameHeight;
        }
        
        
        CGRect r = _touchView.frame;
        r.origin.x += point.x - _offPoint.x;
        r.origin.y += point.y - _offPoint.y;
        if (r.origin.x<0) {
            r.origin.x = 0;
        }
        if (r.origin.y<0) {
            r.origin.y = 0;
        }
        if (r.origin.x>widhtOrg-r.size.width) {
            r.origin.x = widhtOrg-r.size.width;
        }
        if (r.origin.y>heightOrg-r.size.height) {
            r.origin.y = heightOrg-r.size.height;
        }
        _touchView.frame = r;
        _offPoint = point;
        if (callbackMove) {
            callbackMove(_touchView.frame);
        }
    }
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (!_flagShouldTouchMove&&[self.superview isKindOfClass:[self class]]) {
        return;
    }
    @try {
        _offPoint.x = _offPoint.y = 0;
        if (callbackEnd) {
            callbackEnd(_touchView.frame);
        }
    }
    @finally {
        _touchView = nil;
        _orgView = nil;
        [self setScrollView:self enabled:YES deep:0];
        for (NSString *key in [dicscrollenabled allKeys]) {
            [dicscrollenabled setValue:nil forKey:key];
        }
    }
}
-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    if (!_flagShouldTouchMove&&[self.superview isKindOfClass:[self class]]) {
        return;
    }
    [self setScrollView:self enabled:YES deep:0];
    for (NSString *key in [dicscrollenabled allKeys]) {
        [dicscrollenabled setValue:nil forKey:key];
    }
}

-(void) setCallBackVendorTouchBegin:(CallBackVendorTouchOpt) begin{
    callbackBegin = begin;
}
-(void) setCallBackVendorTouchMove:(CallBackVendorTouchOpt) move{
    callbackMove = move;
}
-(void) setCallBackVendorTouchEnd:(CallBackVendorTouchOpt) end{
    callbackEnd = end;
}

-(void) setScrollView:(UIView*) view enabled:(BOOL) enabled deep:(int) deep{
    if ([view isKindOfClass:[UIScrollView class]]) {
        NSString *key = [NSString stringWithFormat:@"%i",deep];
        if (enabled) {
            if ([dicscrollenabled valueForKey:key]) {
                [((UIScrollView*)view) setScrollEnabled:YES];
            }else{
                [((UIScrollView*)view) setScrollEnabled:NO];
            }
        }else{
            if (((UIScrollView*)view).scrollEnabled) {
                [dicscrollenabled setValue:@YES forKey:key];
            }else{
                [dicscrollenabled setValue:nil forKey:key];
            }
            [((UIScrollView*)view) setScrollEnabled:NO];
        }
    }
    if ([view superview]) {
        [self setScrollView:[view superview] enabled:enabled deep:deep+1];
    }
}
-(void) setFrame:(CGRect)frame{
    [super setFrame:frame];
}

@end
