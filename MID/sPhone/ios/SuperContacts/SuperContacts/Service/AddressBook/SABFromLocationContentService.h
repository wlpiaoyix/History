//
//  SABFromLocationContentService.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-8.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityUser.h"
@interface SABFromLocationContentService : NSObject
-(NSArray*) queryByParams:(NSString*) params;
-(NSArray*) queryByName:(NSString *)name;
-(NSArray*) queryByPhone:(NSString*) phone;
-(bool) remove:(EntityUser*) user;
-(EntityUser*) persist:(EntityUser*) user;
-(EntityUser*) merge:(EntityUser*) user;
@end
