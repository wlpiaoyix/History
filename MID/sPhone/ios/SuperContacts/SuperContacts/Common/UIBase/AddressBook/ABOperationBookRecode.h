//
//  ABOperationBookRecode.h
//  ST-ME
//
//  Created by wlpiaoyi on 13-12-25.
//  Copyright (c) 2013年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
/**
 @autor:wlpioayi
 */
@interface ABOperationBookRecode : NSObject
/**
 得到所有的通信录
 */
-(NSArray*) getALLBookRecode;
/**
 根据姓名查找出对应的通信录
 */
-(NSArray*) getBookRecodeByName:(NSString*) searchName;
/**
 修改通信记录第一级信息
 */
-(bool) setRecodeValue:(ABRecordRef) thisPerson PropertyID:(ABPropertyID) propertyID PropertyValue:(NSString*) propertyValue IfCommite:(bool) ifCommite;
/**
 修改、新增单条子项通信数据，不建议将些方法用于批量更新
 因为group类型的数据都是全部更新的，每修改某一条都会全部更新
 */
-(bool) setGroupPhoneValue:(ABRecordRef) thisPerson PhoneValue:(NSString*) phoneValue PhoneStringRef:(CFStringRef) phoneStringRef IfCommite:(bool) ifCommite;
/**
 提交数据
 */
-(bool) commiteBookRecode:(ABRecordRef) thisPerson;
@end
