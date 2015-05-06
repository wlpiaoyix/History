//
//  UtilsNotification.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-10-29.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//
static NSMutableArray *UTILSNOTIFICATIONARRAY;
#import "NSDate+convenience.h"
#import "UtilsNotification.h"
@interface UtilsNotification()
@property int times;//提醒时间（秒）
@property NSString *soundName;//提醒声音
@property NSString *alertBody;//提醒内容
@property NSString *alertAction;//标题信息
@property NSCalendarUnit calenderUnit;//提醒周期
@property UILocalNotification *notify;//提醒工具
@property NSDictionary *data;//用户数据
@property NSDate *targetDate;//提醒时间
@property id key;//主键
@end
@implementation UtilsNotification
-(UtilsNotification*) setCalenderUnits:(NSCalendarUnit) calenderUnits{
    self.calenderUnit = calenderUnits;
    return self;
}
-(UtilsNotification*) setAlertActions:(NSString*) alertActions{
    self.alertAction = alertActions;
    return self;
}
-(UtilsNotification*) setNotfys:(UILocalNotification*) notifys{
    self.notify = notifys;
    return self;
}
-(UtilsNotification*) setAlertBodys:(NSString*) alertBodys{
    self.alertBody = alertBodys;
    return self;
}
-(UtilsNotification*) setSoundNames:(NSString*) soundNames{
    self.soundName = soundNames;
    return self;
}
-(UtilsNotification*) setTimess:(int) timess{
    self.times = timess;
    return self;
}
-(UtilsNotification*) setDatas:(NSDictionary*) datas{
    self.data = datas;
    return self;
}
-(UtilsNotification*) setKeys:(id) keys{
    self.key = keys;
    return self;
}
-(UtilsNotification*) setTargetDates:(id) tagetDates{
    self.targetDate = tagetDates;
    return self;
}
-(void) checkValue{
    if(self.times==0)self.times = 1;
    if(!self.targetDate)self.targetDate = [NSDate new]; //
    if(!self.soundName)self.soundName = @"tap.aif";
    if(!self.alertBody)self.alertBody = @"请设置内容";
    if(!self.alertAction)self.alertAction = @"请设置标题";
    if(!self.calenderUnit)self.calenderUnit = NSDayCalendarUnit;
    if(!self.key){
        NSException *ex = [[NSException alloc] initWithName:@"空异常" reason:@"key不能为空！" userInfo:nil];
        @throw ex;
    }
}
/**
 启动计划任务功能
 */
-(void) startNotify{
    if(!self.notify){
        [self checkValue];
        self.notify = [[UILocalNotification alloc]init];
        self.notify.repeatInterval = NSYearCalendarUnit;
        self.notify.fireDate = self.targetDate;//距现在多久后触发
        self.notify.timeZone = [NSTimeZone defaultTimeZone];
        self.notify.soundName = self.soundName;
        self.notify.alertBody = self.alertBody;
        self.notify.alertAction = self.alertAction;
        self.notify.hasAction = YES;
    }
    NSMutableDictionary *userInfo =[[NSMutableDictionary alloc]init];
    [userInfo setValue:self.key forKey:@"key"];
    [userInfo setValue:self.data forKey:@"data"];
    self.notify.userInfo = userInfo;
    if (!UTILSNOTIFICATIONARRAY) {
        UTILSNOTIFICATIONARRAY = [[NSMutableArray alloc]init];
    }
    [UTILSNOTIFICATIONARRAY addObject:self.notify];
}
+(void) startNotify{
    if(UTILSNOTIFICATIONARRAY){
        [UtilsNotification cancelAllNotify];
        [[UIApplication sharedApplication] setScheduledLocalNotifications:UTILSNOTIFICATIONARRAY];
    }
}
+(void) cancelAllNotify{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
@end
