//
//  ParsetVcardAndEntity.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-14.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParsetVcardAndEntity : NSObject
+(NSString*) parseEntityToVcard:(NSArray*) users;
+(NSArray*) parseVcardToEntity:(NSString*) vcards;
@end
