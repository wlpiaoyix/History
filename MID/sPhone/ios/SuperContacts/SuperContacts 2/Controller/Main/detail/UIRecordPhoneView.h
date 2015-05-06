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
@interface UIRecordPhoneView : UIView
+(id) getNewInstance;
-(NSString*) getPhoneNumber;
-(UIRecordPhoneView*) setKeyBoardType:(UIKeyboardType) keyboardType;
-(UIRecordPhoneView*) setTypeName:(NSString*) typeName;
-(UIRecordPhoneView*) setPhoneNumber:(NSString*) phoneNumber;
-(void) setCallBackResignFirstResponder:(RPVCallBack) rpvcb;
-(void) setEntityPhone:(id) phone;
-(id) getEntityPhone;
@end
