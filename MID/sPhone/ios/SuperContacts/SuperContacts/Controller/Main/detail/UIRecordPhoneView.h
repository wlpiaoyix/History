//
//  UIRecordPhoneView.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-27.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIRecordPhoneCell.h"
typedef void (^RPVCallBack)(void);
typedef void (^RPVCallBack2)(id rpv);
@interface UIRecordPhoneView : UIView
@property bool flagHasSuper;
+(id) getNewInstance;
-(NSString*) getPhoneNumber;
-(NSString*) getLableValue;
-(UIRecordPhoneView*) setKeyBoardType:(UIKeyboardType) keyboardType;
-(UIRecordPhoneView*) setTypeName:(NSString*) typeName;
-(UIRecordPhoneView*) setPhoneNumber:(NSString*) phoneNumber;
-(void) setCallBackResignFirstResponder:(RPVCallBack) rpvcb;
-(void) setCallBackClickLable:(RPVCallBack2) rpvcbButtonLableSet;
-(void) setEntityPhone:(id) phone;
-(id) getEntityPhone;
@end
