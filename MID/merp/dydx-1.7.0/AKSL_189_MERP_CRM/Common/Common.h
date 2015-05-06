//
//  Common.h
//  Anbaby－V2.0.0
//
//  Created by AKSL-td on 13-9-24.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

typedef id (^CallBakeMethod)(id key,...);

#ifndef Anbaby_V2_0_0_Common_h
#define Anbaby_V2_0_0_Common_h

#define APP_NAME_AND_RES @"yxs-1.7.0"

#import "ConfigManage.h"
//#import "UtilsNotifyLocalnotification.h"
#define BAIDU_AK @"13a8e69b95517ff6e09a69b91130db8b"
//Data Dictionary
#define STR_USER_NAME @"UserName"
#define STR_USER_ID @"UserId"
#define STR_XMPP_USER_ID @"UserJid"
#define STR_USER_PASSWORD @"Password"

//HTTP CALL API
//==>必传参数
#define HTTP_API_PCODE @"code"
#define HTTP_API_PAK @"ak"
#define HTTP_API_PLOGO @"log"
#define HTTP_API_JSON_PERSONINFO @"PERSONINFO"//个人信息key值
#define HTTP_API_JSON_ROLEINFOS @"ROLEINFOS"//角色信息key值
//<==
#define HTTP_API_PPath @"path"
//==>传输方法
#define HTTP_API_GET @"GET"
#define HTTP_API_POST @"POST"
#define HTTP_API_PUT @"PUT"
#define HTTP_API_DELETE @"DELETE"
//<==
#define HTTP_API_CALL(_URL_,_PARAMS_,_METHOD_) [HttpApiCall requestCall:_URL_ Params:_PARAMS_ Method:_METHOD_]
#define HTTP_API_HashSHA [[HashSHA256 alloc]init]

#define TITLE_APP_EN @"dydx"
#define TEST_SERVER 0
//HTTP HOST API
#if TEST_SERVER
//#define HTTP_BASE_URL @"http://merp.inf.aksl.com.cn"
#define HTTP_BASE_URL @"http://10.10.10.16"
#define APP_API_PORT 8023
#else
#define HTTP_BASE_URL @"http://dydx.merp.aksl.com.cn"//@"http://dydx.merp.aksl.com.cn"
#define APP_API_PORT 8023 // MSDX 7775  CDDX 7773  NJDX   DYDX 8023 MYDX 7778 DZDX 7776
#endif
#define HTTP_FILE_URL HTTP_BASE_URL//@"http://cddx.merp.aksl.com.cn"
#define APP_FILE_PORT APP_API_PORT//7773
#define API_BASE_URL(_URL_) [NSString stringWithFormat:@"%@:%d%@",HTTP_BASE_URL,APP_API_PORT,_URL_]
#define API_FILE_URL(_URL_) [NSString stringWithFormat:@"%@:%d%@",HTTP_FILE_URL,APP_FILE_PORT,_URL_]
#define SCREEN_WIDTH      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define SCREEN_HEIGHT    CGRectGetHeight([UIScreen mainScreen].applicationFrame)
//XMPP
#define APP_XMPP_PORT 5222
#define APP_XMPP_NOTIFACTION_MESSAGE @"AKSL-IT-NewXmppMessageNotifaction"

//FMDB
#define FMDBQuickCheck(SomeBool) {if(!(SomeBool)){NSLog(@"Failure on line %d", __LINE__);abort();}}
#define DATABASE_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]stringByAppendingString:@"/anbabydata.db"]

#define didStartDoIt(_key_,_data_) [UtilsNotifyLocalnotification eventDo:_key_ Data:_data_];
//UI
#define showMessageBox(_msg_) [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:_msg_ delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
#define showAlertBox(_title_,_msg_) [[[UIAlertView alloc] initWithTitle:_title_ message:_msg_ delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
//CONST

#define IOS7_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS_Version_Compare(_Version_)    ( [[[UIDevice currentDevice] systemVersion] compare:_Version_] !=  NSOrderedAscending )

#define API_IMAGE_URL_GET(_USERCODE_,_IMAGENAME_) [NSString stringWithFormat:@"%@:%d/images/%@/%@",HTTP_FILE_URL,APP_FILE_PORT,_USERCODE_,_IMAGENAME_]
#define API_IMAGE_URL_GET2(_TAILARG_) [[NSString stringWithFormat:@"%@:%d/images/%@",HTTP_FILE_URL,APP_FILE_PORT,_TAILARG_]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
#define CHECK_NULL_ENABLED(_TARGET_) (_TARGET_&&_TARGET_!=nil&&![[NSNull null] isEqual:_TARGET_])

#define DISTRICT_INFO_KEY @"DISTRICT_INFO_KEY"
#define PRODUCTS_INFO_KEY @"PRODUCTS_INFO_KEY"
#define STORETYPE_INFO_KEY @"STORETYPE_INFO_KEY"
#define STORETYPE_INFO_SELECT_KEY @"STORETYPE_INFO_SELECT_KEY"
#define PRODUCTS_INFO_SELECT_KEY @"PRODUCTS_INFO_SELECT_KEY"
#define DISTRICT_INFO_SELECT_KEY @"DISTRICT_INFO_SELECT_KEY"
#define DATE_SELECT_KEY @"DATE_SELECT_KEY"
#import "LoginUser.h"
#import "Organization.h"
#import "NSString+Convenience.h"

//UM
#define UMENG_APPKEY @"529c11fc56240b57391c0d2e"
#define UMENG_APPKEY_ZYDX @"5366f36a56240b4bfc035568"
#define UMENG_APPKEY_NJDX @"5366f35556240b4c05033fdc"
#define UMENG_APPKEY_MSDX @"536c7ab456240b0a6e061a46"
#define UMENG_APPKEY_CDDX @"537acdde56240b9bf3002822"
#define UMENG_APPKEY_MYDX @"53993f9f56240be89e000d4f"
#define UMENG_APPKEY_DZDX @"5399663a56240b396401b3a4"

//base msg for web status
#define WEB_BASE_MSG_NODATA @"没有数据！"
#define WEB_BASE_MSG_REQUESTOUTTIME @"请求超时，请确认你的手机已联网！"
#define WEB_BASE_MSG_SYSTEMERROR @"系统错误！请重新提交数据。"
#define WEB_BASE_MSG_PASSWORDERROR @"用户名或密码错误！"

//System Version Number
#define SYSTEM_VERSION_NUMBER @"1.7.0"

//屏幕宽度
#define COMMON_SCREEN_W  CGRectGetWidth([UIScreen mainScreen].applicationFrame)
//屏幕长度
#define COMMON_SCREEN_H  CGRectGetHeight([UIScreen mainScreen].applicationFrame)
#define PI 3.14159265358979323846

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
#endif
