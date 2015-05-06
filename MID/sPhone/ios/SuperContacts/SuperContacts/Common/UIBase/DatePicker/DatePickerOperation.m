//
//  DatePickerOperation.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-11.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "DatePickerOperation.h"
@interface DatePickerOperation()
@property (strong, nonatomic) UIDatePicker *datePicker;
@property CGRect *rect;
@property bool isAfterExue;
@end
@implementation DatePickerOperation
-(id) init{
    self = [super init];
    if(self){
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    if(!_isAfterExue){
        self.frame = CGRectMake(0, 0, COMMON_SCREEN_W, COMMON_SCREEN_H);
        self.backgroundColor = [UIColor colorWithRed:0.235 green:0.235 blue:0.235 alpha:0.5];
        self.opaque = NO;
        CGRect r = _datePicker.frame;
        if(IOS7_OR_LATER){
            _datePicker.backgroundColor = [UIColor colorWithRed:0.514 green:0.710 blue:0.078 alpha:1];
            _datePicker.layer.cornerRadius = 5;
            _datePicker.layer.masksToBounds = YES;
            r.size.height = 150;
        }
        r.origin.y = (_datePicker.frame.size.height-r.size.height)/2;
        r.origin.x = (_datePicker.frame.size.width-r.size.width)/2;
        _datePicker.frame = r;
        _datePicker = [[UIDatePicker alloc]init];
        [self addSubview:_datePicker];
        UITapGestureRecognizer *oneTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleOneTap)];
        [oneTapGesture setNumberOfTapsRequired:1];
        NSDate *d = [NSDate new];
        _datePicker.minimumDate = [[[d offsetYear:-2] offsetMonth:-d.month+1] offsetDay:-d.day+1];
        _datePicker.maximumDate = [[[d offsetYear:2]offsetMonth:12-d.month] offsetDay:31-d.day];
        [self addGestureRecognizer:oneTapGesture];
    }
    [super willMoveToSuperview:newSuperview];
}
-(void) handleOneTap{
    [self removeFromSuperview];
    if(callBack){
        callBack(_datePicker.date);
    }
}
-(void) setCallBacks:(DPOReturnBack) callBacks{
    callBack = callBacks;
}


@end
