//
//  CTM_CallKeyBord.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-13.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_CallKeyBord.h"
#import "SerCallService.h"
static CTM_CallKeyBord *xCallKeyBord;
const unsigned static int xCallKeyBordTagBase = 34534;
@interface CTM_CallKeyBord()
@property (strong, nonatomic) IBOutlet UIButton *button01;
@property (strong, nonatomic) IBOutlet UIButton *button02;
@property (strong, nonatomic) IBOutlet UIButton *button03;
@property (strong, nonatomic) IBOutlet UIButton *button04;
@property (strong, nonatomic) IBOutlet UIButton *button05;
@property (strong, nonatomic) IBOutlet UIButton *button06;
@property (strong, nonatomic) IBOutlet UIButton *button07;
@property (strong, nonatomic) IBOutlet UIButton *button08;
@property (strong, nonatomic) IBOutlet UIButton *button09;
@property (strong, nonatomic) IBOutlet UIButton *button00;
@property (strong, nonatomic) IBOutlet UIButton *buttonstar;
@property (strong, nonatomic) IBOutlet UIButton *buttonalert;
@property (strong, nonatomic) IBOutlet UIButton *buttonCall;
@property (strong, nonatomic) IBOutlet UIButton *buttonDel;
@property (strong, nonatomic) IBOutlet UIView *viewCall;
@property (strong, nonatomic) IBOutlet UIView *viewKeyBorde;
@property (strong, nonatomic) IBOutlet UILabel *lableCallNum;
@property id synbuttondelcancel;
@property bool timebuttonTouch;
@end
@implementation CTM_CallKeyBord
+(id) getInsatnce{
    @synchronized(xCallKeyBord){
        NSArray *temp = [[NSBundle mainBundle] loadNibNamed:@"CTM_CallKeybord" owner:self options:nil];
        xCallKeyBord = [temp lastObject];
        [xCallKeyBord setScrollEnabled:YES];
        xCallKeyBord.delegate = xCallKeyBord;
        [xCallKeyBord setContentSize:xCallKeyBord.frame.size];
        [xCallKeyBord setBg];
        [xCallKeyBord setTargetTag];
        [xCallKeyBord setClickListener];
        [xCallKeyBord setRadius];
    }
    return xCallKeyBord;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) setCallNextMethod:(PhoneCallNext) callNextMethod{
    callNext = callNextMethod;
}

-(void) setPhoneCallValueChangeMethod:(PhoneCallValueChange) callValueChangeMethod{
    callValueChange = callValueChangeMethod;
}
-(NSString*) getCallPhone{
    return _lableCallNum.text;
}
-(void) clearPhone{
    _lableCallNum.text = @"";
}
-(void) setBg{
    _viewKeyBorde.backgroundColor = [UIColor colorWithRed:0.820 green:0.910 blue:0.973 alpha:1];
    _viewCall.backgroundColor = [UIColor colorWithRed:0.106 green:0.451 blue:0.769 alpha:1];
    _buttonCall.backgroundColor = [UIColor colorWithRed:0.820 green:0.910 blue:0.973 alpha:1];
}
-(void) setTargetTag{
    _button00.tag = xCallKeyBordTagBase+0;
    _button01.tag = xCallKeyBordTagBase+1;
    _button02.tag = xCallKeyBordTagBase+2;
    _button03.tag = xCallKeyBordTagBase+3;
    _button04.tag = xCallKeyBordTagBase+4;
    _button05.tag = xCallKeyBordTagBase+5;
    _button06.tag = xCallKeyBordTagBase+6;
    _button07.tag = xCallKeyBordTagBase+7;
    _button08.tag = xCallKeyBordTagBase+8;
    _button09.tag = xCallKeyBordTagBase+9;
    _buttonstar.tag = xCallKeyBordTagBase+10;
    _buttonalert.tag = xCallKeyBordTagBase+11;
    _buttonCall.tag = xCallKeyBordTagBase+12;
    _buttonDel.tag = xCallKeyBordTagBase+13;
}
-(void) setClickListener{
    [_button00 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button01 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button02 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button03 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button04 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button05 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button06 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button07 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button08 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_button09 addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonstar addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonalert addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonCall addTarget:self action:@selector(clickCall:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonDel addTarget:self action:@selector(clickDel:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonDel addTarget:self action:@selector(clickDel1:) forControlEvents:UIControlEventTouchDown];
}
-(void) setRadius{
    [self setButtonRadius:_button00];
    [self setButtonRadius:_button01];
    [self setButtonRadius:_button02];
    [self setButtonRadius:_button03];
    [self setButtonRadius:_button04];
    [self setButtonRadius:_button05];
    [self setButtonRadius:_button06];
    [self setButtonRadius:_button07];
    [self setButtonRadius:_button08];
    [self setButtonRadius:_button09];
    [self setButtonRadius:_buttonalert];
    [self setButtonRadius:_buttonstar];
    [self setButtonRadius:_buttonCall];
}
-(void) setButtonRadius:(UIView*) view {
//    ssc.lableAction.layer.cornerRadius = ssc.lableAction.frame.size.width/2;
//    ssc.lableAction.layer.masksToBounds = YES;
    view.layer.borderWidth = 0.25;
    view.layer.borderColor = [[UIColor grayColor]CGColor];
}
-(void) clickButton:(id) sender{
    NSString *value = _lableCallNum.text;
    switch (((UIButton*)sender).tag) {
        case xCallKeyBordTagBase+0: {
            value = [value stringByAppendingString:@"0"];
        }
            break;
        case xCallKeyBordTagBase+1: {
            value = [value stringByAppendingString:@"1"];
        }
            break;
        case xCallKeyBordTagBase+2: {
            value = [value stringByAppendingString:@"2"];
        }
            break;
        case xCallKeyBordTagBase+3: {
            value = [value stringByAppendingString:@"3"];
        }
            break;
        case xCallKeyBordTagBase+4: {
            value = [value stringByAppendingString:@"4"];
        }
            break;
        case xCallKeyBordTagBase+5: {
            value = [value stringByAppendingString:@"5"];
        }
            break;
        case xCallKeyBordTagBase+6: {
            value = [value stringByAppendingString:@"6"];
        }
            break;
        case xCallKeyBordTagBase+7: {
            value = [value stringByAppendingString:@"7"];
        }
            break;
        case xCallKeyBordTagBase+8: {
            value = [value stringByAppendingString:@"8"];
        }
            break;
        case xCallKeyBordTagBase+9: {
            value = [value stringByAppendingString:@"9"];
        }
            break;
        case xCallKeyBordTagBase+10: {
            value = [value stringByAppendingString:@"*"];
        }
            break;
        case xCallKeyBordTagBase+11: {
            value = [value stringByAppendingString:@"#"];
        }
            break;
        default:
            break;
    }
    _lableCallNum.text = value;
    if(callValueChange){
        callValueChange(value);
    }
}
-(void) clickCall:(id) sender{
    if(![NSString isEnabled:_lableCallNum.text])return;
    [SerCallService call:_lableCallNum.text];
    if(callNext){
        callNext(_lableCallNum.text);
    }
}
-(void) clickDel:(id) sender{
    @synchronized(_synbuttondelcancel){
        if(_timebuttonTouch) return;
        NSString *value = _lableCallNum.text;
        if(![NSString isEnabled:value])return;
        if(value.length==1)value = @"";
        else value = [[value substringFromIndex:0] substringToIndex:value.length-1];
        _lableCallNum.text = value;
        _timebuttonTouch = true;
        if(callValueChange){
            callValueChange(value);
        }
    }
}
-(void) clickDel1:(id) sender{
    _timebuttonTouch = false;
    if(![NSString isEnabled:_lableCallNum.text])return;
    NSThread *t = [[NSThread alloc]initWithTarget:self selector:@selector(clickDel2) object:nil];
    [t start];
}
-(void) clickDel2{
    @synchronized(_synbuttondelcancel){
        [NSThread sleepForTimeInterval:1];
        if(_timebuttonTouch) return;
        _lableCallNum.text = @"";
        _timebuttonTouch = true;
        if(callValueChange){
            callValueChange(_lableCallNum.text );
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"SDFSDF");
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
