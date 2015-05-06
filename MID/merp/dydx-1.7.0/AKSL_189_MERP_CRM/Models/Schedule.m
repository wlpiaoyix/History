//
//  Schedule.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-25.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "Schedule.h"

@implementation Schedule
 
+(Schedule *)getScheduleByDic:(NSDictionary *)dic{
     Schedule * info = [Schedule new];
    info.contents = [dic objectForKey:@"contents"];
    info.start = [[NSDate dateFormateString:[dic objectForKey:@"remindDate"] FormatePattern:nil]offsetHours:2];
    return  info;
}

@end
