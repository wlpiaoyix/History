//
//  UIBoxView.h
//  SuperContacts
//
//  Created by wlpiaoyi on 3/18/14.
//  Copyright (c) 2014 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^UBVCallBack)(NSString *value);

@interface UIBoxView : UIView<UITextFieldDelegate>
+(id) getNewInstance;
-(void) setTextValue:(NSString*) value;
-(void) setCallBack:(UBVCallBack) callBack;

@end
