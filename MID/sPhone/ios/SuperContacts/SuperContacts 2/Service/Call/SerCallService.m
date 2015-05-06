//
//  SerCallService.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SerCallService.h"
#import "EntityUser.h"
#import "SABFromLocationContentService.h"
#import "SABFromDataBaseService.h"
#import "EntityCallRecord.h"
#import "EntityUser.h"
#import "CTM_MainController.h"
#import "UtilsNotifyLocalnotification.h"
#import "UtilsNotification.h"
@interface SerCallService()
@property NSString *currentPhone;
@property bool ifOuting;
@property bool ifGeting;
@property NSDate *getDate;
@property SABFromDataBaseService *fdbs;
@property SABFromLocationContentService *flcs ;
@end;

@implementation SerCallService
-(id) init{
    self = [super init];
    if(self){
        _fdbs = COMMON_FDBS;
        _flcs = COMMON_FLCS;
    }
    return self;
}
+(void) checkCallPhoneNum:(NSString*) phoneNum{
    [UtilsNotification cancelAllNotify];
    UtilsNotifyLocalnotification *u = [[UtilsNotifyLocalnotification alloc]init];
    [[u eventSet:^id(id data, ...) {
        return nil;
    }] setIfOnceNotifys:YES];
    [UtilsNotifyLocalnotification eventAdd:@"key" Value:u];
    SABFromDataBaseService *fdbs = COMMON_FDBS;
    NSArray *array = [fdbs queryEntityUserByPhone:phoneNum];
    EntityUser *user;
    if(array&&[array count]){
        user = array[0];
    }
    if(!user){
        SABFromLocationContentService *flcs = COMMON_FLCS;
        array = [flcs query:nil Phone:phoneNum];
        if(array&&[array count]){
            user = array[0];
        }
    }
    //建立后台消息对象
    UtilsNotification *unf =[[[[[[[[UtilsNotification alloc]init]
                                 setTimess:1]
                                setAlertActions:@"号码信息"]
                               setAlertBodys:user?user.userName:@"未知"]
                              setKeys:@"key"]
                             setTargetDates:[NSDate dateWithTimeIntervalSinceNow:2]
                             ] setAlertActions:@"通话提醒"];
    [unf startNotify];
    [UtilsNotification startNotify];
}
+(void) call:(NSString*) phoneNum{
    @try {
        COMMON_CALL(phoneNum) ;
    }
    @catch (NSException *exception) {
        NSString *msg = [NSString stringWithFormat:@"%@:[%@]",exception.name,exception.reason];
        COMMON_SHOWALERT(msg);
    }
}

-(void) hasCallComing:(NSString*) phoneNum{
    _currentPhone = phoneNum;
    [SerCallService checkCallPhoneNum:phoneNum];
    _ifOuting = false;
    
    NSLog(@"coming phone :%@",phoneNum);
}
-(void) hasCallOuting:(NSString*) phoneNum{
    [SerCallService checkCallPhoneNum:phoneNum];
    _currentPhone = phoneNum;
    _ifOuting = true;
    
    NSLog(@"outing phone :%@",phoneNum);
}
-(void) hasCallDack:(NSString*) phoneNum{
    long timer = [[NSDate new] timeIntervalSinceDate:_getDate];
    NSLog(@"dack time :%li status:%@ hasGet:%@",timer,_ifOuting?@"out":@"come",_ifGeting?@"YES":@"NO");
    EntityUser *results = false;
    NSArray *abas = [_fdbs queryEntityUserByPhone:phoneNum];
    if([abas count]==0){
        _flcs = COMMON_FLCS;
        abas = [_flcs query:nil Phone:phoneNum];
    }
    if([abas count]>0){
        results = [abas objectAtIndex:0];
    }
    EntityCallRecord *record = [[EntityCallRecord alloc] init];
    record.callPhoneNum = phoneNum;
    record.createTime = [NSDate new];
    record.recordTime = timer;
    record.statusCall=0;
    if(_ifOuting){
        record.statusCall = record.statusCall|1;
    }
    if(_ifGeting){
        record.statusCall = record.statusCall|2;
    }
    if(results){
        record.entityUser = results;
    }
    [_fdbs persistEntityCallRecord:record];
    _getDate = false;
    _ifGeting = NO;
    [[CTM_MainController getSingleInstance] refreshRecord];
    [UtilsNotification cancelAllNotify];
    UtilsNotifyLocalnotification *u = [[UtilsNotifyLocalnotification alloc]init];
    [[u eventSet:^id(id data, ...) {
        return nil;
    }] setIfOnceNotifys:YES];
    [UtilsNotifyLocalnotification eventAdd:@"key" Value:u];
    NSDate *d = [@"2011-12-12 00:00:00" dateFormateString:@"yyyy-MM-dd HH:mm:ss"];
    NSString *msg = [NSString stringWithFormat: @"通话时间:%@",[[NSDate dateWithTimeInterval:record.recordTime sinceDate:d] dateFormateDate:@"HH:mm:ss"]];
    //建立后台消息对象
    UtilsNotification *unf =[[[[[[[UtilsNotification alloc]init]
                                 setTimess:1]
                                setAlertActions:@"通话提醒"]
                               setAlertBodys:msg]
                              setKeys:@"key"]
                             setTargetDates:[NSDate new]];
    [unf startNotify];
    [UtilsNotification startNotify];
}
-(void) hasCallGeting:(NSString*) phoneNum{
    _ifGeting = YES;
    _getDate = [NSDate new];
    
    NSLog(@"geting phone :%@ status:%@",phoneNum,_ifOuting?@"out":@"come");
}
@end
