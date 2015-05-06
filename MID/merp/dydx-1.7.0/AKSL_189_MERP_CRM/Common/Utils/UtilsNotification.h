//
//  UtilsNotification.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-10-29.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UtilsNotifyLocalnotification.h"
@interface UtilsNotification : NSObject
-(UtilsNotification*) setCalenderUnits:(NSCalendarUnit) calenderUnits;
-(UtilsNotification*) setNotfys:(UILocalNotification*) notifys;
-(UtilsNotification*) setAlertActions:(NSString*) alertActions;
-(UtilsNotification*) setAlertBodys:(NSString*) alertBodys;
-(UtilsNotification*) setSoundNames:(NSString*) soundNames;
-(UtilsNotification*) setTimess:(int) timess;
-(UtilsNotification*) setDatas:(NSDictionary*) datas;
-(UtilsNotification*) setKeys:(id) keys;
-(UtilsNotification*) setTargetDates:(id) tagetDates;
-(void) startNotify;
+(void) startNotify;
+(void) cancelAllNotify;
@end
