//
//  EntityCallRecord.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDObject.h"
#import "EntityUser.h"
@interface EntityCallRecord : NSObject<ProtocolEntity>
@property NSNumber *recordId;//主键
@property NSString *callPhoneNum;//操作对应的电话号码
@property NSNumber *recordTime;//通话时间
@property NSNumber *statusCall;//通话状态 0 :打入 未接 1:打出未接 2:打入已接 3:打出已接
@property (nonatomic)EntityUser *entityUser;//当前记录触发对象
@property NSNumber *createTime;//创建时间
@property NSMutableDictionary *jsonInfo;//其它信息(json格式)
-(EntityUser*) getEntityUser;
-(void) setEntityUser:(EntityUser*) entityUser;
@end
