//
//  CTM_CallKeyBord.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-13.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PhoneCallNext)(id target);
typedef void (^PhoneCallValueChange)(NSString* chanageValue);
@interface CTM_CallKeyBord : UIScrollView<UIScrollViewDelegate>{
    PhoneCallNext callNext;
    PhoneCallValueChange callValueChange;
}
+(id) getInsatnce;
/**
 当前电话号码
 */
-(NSString*) getCallPhone;
-(void) clearPhone;
-(void) setCallNextMethod:(PhoneCallNext) callNextMethod;
-(void) setPhoneCallValueChangeMethod:(PhoneCallValueChange) callValueChangeMethod;
@end
