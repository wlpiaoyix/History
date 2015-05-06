//
//  UtilsNotifyLocalnotification.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-10-29.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//
#import <UIKit/UIKit.h> // Necessary for background task support


@interface UtilsNotifyLocalnotification : NSObject<UIAlertViewDelegate>{
    CallBakeMethod _didDo;
};
/**
 事件响应后要做的事
 */
-(UtilsNotifyLocalnotification*) eventSet:(CallBakeMethod)didDo;
-(UtilsNotifyLocalnotification*) setIfOnceNotifys:(bool) ifOnceNotifys;
+(void) eventAdd:(id) key Value:(UtilsNotifyLocalnotification*) value;
+(void) eventDo:(id) key Data:(id) data;
+(void) eventDelet:(id) key;
+(void) initDicUtilsNotifyLocalnotifications;
+(void) initNsNotifyLocalnotifications;
@end
