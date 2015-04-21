//
//  Octest.m
//  aa
//
//  Created by wlpiaoyi on 15/4/11.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "Octest.h"

@implementation Octest

+(long long int) functest{
    long long int sum = 1;
    long long int value = 1;
    for (long i = 0; i < 99999999; i++) {
        sum =  sum << 1;
        if(sum > (value << 61)){
            sum = 1;
        }
//        NSLog(@"fdsads%lli",sum);
    }
    return sum;
}
+(NSUInteger) funcarray{
    NSMutableArray *array = [NSMutableArray new];
    NSNumber *value = @1;
    for (int i = 0; i < 9999999; i++) {
        [array addObject:value];
    }
    return [array count];
}
+(int) funcnew{
    NSNumber *value = @0;
    for (int i = 0; i < 9999999; i++) {
        value = [NSNumber numberWithInt:i];
    }
    return value.intValue;
}

@end
