//
//  FDBObject.m
//  sdf
//
//  Created by wlpiaoyi on 14-3-25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "FDObject.h"
#import "FMDatabase.h"
@implementation FDObject
+(Enum_EntityType) getEnumEnityTypeIndex:(int) index  Number:(long long int) number{
    int offset = -1;
    float targetn = number*1.0;
    while (targetn>=1) {
        targetn /= 10;
        offset++;
    }
    offset -= index;
    if (offset<0) {
        printf("%s","array out of index");
        return 0;
    }
    targetn = number*1.0;
    for (int i=0; i<offset; i++) {
        targetn /= 10;
    }
    int result = targetn*1;
    result = result%10;
    return result;
}

+(NSString*) getCreateSqlByEntity:(id<ProtocolEntity>) entity{
    NSString *table = [entity getTable];
    NSString *key = [entity getKey];
    NSArray *colums = [entity getColums];
    long long int types = [entity getTypes];
    NSString *columsql = [self getCreateColums:colums Types:types];
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT,%@)",table,key,columsql];
    return sql;
}

+(NSString*) getInsertSqlByEnity:(Class<ProtocolEntity>) entity{
    NSString *table = [entity getTable];
    NSArray *colums = [entity getColums];
    NSArray *sqls = [self getInsertColums:colums];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES %@",table,((NSString*)sqls[0]),((NSString*)sqls[1])];
    return sql;
}
+(NSString*) getUpdateSqlByEnity:(Class<ProtocolEntity>) entity{
    NSString *table = [entity getTable];
    NSArray *colums = [entity getColums];
    NSString *key = [entity getKey];
    NSString *sqls = [self getUpdateColums:colums];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@=?",table,sqls,key];
    return sql;
}

+(NSString*) getFindeSqlByEnity:(Class<ProtocolEntity>) entity{
    NSString *table = [entity getTable];
    NSString *key = [entity getKey];
    return [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?",table,key];
}
+(NSString*) getDeleteSqlByEnity:(Class<ProtocolEntity>) entity{
    NSString *table = [entity getTable];
    NSString *key = [entity getKey];
    return [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?",table,key];
}

+(NSString*) getUpdateColums:(NSArray*) colums{
    NSString *columsql = nil;
    for (NSString *arg in colums) {
        if (columsql) {
            columsql = [NSString stringWithFormat:@"%@,%@ = ?", columsql,arg];
        }else{
            columsql = [NSString stringWithFormat:@"%@ = ?",arg];
        }
    }
    return columsql;
}
+(NSArray*) getInsertColums:(NSArray*) colums{
    NSString *columsql = nil;
    NSString *valuesql = @"(";
    for (NSString *arg in colums){
        if(columsql){
            columsql = [NSString stringWithFormat:@"%@,%@",columsql,arg];
            valuesql = [NSString stringWithFormat:@"%@,%c",valuesql,'?'];
        }else {
            columsql = arg;
            valuesql = [NSString stringWithFormat:@"%@%c",valuesql,'?'];
        }
    }
    valuesql = [NSString stringWithFormat:@"%@%c",valuesql,')'];
    
    return [[NSArray alloc]initWithObjects:columsql,valuesql, nil];
}
+(NSString*) getCreateColums:(NSArray*) colums Types:(long long int) types{
    NSString *columsql = @"";
    int index = 0;
    for (NSString *arg in colums) {
        char* _type_ = "";
        switch ([self getEnumEnityTypeIndex:index Number:types]) {
            case 1:
                _type_ = "INTEGER";
                break;
            case 2:
                _type_ = "REAL";
                break;
            case 3:
                _type_ = "TEXT";
                break;
            case 4:
                _type_ = "BLOB";
                break;
                
            default:
                break;
        }
        size_t i = strlen(_type_);
        if(!i){
            printf("Can't find the type on index:%d",index);
            continue;
        }
        if(index==0){
            columsql = [NSString stringWithFormat:@"%@ %s",arg,_type_];
        }else{
            columsql = [NSString stringWithFormat:@"%@,%@ %s",columsql,arg,_type_];
        }
        index++;
    }
    return columsql;
}
@end
