//
//  SROpereationService.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-13.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SROpereationService.h"
#import "FDEntityManager.h"
@interface SROpereationService()
@property FDEntityManager *em;
@end
@implementation SROpereationService
-(id) init{
    self = [self init];
    if(self){
        _em = COMMON_EM;
    }
    return self;
}
-(EntityCallRecord*) persist:(EntityCallRecord*) record{
    if ([NSString isEnabled:record.callPhoneNum]) {
        @throw [[NSException alloc] initWithName:@"EntityCallRecord persist" reason:@"callPhoneNum Can't be null!" userInfo:nil];
    }
    return [_em persist:record];
}
-(EntityCallRecord*) merge:(EntityCallRecord*) record{
    if ([NSString isEnabled:record.callPhoneNum]) {
        @throw [[NSException alloc] initWithName:@"EntityCallRecord merge" reason:@"callPhoneNum Can't be null!" userInfo:nil];
    }
    return [_em persist:record];
}
-(bool) removes:(EntityCallRecord*) record{
    return [_em remove:record];
}
/**
 params主要是匹配longPingYing shortPingYing userName  callPhoneNum
 */
-(NSArray*) queryByParams:(NSString*) params{
    id v = [_em queryBySql:@"select * from EntityCallRecord where callPhoneNum like '%?%'" Clazz:[EntityCallRecord class] Params:[NSArray arrayWithObjects:params, nil]];
    return v;
}
/**
 status:0 无当前记录对应的联系人 1 反之
 */
-(NSArray*) query:(NSString*) userName Phone:(NSString*) phone Status:(int) status{
    NSString *sql = [NSString isEnabled:phone]?[NSString stringWithFormat:@"select * from EntityCallRecord where callPhoneNum like '%%%@%%' order by createTime desc",phone]:@"select * from EntityCallRecord order by createTime desc";
    
    NSMutableArray *temp1  = [NSMutableArray arrayWithArray:[_em queryBySql:sql Clazz:[EntityCallRecord class] Params: nil]];
    NSMutableArray *temp2 = [[NSMutableArray alloc] init];
    if(status){
        for (EntityCallRecord *record in temp1) {
            EntityUser *user = [record getEntityUser];
            if(!user) continue;
            if([NSString isEnabled:userName]){
                if([user.userName hasSuffix:userName]||[user.userName hasPrefix:userName]){
                    [temp2 addObject:user];
                }
            }
        }
    }else{
        for (EntityCallRecord *record in temp1) {
            EntityUser *user = [record getEntityUser];
            if(user) continue;
            [temp2 addObject:user];
        }
    }
    [temp1 removeAllObjects];
    return temp2;
}
@end
