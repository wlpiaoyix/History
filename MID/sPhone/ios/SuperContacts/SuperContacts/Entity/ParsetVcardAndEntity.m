//
//  ParsetVcardAndEntity.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-14.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ParsetVcardAndEntity.h"
#import "EntityUser.h"
#import "EntityPhone.h"
@implementation ParsetVcardAndEntity
+(EntityUser*) parseUser:(NSArray*) vcard{
    EntityUser *user = [EntityUser new];
    NSMutableArray *telephones = [NSMutableArray new];
    NSEnumerator *nse = [vcard objectEnumerator];
    [nse nextObject];
    [nse nextObject];
    NSString *temp;
    while (temp = [nse nextObject]) {
        if([temp stringStartWith:@"FN:"]){
            NSArray *xx = [temp componentsSeparatedByString:@":"];
            if([xx count]>1){
                user.userName = [xx objectAtIndex:1];
            }
        }else if([temp stringStartWith:@"LPY:"]){
            NSArray *xx = [temp componentsSeparatedByString:@":"];
            if([xx count]>1){
                user.longPingYing = [xx objectAtIndex:1];
            }
        }else if([temp stringStartWith:@"SPY:"]){
            NSArray *xx = [temp componentsSeparatedByString:@":"];
            if([xx count]>1){
                user.shortPingYing = [xx objectAtIndex:1];
            }
        }else if([temp stringStartWith:@"JSON:"]){
            if(temp.length>= @"JSON:".length){
                NSString *arg = [temp substringFromIndex:@"JSON:".length];
                user.jsonInfo = [arg JSONValue];
            }
        }else if([temp stringStartWith:@"TEL;"]){
            NSArray *xx = [temp componentsSeparatedByString:@";"];
            for (NSString *x in xx) {
                if ([telephones count]>[[Enum_PhoneType enums] count]-1) {
                    continue;
                }
                NSArray *phonex = [x componentsSeparatedByString:@"="];
                if([phonex count]>1){
                    NSArray *phoned = [phonex[1] componentsSeparatedByString:@":"];
                    if([phoned count]>1){
                        EntityPhone *phone = [EntityPhone new];
                        phone.type = [NSNumber numberWithInt:(int)[telephones count]];
                        phone.phoneNum = phoned[1];
                        [telephones addObject:phone];
                    }
                }
            }
        }
    }
    if([telephones count]){
        user.telephones = telephones;
    }
    return user;
}
+(NSArray*) parseVcard:(EntityUser*) user{
    NSMutableArray *vcard = [NSMutableArray new];
    NSString *userName = [NSString stringWithFormat:@"FN:%@",user.userName];
    NSString *longPingYing = [NSString stringWithFormat:@"LPY:%@",user.longPingYing];
    NSString *shortPingYing = [NSString stringWithFormat:@"SPY:%@",user.shortPingYing];
    NSString *JSON = [NSString stringWithFormat:@"JSON:%@",[user.jsonInfo JSONRepresentation]];
    [vcard addObject:@"BEGIN:VCARD"];
    [vcard addObject:@"VERSION:3.0"];
    [vcard addObject:userName];
    [vcard addObject:longPingYing];
    [vcard addObject:shortPingYing];
//    [vcard addObject:defaultPhone];
    [vcard addObject:JSON];
    NSMutableArray *telephons = [NSMutableArray new];
    for (EntityPhone *phone in [user getTelephones]) {
        NSString *arg = [NSString stringWithFormat:@"TEL;TYPE=%@:%@",[Enum_PhoneType valueByEnum:phone.type.intValue],phone.phoneNum];
        [telephons addObject:arg];
    }
    if([telephons count])[vcard addObjectsFromArray:telephons];
    [vcard addObject:@"END:VCARD"];
    return vcard;
}
+(NSString*) parseEntityToVcard:(NSArray*) users{
    NSMutableArray *temp = [NSMutableArray new];
    for (EntityUser *user in users) {
        NSArray *tempx = [ParsetVcardAndEntity parseVcard:user];
        [temp addObjectsFromArray:tempx];
    }
    NSString *arg = @"";
    for (NSString *argx in temp) {
        arg = [[arg stringByAppendingString:argx] stringByAppendingString:@"\n"];
    }
    return arg;
}
+(NSArray*) parseVcardToEntity:(NSString*) vcards{
    NSArray *temp = [vcards componentsSeparatedByString:@"\n"];
    NSMutableArray *temp1 = [NSMutableArray new];
    NSMutableArray *temp1x = [NSMutableArray new];
    for (NSString *arg1 in temp) {
        [temp1x addObject:arg1];
        if([arg1 stringStartWith:@"END:VCARD"]){
            NSMutableArray *temp2x = [NSMutableArray new];
            [temp2x addObjectsFromArray:temp1x];
            [temp1 addObject:temp2x];
            [temp1x removeAllObjects];
        }
    }
    NSMutableArray *temp2 = [NSMutableArray new];
    for (NSMutableArray *temp1xx in temp1) {
        [temp2 addObject:[ParsetVcardAndEntity parseUser:temp1xx]];
        [temp1xx removeAllObjects];
    }
    [temp1 removeAllObjects];
    return temp2;
}
@end
