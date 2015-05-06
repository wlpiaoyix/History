//
//  UIRecordPhoneView.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "UIRecordPhoneView.h"
#import "EntityPhone.h"
@interface UIRecordPhoneView(){
    IBOutlet UILabel *lableTypeName;
    IBOutlet UITextField *textfieldPhone;
@private
    RPVCallBack rpvcbx;
    EntityPhone *phonex;
    bool flagInit;
}
@end
@implementation UIRecordPhoneView
+(id) getNewInstance{
    UIRecordPhoneView *rpv =  [[[NSBundle mainBundle] loadNibNamed:@"UIRecordPhoneView" owner:self options:nil] lastObject];
    [rpv setDefaultValue];
    return rpv;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    ;
    return self;
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    @try {
        if(flagInit){
            return;
        }
        flagInit = YES;
        if(phonex){
            self->lableTypeName.text = [NSString stringWithFormat:@"%@:",[Enum_PhoneType nameByEnum:phonex.type]];
            if([NSString isEnabled:phonex.phoneNum])self->textfieldPhone.text = phonex.phoneNum;
        }
    }
    @finally {
        [super willMoveToSuperview:newSuperview];
    }
}
-(NSString*) getPhoneNumber{
    return self->textfieldPhone.text;
}
-(UIRecordPhoneView*) setKeyBoardType:(UIKeyboardType) keyboardType{
    textfieldPhone.keyboardType = keyboardType;
    return self;
}
-(UIRecordPhoneView*) setTypeName:(NSString*) typeName{
    self->lableTypeName.text = typeName;
    return self;
}
-(UIRecordPhoneView*) setPhoneNumber:(NSString*) phoneNumber{
    self->textfieldPhone.text = phoneNumber;
    return self;
}
- (BOOL)resignFirstResponder{
    if (rpvcbx) {
        rpvcbx();
    }
    return [textfieldPhone resignFirstResponder]&&[super resignFirstResponder];
}
-(void) setEntityPhone:(EntityPhone*) phone{
    phonex = phone;
}
-(EntityPhone*) getEntityPhone{
    if(!phonex)return nil;
    if(![NSString isEnabled:textfieldPhone.text])return nil;
    phonex.phoneNum = textfieldPhone.text;
    return phonex;
}
-(void) setDefaultValue{
    [self setKeyBoardType:UIKeyboardTypeNumberPad];
}
-(void) setCallBackResignFirstResponder:(RPVCallBack) rpvcb{
    self->rpvcbx = rpvcb;
}
@end
