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
#import "FDObject.h"
@interface EntityPhone : NSObject<ProtocolEntity>
@property int phoneId;//主键
@property (weak, nonatomic) NSNumber *entityUserId;//所属用户
@property (weak, nonatomic) EntityUser *entityUser;//所属用户
@property NSNumber *type;//类型
@property (strong, nonatomic) NSString *phoneNum;//值
@property (strong, nonatomic) NSMutableDictionary *jsonInfo;
-(EntityUser*) getEntityUser;
-(void) setEntityUserX:(EntityUser *)entityUser;
@end
