//
//  Schedule.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-25.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedule : NSObject

@property (strong,nonatomic) NSString * contents;
@property (strong,nonatomic) NSDate * start;

+(Schedule *)getScheduleByDic:(NSDictionary *)dic;

@end
