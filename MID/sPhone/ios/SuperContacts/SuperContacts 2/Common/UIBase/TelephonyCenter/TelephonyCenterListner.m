//
//  TelephonyCenterListner.m
//  SuperContacts
//
//  Created by wlpiaoyi on 13-12-31.
//  Copyright (c) 2013年 wlpiaoyi. All rights reserved.
//

#import "TelephonyCenterListner.h"
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CoreTelephonyDefines.h>
extern  CFNotificationCenterRef CTTelephonyCenterGetDefault(void); // 获得 TelephonyCenter (电话消息中心) 的引用
extern void CTTelephonyCenterAddObserver(CFNotificationCenterRef center, const void *observer, CFNotificationCallback callBack, CFStringRef name, const void *object, CFNotificationSuspensionBehavior suspensionBehavior);
extern  void CTTelephonyCenterRemoveObserver(CFNotificationCenterRef center, const void *observer, CFStringRef name, const void *object);
extern NSString *CTCallCopyAddress(void *, CTCall *call); //获得来电号码
extern  void CTCallDisconnect(CTCall *call); // 挂断电话
extern  void CTCallAnswer(CTCall *call); // 接电话
extern  void CTCallAddressBlocked(CTCall *call);
extern  int CTCallGetStatus(CTCall *call); // 获得电话状态　拨出电话时为３，有呼入电话时为４，挂断电话时为５
extern  int CTCallGetGetRowIDOfLastInsert(void); // 获得最近一条电话记录在电话记录数据库中的位置
static TelephonyCenterListner *xTelephonyCenterListner;
static id<TelephonyListnerOpt> tlo;
@interface TelephonyCenterListner ()
@property NSTimer *testTimer;
@property bool ifExceTimes;//Timer 是否是第一次执行
@end
@implementation TelephonyCenterListner
+(id) startExcu{
    @synchronized(xTelephonyCenterListner){
        if(!xTelephonyCenterListner){
            xTelephonyCenterListner = [[TelephonyCenterListner alloc]init];
            [xTelephonyCenterListner excuTheCallerListner];
        }
    }
    return xTelephonyCenterListner;
}
-(void) excuTheCallerListner{
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
        backgroundSupported = device.multitaskingSupported;
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _testTimer = [NSTimer scheduledTimerWithTimeInterval:60*60*24 target:self selector:@selector(doSomeAddObserver) userInfo:nil repeats:YES];
        [_testTimer fire];
        [[NSRunLoop currentRunLoop] addTimer:_testTimer forMode:NSRunLoopCommonModes];
        
        [[NSRunLoop currentRunLoop] run];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid) {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}
-(void) doSomeAddObserver{
    if(self.ifExceTimes)return;
    else self.ifExceTimes = YES;
    CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(), NULL, &callBack, CFSTR("kCTCallStatusChangeNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
+(void) setTLOInterface:(id<TelephonyListnerOpt>) _tlo_{
    @synchronized(tlo){
        tlo = _tlo_;
    }
}
static void callBack(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if ([((__bridge NSString *)name) isEqualToString:@"kCTCallStatusChangeNotification"]) {
        NSDictionary *json  = (__bridge NSDictionary *)userInfo;
        CTCall *call = (CTCall *)[json objectForKey:@"kCTCall"];
        // caller 便是来电号码
        NSString *caller = CTCallCopyAddress(0, call);
        // 获得电话状态  接听电话时 1,　拨出电话时为３，有呼入电话时为４，挂断电话时为５
        int status = CTCallGetStatus(call);
//        NSLog(@"the caller is: %@==>status:%d",caller==nil?@"未知":caller,status);
//        CTCallDisconnect(call);//　挂断电话
        @synchronized(tlo){
            if (tlo) {
                switch (status) {
                    case 1:
                        [tlo hasCallGeting:caller];
                        break;
                    case 3:
                        [tlo hasCallOuting:caller];
                        break;
                    case 4:
                        [tlo hasCallComing:caller];
                        break;
                    case 5:
                        [tlo hasCallDack:caller];
                        break;
                    default:
                        break;
                }
            }
        }
    }
}
@end
