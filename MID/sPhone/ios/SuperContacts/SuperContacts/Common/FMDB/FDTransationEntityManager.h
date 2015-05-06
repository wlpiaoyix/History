//
//  FDTransationEntityManager.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-4-7.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "FDEntityManager.h"

@interface FDTransationEntityManager : FDEntityManager
-(id<ProtocolEntity>) find:(NSNumber*) key Clazz:(Class<ProtocolEntity>) clazz;
-(id<ProtocolEntity>) persist:(id<ProtocolEntity>) entity;
-(id<ProtocolEntity>) merge:(id<ProtocolEntity>) entity;
-(bool) remove:(id<ProtocolEntity>) entity;
-(bool) excuSql:(NSString*) sql Params:(NSArray*) params;
@end
