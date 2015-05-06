//
//  LocationAddressBook.h
//  SuperContacts
//
//  Created by wlpiaoyi on 3/17/14.
//  Copyright (c) 2014 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityUser.h"

@interface LocationAddressBook : NSObject
/**
 查询出对应的记录
 */
- (NSMutableArray*) queryContentByName:(NSString*)searchText;
/**
 查询出对应的记录
 */
- (NSMutableArray*) queryContent;
///**
// 查询出对应的记录
// */
//- (NSMutableArray*) queryContentByParams:(NSString*) params;
/**
 新增通信录
 */
-(ABRecordRef) persistContent:(NSDictionary*) jsonContent;
/**
 更新通信录
 */
-(bool) mergeContent:(NSDictionary*) jsonContent UserRef:(ABRecordRef) userRef;
/**
 删除记录
 */
-(bool) removeContent:(ABRecordRef) recordRef;
/**
 得到记录
 */
-(NSMutableDictionary*) findContent:(ABRecordRef) thisPerson;
-(NSData*) findDataImageByRef:(id) key;
-(NSData*) findDataImage1ByRef:(id) key;
-(NSData*) findDataImage2ByRef:(id) key;
@end
