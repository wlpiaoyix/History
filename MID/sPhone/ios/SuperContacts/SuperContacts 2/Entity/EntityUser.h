//
//  EntityUser.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityInterface.h"
#import <AddressBook/AddressBook.h>
@interface EntityUser : NSObject <EntityInterface>
@property int userId;//主键
@property ABRecordRef userRef;//主键
@property int32_t useRefint;
@property id dataImage;//图像
@property NSString *userName;//用户名
@property NSString *longPingYing;//用户名
@property NSString *shortPingYing;//用户名
@property NSString *defaultPhone;//默认号码
@property NSArray *telephones;//电话号码 或 对应的电话号码实体
@property NSArray *emails;//邮箱
@property NSArray *addresses;//地址
@property int locationStatus;//本地状态 0:只存在手机中  1:只存在app中 2:同时存在
@property NSDate *updateTime;//更新时间,如果 locationStatus=0 则当前字段无效
@property NSMutableDictionary *jsonInfo;//其它信息(json格式)
-(NSArray*) getTelephones;
@end
