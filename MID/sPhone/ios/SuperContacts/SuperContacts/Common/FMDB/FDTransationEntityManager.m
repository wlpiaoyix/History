//
//  FDTransationEntityManager.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-4-7.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "FDTransationEntityManager.h"
#import "FMDatabase.h"
@implementation FDTransationEntityManager{
@private FMDatabase *db;
}
+(id) new{
    id target;
    if((target = [super new])){
        ((FDTransationEntityManager*)target)->db = (id)[((FDTransationEntityManager*)target) getDatabase];
    }
    return target;
}
-(id<ProtocolEntity>) find:(NSNumber*) key Clazz:(Class<ProtocolEntity>) clazz{
    if(![db inTransaction]){
        [db beginDeferredTransaction];
    }
    @try {
        return [super find:key Clazz:clazz];
    }
    @catch (NSException *exception) {
        [db rollback];
        [db close];
        printf("%s",[[exception reason] UTF8String]);
    }
    return nil;
}
-(id<ProtocolEntity>) persist:(id<ProtocolEntity>) entity{
    if(![db inTransaction]){
        [db beginDeferredTransaction];
    }
    @try {
        return [super persist:entity];
    }
    @catch (NSException *exception) {
        [db rollback];
        [db close];
        printf("%s",[[exception reason] UTF8String]);
        @throw exception;
    }
    return nil;
}
-(id<ProtocolEntity>) merge:(id<ProtocolEntity>) entity{
    if(![db inTransaction]){
        [db beginDeferredTransaction];
    }
    @try {
        return [super merge:entity];
    }
    @catch (NSException *exception) {
        [db rollback];
        [db close];
        printf("%s",[[exception reason] UTF8String]);
        @throw exception;
    }
    return nil;
}
-(bool) remove:(id<ProtocolEntity>) entity{
    if(![db inTransaction]){
        [db beginDeferredTransaction];
    }
    @try {
        return [super remove:entity];
    }
    @catch (NSException *exception) {
        [db rollback];
        [db close];
        printf("%s",[[exception reason] UTF8String]);
        @throw exception;
    }
    return false;
}
-(bool) excuSql:(NSString*) sql Params:(NSArray*) params{
    if(![db inTransaction]){
        [db beginDeferredTransaction];
    }
    @try {
        return [super excuSql:sql Params:params];
    }
    @catch (NSException *exception) {
        [db rollback];
        [db close];
        printf("%s",[[exception reason] UTF8String]);
        @throw exception;
    }
    return false;
}
@end
