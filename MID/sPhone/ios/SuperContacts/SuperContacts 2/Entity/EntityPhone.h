//
//  EntityPhone.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-18.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enum_PhoneType.h"
#import "EntityUser.h"
@interface EntityPhone : NSObject<EntityInterface>
@property int phoneId;//主键
@property (weak, nonatomic) EntityUser *entityUser;//所属用户
@property PHONE_TYPE type;//电话类型
@property (strong, nonatomic) NSString *phoneNum;//电话号码
@property (strong, nonatomic) NSMutableDictionary *jsonInfo;
-(EntityUser*) getEntityUser;
-(void) setEntityUserX:(EntityUser *)entityUser;
@end
