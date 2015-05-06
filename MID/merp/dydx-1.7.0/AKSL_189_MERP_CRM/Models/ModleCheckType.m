//
//  ModleCheckType.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "ModleCheckType.h"
#import "ModleCheckBox.h"
@implementation ModleCheckType
+(NSArray*) initWithJSON:(NSDictionary*) json{
    if([json isKindOfClass:[NSArray class]]){
        if(![((NSArray*)json) count]){
            return [NSArray new];
        }
        json = ((NSArray*)json)[0];
    }
    NSEnumerator *t =[json keyEnumerator];
    NSMutableArray *ry =[NSMutableArray new];
    NSString *key;
    int i = 0;
    while (key = [t nextObject]) {
        if([@"trafficPackTypeGroup" isEqual:key]){
            continue;
        }
        NSArray *ayx = [json objectForKey:key];
        i++;
        if(!ayx||![ayx count]){
            continue;
        }
        ModleCheckType *mct = [ModleCheckType new];
        NSDictionary *tempjson = ayx[0];
        mct.text = [[tempjson valueForKey:@"trafficPackTypeName"] stringByAppendingString:@":"];;
        mct.key = ((NSNumber*)[tempjson valueForKey:@"trafficPackTypeId"]).longLongValue;
        NSMutableArray *tempAy = [NSMutableArray new];
        for (NSDictionary *jsonx in ayx) {
            ModleCheckBox *mcb = [ModleCheckBox initWithJSON:jsonx];
            mcb.modleType = mct;
            [tempAy addObject:mcb];
        }
        mct.boxes = tempAy;
        [ry addObject:mct];
    }
    return (NSArray*)ry;
}

@end
