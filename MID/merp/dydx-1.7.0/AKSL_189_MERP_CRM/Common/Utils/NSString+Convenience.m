//
//  NSString+Convenience.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-12.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "NSString+Convenience.h"

@implementation NSString (Convenience)

+(bool) isEnabled:(id) target{
    if(!target||target==nil||target==[NSNull null]||[@"" isEqual:target])return NO;
    else return YES;
}

@end
