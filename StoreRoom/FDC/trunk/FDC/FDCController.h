//
//  FDCController.h
//  FDC
//
//  Created by wlpiaoyi on 15/1/14.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <CommonSDK/CommonSDK.h>
extern NSString *const URL_BASE_DATA;

@interface FDCController : BaseController
/**
 项目选择
 */
-(UIBarButtonItem*) createButtonItemSelecteObject:(SEL) action;
/**
 注销
 */
-(UIBarButtonItem*) createButtonItemLogout:(SEL) action;
/**
 退出
 */
-(UIBarButtonItem*) createButtonItemBack:(SEL) actio;
@end
