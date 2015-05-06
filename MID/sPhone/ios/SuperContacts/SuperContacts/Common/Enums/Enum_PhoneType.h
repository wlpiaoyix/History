//
//  Enum_PhoneType.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-18.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Enums.h"
typedef enum{
    phone_home = 0,
    phone_main = 1,
    phone_work = 2,
    phone_mobile = 3,
    phone_iphone = 4,
    phone_pager = 5,
    phone_homeFax = 6,
    phone_workFax = 7,
    phone_otherFax = 8
} PHONE_TYPE;
@interface Enum_PhoneType : NSObject<EnumsInterface>
+(NSMutableArray*) enums;
@end
