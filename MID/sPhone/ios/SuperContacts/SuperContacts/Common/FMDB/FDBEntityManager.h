//
//  FDBEntityManager.h
//  sdf
//
//  Created by wlpiaoyi on 14-3-25.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDBObject.h"

@interface FDBEntityManager : NSObject
-(id) initWithTransaction;
-(instancetype) getDatabase;
-(id<ProtocolEntity>) find:(NSNumber*) key Clazz:(Class<ProtocolEntity>) clazz;
-(id<ProtocolEntity>) persist:(id<ProtocolEntity>) entity;
-(id<ProtocolEntity>) merge:(id<ProtocolEntity>) entity;
-(bool) remove:(id<ProtocolEntity>) entity;
-(bool) excuSql:(NSString*) sql Params:(NSArray*) params;
-(NSArray*) queryBySql:(NSString*) sql Clazz:(Class<ProtocolEntity>) clazz Params:(NSArray*) params;
-(NSArray*) queryBySql:(NSString *)sql Params:(NSArray *)params;
-(NSArray*) queryBySqlDic:(NSString *)sql Params:(NSArray *)params;
@end
