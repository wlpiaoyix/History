//
//  ModleCheckType.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModleCheckType : NSObject
@property long long int key;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSArray *boxes;
@property bool isSelfReported;
+(NSArray*) initWithJSON:(NSDictionary*) json;
@end
