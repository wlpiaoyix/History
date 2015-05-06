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
    phone_default = 0,
    phone_mobile = 1,
    phone_home = 2,
    phone_company = 3,
    phone_other = 4
} PHONE_TYPE;
@interface Enum_PhoneType : NSObject<EnumsInterface>
+(NSMutableArray*) enums;
@end
