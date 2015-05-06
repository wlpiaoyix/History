//
//  EntityManagerAddressBook.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-6.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityUser.h"

@interface EntityManagerAddressBook : NSObject
@property (strong, nonatomic) NSMutableArray *pys;
/**
 保存通信录
 */
-(EntityUser*) merge:(EntityUser*) entity;
/**
 新增通信录
 */
-(EntityUser*) persist:(EntityUser*) entity;
/**
 删除通信录
 */
-(bool) remove:(EntityUser*) entity;
/**
 得到当前通信录
 */
-(EntityUser*) findByName:(NSString*) userName;
/**
 得到当前通信录
 */
-(EntityUser*) findByPhone:(NSString*) phone;
-(void) refreshContents;
/**
 查询出所有的记录
 */
-(NSMutableArray*) queryContentsByParams:(NSString*) params;
/**
 查询出所有的记录
 */
-(NSMutableArray*) queryContentsByPhone:(NSString *) phone Flag:(bool) flag;
/**
 查询出所有的记录
 */
-(NSMutableArray*) queryContentsByName:(NSString*) name;
/**
 得到可以用于显示头像的图片
 */
-(UIImage*) findImageHeadByRef:(id) key;
/**
 得到可以用于显示背景的图片
 */
-(UIImage*) findImageBgByRef:(id) key;
@end
