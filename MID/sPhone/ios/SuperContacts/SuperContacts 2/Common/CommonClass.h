//
//  CommonClass.h
//  ST-ME
//
//  Created by wlpiaoyi on 12/16/13.
//  Copyright (c) 2013 wlpiaoyi. All rights reserved.
//
#import <Foundation/Foundation.h>
@interface CommonClass : NSObject
/**
 当前手机号
 */
+(NSString*) getCurrentPhoneNum;
+(NSString*) CC_getHttpUrl:(NSString*) url;
+(NSString*) CC_getFileUrl:(NSString*) url;
/**
 系统版本
 */
+(bool) IOSVersionCheck:(int) version;
/**
初始化ViewController
 */
+(id) CC_addRootController:(UINavigationController*) navnext topHeight:(float) topHeight;
/**
 系统背景颜色
 */
+(UIColor*) getCOMMONCLASSAPPBGCOLOR;
/**
 打电话
 */
+(void) callTelprompt:(NSString*) phoneNun;
/**
 提示信息
 */
+(void)showMessage:(NSString*) message Title:(NSString*) title Delegate:(id<UIAlertViewDelegate>) delegate;
+(void)showMessage:(NSString*) title Delegate:(id<UIAlertViewDelegate>) delegate Messages:(NSString*) message,...;
+(void)showSheet:(NSString*) title TargetView:(UIView*) targetView Delegate:(id<UIActionSheetDelegate>) delegate ButtonNames:(NSString*) buttonNames,...;
/**
 所有的联系人
 */
+(NSMutableArray*) allAddressBookRecords;
/**
 刷新所有的联系人
 */
+(void) refreshAllAddressBookRecords;
/**
 当前数据库操作对象
 */
+(id) getCurrentEntityManager;
+(id) getCurrentEntityManagerAddressBook;
+(NSString*) getLocationPhoneNumber;
+(id) getCOMMONFDBS;
+(id) getCOMMONFLCS;
+(bool) ifLongScreen;
/**
 得到所有的简拼
 */
+(NSArray*) checkShortPingYing;
/**
 对比可能会用的简拼
 */
+(NSArray*) checkNumToPingYingForArray:(char*) numChar;
+(NSString*) chooseNumberStr:(NSString*) str;
/**
 将指定的图片切成适合手机屏幕大小显示
 */
+(UIImage*) cutSizeForScrren:(UIImage*) image;

@end
