//
//  SwitchSelected.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-1-10.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwitchSelected : NSObject
@property long long key;
@property NSString *value;
@property bool isSelected;
@property bool isReported;
@property bool isSelf;
@property NSString *reportName;
@property NSString *reportNum;
@property NSDate * tempDate;

@end
