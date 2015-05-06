//
//  Organization.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-27.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Organization : NSObject
@property long long orgId;
@property long long orgParentId;
@property (retain, nonatomic) NSString *orgPhoneNum;
@property (retain, nonatomic) NSString *orgShortName;
@property (retain, nonatomic) NSString *orgFullName;
+(Organization*) getInstance;
+(Organization*) getNewInstance;
@end
