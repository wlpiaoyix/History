//
//  ShareUtils.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "ShareUtils.h"
#import "UMSocial.h"
#import "UMSocialYixinHandler.h"

@implementation ShareUtils

+(NSArray *)getSharePlatforms{

    if (IOS_Version_Compare(@"6.0")) {
        return [NSArray arrayWithObjects:UMShareToYXSession,UMShareToYXTimeline,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,nil];
    }
    return  [NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToSina,nil];
}

+(NSString *)getShareTypeString:(int)type Url:(NSString *)url Title:(NSString *)title{
     
    NSString * retstr;
    if (IOS_Version_Compare(@"6.0")) {
        //设置易信Appkey和分享url地址,注意需要引用头文件 #import UMSocialYixinHandler.h
        [UMSocialYixinHandler setYixinAppKey:@"yx27b039ae3eed4e5d9f664b9499ba15be" url:url];
    } 
   
    switch (type) {
        case 0:
            retstr =  @"我正在使用“易销邦”管理我的销售数据。";// stringByAppendingString:url];
            retstr = [retstr stringByAppendingString:url];
           [UMSocialData defaultData].extConfig.yxtimelineData.yxMessageType  = UMSocialYXMessageTypeImage;
            [UMSocialData defaultData].extConfig.yxsessionData.yxMessageType  = UMSocialYXMessageTypeImage;
            //UMSocialWXMessageTypeImage 为纯图片类型
            [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
            break;
        case 1:
            [UMSocialData defaultData].extConfig.yxtimelineData.yxMessageType  = UMSocialYXMessageTypeWeb;
             [UMSocialData defaultData].extConfig.yxsessionData.yxMessageType  = UMSocialYXMessageTypeWeb;
          
           [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
            retstr = title;
        default:
            break;
    }
    
        //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
       [UMSocialData defaultData].extConfig.title = title;
       [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
       [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    return retstr;
}
@end
