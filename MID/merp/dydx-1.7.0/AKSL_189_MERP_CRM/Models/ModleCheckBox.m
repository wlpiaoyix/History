//
//  ModleCheckBox.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-20.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "ModleCheckBox.h"

@implementation ModleCheckBox
+(id) initWithJSON:(NSDictionary*) json{
    ModleCheckBox *mcb = [ModleCheckBox new];
    mcb.key = ((NSNumber*)[json objectForKey:@"productId"]).longLongValue;
    mcb.text = [json valueForKey:@"productName"];
    mcb.isSelfReported = ((NSString*)[json valueForKey:@"isSelfReported"]).intValue==0?NO:YES;
    bool isReported = ((NSNumber*)[json valueForKey:@"isReported"]).intValue==1?true:false;
    mcb.isReported = isReported;
    return mcb;
}
@end
