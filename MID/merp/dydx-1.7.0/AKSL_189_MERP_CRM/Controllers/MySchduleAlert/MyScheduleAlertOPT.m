//
//  MyScheduleAlertOPT.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-14.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "MyScheduleAlertOPT.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "NSDate+convenience.h"
#import "UtilsNotification.h"
@implementation MyScheduleAlertOPT

+(void) getAlertInfo{
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:@"/api/schedules/schedulesofself" Params:nil Logo:@"myschedul_alert"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSArray *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                return;
            }
            for (NSDictionary *json in temp) {
                NSDate *targetDate = [NSDate dateFormateString:[json objectForKey:@"remindDate"] FormatePattern:nil];
                
                NSString *title = [[[NSDate dateFormateDate:targetDate FormatePattern:@"MM-dd HH:mm"]stringByAppendingString:@" > "] stringByAppendingString:[json objectForKey:@"title"]];
                
                [UtilsNotification cancelAllNotify];
                UtilsNotifyLocalnotification *u = [[UtilsNotifyLocalnotification alloc]init];
                [[u eventSet:^id(id data, ...) {
                    return nil;
                }] setIfOnceNotifys:YES];
                [UtilsNotifyLocalnotification eventAdd:@"key" Value:u];
                //建立后台消息对象
                UtilsNotification *unf =[[[[[[[UtilsNotification alloc]init]
                                            setTimess:1]
                                            setAlertActions:@"日程提醒"]
                                            setAlertBodys:title]
                                            setKeys:@"key"]
                                            setTargetDates:targetDate];
                [unf startNotify];
            }
            [UtilsNotification startNotify];
        }
        @catch (NSException *exception) {
            return;
        }
        @finally {
        }
    }];
    [request setFailedBlock:^{
    }];
    [UtilsNotification cancelAllNotify];
    [request startAsynchronous];

}
@end
