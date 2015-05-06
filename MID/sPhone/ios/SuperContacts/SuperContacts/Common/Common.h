//
//  Common.h
//  Anbaby－V2.0.0
//
//  Created by AKSL-td on 13-9-24.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

typedef id (^CallBackeMethod)(id key,...);
#ifndef STME_V2_0_0_Common_h
#define STME_V2_0_0_Common_h

#import "ConfigManage.h"
#import "CommonClass.h"
#define COMMON_BAIDU_AK @"13a8e69b95517ff6e09a69b91130db8b"//百度开发都序列号
#define COMMON_DATABASE_NAME @"database01.db"//数据库名称
#define COMMON_KEY_AT @"account"
#define COMMON_KEY_PW @"password"
#define COMMON_KEY_TEMP @"cmkTemp"
#define COMMON_KEY_PU @"public"
//==>传输方法
#define COMMON_HTTP_API_GET @"GET"
#define COMMON_HTTP_API_POST @"POST"
#define COMMON_HTTP_API_PUT @"PUT"
#define COMMON_HTTP_API_DELETE @"DELETE"
//<==
//==>HTTP HOST API
#define COMMON_HTTP_URL_SUFFIX @"/sp/api"//@"/api"//
#define COMMON_HTTP_BASE_URL  @"merp.inf.aksl.com.cn"//@"10.10.10.55"//
#define COMMON_APP_API_PORT 8023//3386//
#define COMMON_HTTP_FILE_URL @"merp.inf.aksl.com.cn"//@"10.10.10.79"//
#define COMMON_APP_FILE_PORT 8023//
#define COMMON_GET_BASE_URL(_url_) [CommonClass CC_getHttpUrl:_url_]
#define COMMON_GET_FILE_URL(_url_) [CommonClass CC_getFileUrl:_url_]
#define COMMON_GET_IMAGE_URL(_url_) [NSString stringWithFormat:@"http://%@:%d/images/%@",COMMON_HTTP_FILE_URL,COMMON_APP_FILE_PORT,_url_]
//<==
//==>base msg for web status
#define COMMON_WEB_BASE_MSG_NODATA @"没有数据！"
#define COMMON_WEB_BASE_MSG_REQUESTOUTTIME @"请求超时，请确认你的手机已联网！"
#define COMMON_WEB_BASE_MSG_SYSTEMERROR @"系统错误！"
//<==
//==>System Version Number Check
#define IOS7_OR_LATER    [CommonClass IOSVersionCheck:7]?true:false
#define IOS6_OR_LATER    [CommonClass IOSVersionCheck:6]?true:false
//<==
#define COMMON_SCREEN_LONG_FLAG [CommonClass ifLongScreen]
#define COMMON_ADDROOTCONTROLLER(_rootController_)  [CommonClass CC_addRootController:_rootController_ topHeight:-1.0f]
#define COMMON_SYSTEM_BGCOLOR [CommonClass getCOMMONCLASSAPPBGCOLOR]
//System Version Number
#define COMMON_SYSTEM_VERSION_NUMBER @"1.0.0"
#define COMMON_SCREEN_W      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define COMMON_SCREEN_H     CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#define COMMON_CHOOSENUM(_STR_) [CommonClass chooseNumberStr:_STR_];;
/**
 弹出框
 */

#define COMMON_SHOWALERT(_message_) [CommonClass showMessage:_message_ Title:@"温馨提示" Delegate:nil];
#define COMMON_SHOWMSG(_title_,_message_) [CommonClass showMessage:_message_ Title:_title_ Delegate:nil];
#define COMMON_SHOWMSGDELEGATE(_title_,_delegate_,_message_...)[CommonClass showMessage:_title_ Delegate:_delegate_ Messages:_message_,nil];
#define COMMON_SHOWSHEET(_title_,_targetView_,_delegat_,_buttonNames_...)[CommonClass showSheet:_title_ TargetView:_targetView_ Delegate:_delegat_ ButtonNames:_buttonNames_,nil];
//打电话
#define COMMON_CALL(_phoneNum_)  [CommonClass callTelprompt:_phoneNum_];
//所有的联系人
//#define COMMON_ADDRESSBOOKARRAY [CommonClass allAddressBookRecords];
#define COMMON_REFRESH_ADDRESSBOOKARRAY [CommonClass refreshAllAddressBookRecords];
//数据库对象
#define COMMON_EM [CommonClass getCurrentEntityManager];
//数据库对象
#define COMMON_EMAB [CommonClass getCurrentEntityManagerAddressBook];
//get service bean
#define COMMON_FDBS [CommonClass getCOMMONFDBS];
#define COMMON_FLCS [CommonClass getCOMMONFLCS];
#define COMMON_CHECKSHORTPY [CommonClass checkShortPingYing];
#define COMMON_CHECKNUMTOPYFORARRAY(_array_) [CommonClass checkNumToPingYingForArray:_array_];
//将指定的图片切成适合手机屏幕大小显示
#define COMMON_CUTIMG(_image_) [CommonClass cutSizeForScrren:_image_]
/*
 预定义__GNUC__宏
 1 __GNUC__ 是gcc编译器编译代码时预定义的一个宏。需要针对gcc编写代码时， 可以使用该宏进行条件编译。
 2 __GNUC__ 的值表示gcc的版本。需要针对gcc特定版本编写代码时，也可以使用该宏进行条件编译。
 
 3 __GNUC__ 的类型是“int”，该宏被扩展后， 得到的是整数字面值。可以通过仅预处理，查看宏扩展后的文本。
 */
/* Definition of `CG_FLOAT_PARAM'. */
#if !defined(CG_FLOAT_PARAM)
    # if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
        #  define CG_FLOAT_PARAM static inline
    # elif defined(__cplusplus)
        #  define CG_FLOAT_PARAM static inline
    # elif defined(__GNUC__)
        #  define CG_FLOAT_PARAM static __inline__
    # else
        #  define CG_FLOAT_PARAM static
    # endif
# endif
struct PXMSZoomOpt {
    float w;
    float h;
    float n;
};
typedef struct PXMSZoomOpt PXMSZoomOpt;
CG_FLOAT_PARAM PXMSZoomOpt
PXMSZoomOptMake(float w, float h, float n)
{
    PXMSZoomOpt opt;
    opt.w = w;
    opt.h = h;
    opt.n = n;
    return opt;
}
CG_FLOAT_PARAM PXMSZoomOpt
PXMSZoomOptMakeN(float n)
{
    PXMSZoomOpt opt = PXMSZoomOptMake(COMMON_SCREEN_W,COMMON_SCREEN_H,n);
    return opt;
}
//==>Cache key
#define CMCK_PCODE @"code"
#define CMCK_PAK @"ak"
#define CMCK_PLOGO @"log"
#define CMCK_ACCONTINFO @"accont infomation"
#define CMCK_ACCONTINFOCACHA @"accont cache infomation"
#define CMCK_LOCATIONPHONENUM [CommonClass getCurrentPhoneNum]
//<==

#import "JSON.h"
#import "NSDate+convenience.h"
#import "NSMutableArray+convenience.h"
#import "UIColor+expanded.h"
#import "UIImage+Convenience.h"
#import "UIView+convenience.h"
#import "NSString+Convenience.h"

#endif
