//
//  FDEntityManager.m
//  sdf
//
//  Created by wlpiaoyi on 14-3-25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "FDEntityManager.h"
#import "FMDB.h"
#import "EntityCallRecord.h"
#import "EntityPhone.h"
#import "EntityUser.h"
@implementation FDEntityManager{
@protected
    FMDatabase *db ;
}
-(id) init{
    if(self = [super init]){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        self->db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/%@",((NSString*)paths[0]),COMMON_DATABASE_NAME]];
        if(![db open]){
            printf("open database faild!\n");
            return nil;
        }
        printf("open database success!\n");
//[0]	NSPathStore2 *	@"/Users/wlpiaoyi/Library/Application Support/iPhone Simulator/7.1-64/Applications/020DA358-97B7-43FE-99CD-806F750A170A/Documents"	0x000000010a949830
        NSString *sql = [FDObject getCreateSqlByEntity:[EntityCallRecord class]];
        [db executeUpdate:sql];
        sql = [FDObject getCreateSqlByEntity:[EntityUser class]];
        [db executeUpdate:sql];
        sql = [FDObject getCreateSqlByEntity:[EntityPhone class]];
        [db executeUpdate:sql];
    }
    return self;
}
-(instancetype) getDatabase{
    return (id)db;
}
-(id<ProtocolEntity>) find:(NSNumber*) key Clazz:(Class<ProtocolEntity>) clazz{
    NSString *sql = [FDObject getFindeSqlByEnity:clazz];
    FMResultSet *result = [db executeQuery:sql,key];
    NSArray *array = [FDEntityManager parse:clazz ToResult:result];
    return (array&&[array count])?array[0]:nil;
}
-(id<ProtocolEntity>) persist:(id<ProtocolEntity>) entity{
    @try {
        NSString *sql = [FDObject getInsertSqlByEnity:[entity class]];
        NSArray *colums = [[entity class] getColums];
        NSMutableArray *values = [NSMutableArray new];
        for (NSString *arg in colums) {
            id value = [FDEntityManager getEntity:entity Property:arg];
            value = [FDEntityManager chekcValue:value Index:(int)[colums indexOfObject:arg] Number:[[entity class] getTypes]];
            [values addObject:value];
        }
        if([db executeUpdate:sql withArgumentsInArray:values]){
            return entity;
        }
        return nil;
    }
    @catch (NSException *exception) {
        @throw [[NSException alloc] initWithName:@"persistException" reason:exception.reason userInfo:nil];
    }
}
-(id<ProtocolEntity>) merge:(id<ProtocolEntity>) entity{
    @try {
        NSString *sql = [FDObject getUpdateSqlByEnity:[entity class]];
        NSString *_key = [[entity class] getKey];
        NSArray *colums = [[entity class] getColums];
        NSMutableArray *values = [NSMutableArray new];
        for (NSString *arg in colums) {
            id value = [FDEntityManager getEntity:entity Property:arg];
            value = [FDEntityManager chekcValue:value Index:(int)[colums indexOfObject:arg] Number:[[entity class] getTypes]];
            [values addObject:value];
        }
        [values addObject:[FDEntityManager getEntity:entity Property:_key]];
        if([db executeUpdate:sql withArgumentsInArray:values]){
            return entity;
        }
        return nil;
    }
    @catch (NSException *exception) {
        @throw [[NSException alloc] initWithName:@"mergeException" reason:exception.reason userInfo:nil];
    }
}
-(bool) remove:(id<ProtocolEntity>) entity{
    @try {
        NSString *sql = [FDObject getDeleteSqlByEnity:[entity class]];
        NSNumber *key = [FDEntityManager getEntity:entity Property:[[entity class] getKey]];
        return [db executeUpdate:sql,key];
    }
    @catch (NSException *exception) {
        @throw [[NSException alloc] initWithName:@"removeException" reason:exception.reason userInfo:nil];
    }
}
-(NSArray*) queryBySql:(NSString*) sql Clazz:(Class<ProtocolEntity>) clazz Params:(NSArray*) params{
    FMResultSet *result = [db executeQuery:sql withArgumentsInArray:params];
    NSArray *array = [FDEntityManager parse:clazz ToResult:result];
    return array;
}
-(NSArray*) queryBySql:(NSString *)sql Params:(NSArray *)params{
    FMResultSet *result = [db executeQuery:sql withArgumentsInArray:params];
    NSArray *array = [FDEntityManager parseResult:result];
    return array;
}
-(NSArray*) queryBySqlDic:(NSString *)sql Params:(NSArray *)params{
    FMResultSet *result = [db executeQuery:sql withArgumentsInArray:params];
    NSArray *array = [FDEntityManager parseDictionary:result];
    return array;
}
-(bool) excuSql:(NSString*) sql Params:(NSArray*) params{
    if (params) {
        return [db executeUpdate:sql withArgumentsInArray:params];
    }else{
        return [db executeUpdate:sql];
    }
}
-(void) dealloc{
    [db close];
}
+(void) setEntity:(id<ProtocolEntity>) entity Property:(NSString*) property Value:(id) value{
    NSString *method = [NSString stringWithFormat:@"set%@%@:",[[[property substringToIndex:1] substringFromIndex:0] uppercaseString],[[property substringToIndex:property.length] substringFromIndex:1]] ;
    SEL sel =  NSSelectorFromString(method);
    [entity performSelector:sel withObject:value];
}

+(id) chekcValue:(id) value Index:(int) index Number:(long long int) number{
    if(!value){
        int type= [FDObject getEnumEnityTypeIndex:index Number:number];
        switch (type) {
            case 1:
            {
                value = [NSNumber numberWithInt:0];
            }
                break;
            case 2:
            {
                value = [NSNumber numberWithInt:0];
            }
                break;
            case 3:
            {
                value = @"";
            }
                break;
            case 4:
            {
                value = [NSData new];
            }
                break;
            default:
                value = @"";
                break;
        }
    }
    return value;
}
+(id) getEntity:(id<ProtocolEntity>) entity Property:(NSString*) property{
    SEL sel =  NSSelectorFromString(property);
    id value = [entity performSelector:sel];
    return value;
}
+(id) parse:(Class<ProtocolEntity>) clazz ToResult:(FMResultSet*) result{
    NSMutableArray *array = [NSMutableArray new];
    NSString *_key = [clazz getKey];
    NSArray *colums = [clazz getColums];
    long long int types = [clazz getTypes];
    while ([result next]) {
        int index = 0;
        id<ProtocolEntity> entity = (id<ProtocolEntity>)[NSClassFromString(NSStringFromClass(clazz)) new];
        while (index<[result columnCount]) {
            id value = nil;
            if(index==0){
                NSNumber *num = [NSNumber numberWithInt:[result intForColumnIndex:0]];
                [FDEntityManager setEntity:entity Property:_key Value:num];
                index ++;
                continue;
            }
            int type = [FDObject getEnumEnityTypeIndex:index-1 Number:types];
            switch (type) {
                case 1:
                {
                    value = [NSNumber numberWithInt:[result intForColumnIndex:index]];
                }
                    break;
                case 2:
                {
                    value = [NSNumber numberWithInt:[result intForColumnIndex:index]];
                }
                    break;
                case 3:
                {
                    value = [result stringForColumnIndex:index];
                }
                    break;
                case 4:
                {
                    value = [result dataForColumnIndex:index];
                }
                    break;
                    
                default:
                    break;
            }
            [FDEntityManager setEntity:entity Property:colums[index-1] Value:value];
            index++;
        }
        [array addObject:entity];
    }
    return array;
}
+(id) parseResult:(FMResultSet*) result{
    NSMutableArray *array = [NSMutableArray new];
    while ([result next]) {
        int index = 0;
        NSMutableArray *values = [NSMutableArray new];
        while (index<[result columnCount]) {
            id value = [result objectForColumnIndex:index];
            [values addObject:value];
            index++;
        }
        [array addObject:values];
    }
    return array;
}
+(id) parseDictionary:(FMResultSet*) result{
    NSMutableArray *array = [NSMutableArray new];
    while ([result next]) {
        int index = 0;
        NSMutableArray *values = [NSMutableArray new];
        while (index<[result columnCount]) {
            id value = [result objectForColumnIndex:index];
            NSString *key = [result columnNameForIndex:index];
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:value forKey:key];
            [values addObject:dic];
            index++;
        }
        [array addObject:values];
    }
    return array;
}

@end
