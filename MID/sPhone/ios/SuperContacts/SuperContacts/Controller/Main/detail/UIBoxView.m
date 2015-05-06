//
//  UIBoxView.m
//  SuperContacts
//
//  Created by wlpiaoyi on 3/18/14.
//  Copyright (c) 2014 wlpiaoyi. All rights reserved.
//

#import "UIBoxView.h"

@implementation UIBoxView{
    IBOutlet UIButton *buttonConfirm;
    IBOutlet UITextField *lableValue;
    IBOutlet UIButton *buttonCancel;
@private UBVCallBack callBackx;
}
+(id) getNewInstance{
    UIBoxView *rpv =  [[[NSBundle mainBundle] loadNibNamed:@"UIBoxView" owner:self options:nil] lastObject];
    [rpv->buttonConfirm addTarget:rpv action:@selector(clickButtonConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [rpv->buttonCancel addTarget:rpv action:@selector(clickButtonCancel:) forControlEvents:UIControlEventTouchUpInside];
    rpv.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
//    [rpv viewWithTag:86342].backgroundColor = [UIColor colorWithRed:0.067 green:0.373 blue:0.698 alpha:0.6];
    rpv->lableValue.backgroundColor = [UIColor whiteColor];
    [rpv setCornerRadiusAndBorder:rpv->buttonCancel CornerRadius:0 BorderWidth:0.5];
    [rpv setCornerRadiusAndBorder:rpv->buttonConfirm CornerRadius:0 BorderWidth:0.5];
//    [rpv setCornerRadiusAndBorder:rpv->lableValue CornerRadius:5 BorderWidth:0.5];
    [rpv setCornerRadiusAndBorder:[rpv viewWithTag:86342] CornerRadius:5 BorderWidth:0];
    rpv->lableValue.delegate = rpv;
    return rpv;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) setTextValue:(NSString*) value{
    lableValue.text = [NSString isEnabled:value]?value:@"";
}
-(void) clickButtonConfirm:(id) sender{
    if(callBackx){
        callBackx(lableValue.text);
    }
    [self removeFromSuperview];
}
-(void) clickButtonCancel:(id) sender{
    [self removeFromSuperview];
}
-(void) setCallBack:(UBVCallBack) callBack{
    callBackx = callBack;
}
-(void)setCornerRadiusAndBorder:(UIView *)view CornerRadius:(float) cornerRadius BorderWidth:(CGFloat)borderWidth{
    view.layer.cornerRadius = cornerRadius;
    view.layer.borderWidth = borderWidth;
    [view setClipsToBounds:YES];
    view.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self clickButtonConfirm:nil];
    return true;
}
@end
