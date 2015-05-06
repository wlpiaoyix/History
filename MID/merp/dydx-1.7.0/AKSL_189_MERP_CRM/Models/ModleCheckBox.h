//
//  ModleCheckBox.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-20.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModleCheckType.h"
@interface ModleCheckBox : NSObject
@property long long int key;
@property (strong, nonatomic) NSString *text;
@property (weak, nonatomic) ModleCheckType *modleType;
@property bool isReported;
@property bool isSelfReported;
@property bool isSelected;
+(id) initWithJSON:(NSDictionary*) json;
@end
