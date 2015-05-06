//
//  SerCallService.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityCallRecord.h"
#import "TelephonyCenterListner.h"
@interface SerCallService : NSObject <TelephonyListnerOpt>
/**
 打电话
 */
+(void) call:(NSString*) phoneNum;
@end
