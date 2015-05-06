//
//  ShareUtils.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareUtils : NSObject

+(NSArray *)getSharePlatforms;
+(NSString *)getShareTypeString:(int)type Url:(NSString *)url Title:(NSString *)title;
@end
