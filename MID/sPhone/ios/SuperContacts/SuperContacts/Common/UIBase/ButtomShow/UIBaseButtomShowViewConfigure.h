//
//  UIBaseButtomShowViewConfigure.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 12/13/13.
//  Copyright (c) 2013 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 Object c 会自动回收静态变量，所以静态变量要单独写
 */
@interface UIBaseButtomShowViewConfigure : NSObject
+(NSConditionLock*) getLock;
+(CGColorRef)  getBorderColor;
+(UIColor*) getBackGroundColor;
+(float) getTextSize;
+(float) getLableAque;
@end
