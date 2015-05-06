//
//  EntityUser.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import "FDObject.h"
@interface EntityUser : NSObject<ProtocolEntity>
@property NSNumber *userId;//主键
@property id userKey;//主键
@property id dataImage;//图像
@property NSString *userName;//用户名
@property NSString *longPingYing;//用户名
@property NSString *shortPingYing;//用户名
@property NSString *tag;//标记
@property NSArray *telephones;//电话号码 或 对应的电话号码实体
@property NSArray *emails;//邮箱
@property NSArray *addresses;//地址
@property NSNumber *locationStatus;//本地状态 0:只存在手机中  1:只存在app中 2:同时存在
@property NSNumber *updateTime;//更新时间,如果 locationStatus=0 则当前字段无效
@property NSMutableDictionary *jsonInfo;//其它信息(json格式)
-(NSArray*) getTelephones;
@end
