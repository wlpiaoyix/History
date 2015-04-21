//
//  FDCBaseManger.h
//  FDC
//
//  Created by wlpiaoyi on 15/1/16.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ConfigManage+Expand.h"
#import "UserEntity.h"
extern NSString *const URL_BASE_HTTP;

extern NSString *const KEY_STATU_CODE;
extern NSString *const KEY_PROMPT_MSG;
extern NSString *const KEY_RESULT_DATA;

@interface FDCBaseManger : NSObject
@property (nonatomic,strong) FDEntityManager *em;
-(id) checkData:(id) data;
-(id<HttpUtilRequestDelegate>) createRequestWith:(NSString*) action;
-(NSString*) getKeyConfiger:(NSString*) key;
@end
