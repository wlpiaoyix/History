//
//  UIBaseButtomShowViewConfigure.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 12/13/13.
//  Copyright (c) 2013 AKSL. All rights reserved.
//

#import "UIBaseButtomShowViewConfigure.h"

static NSLock *UIBASEBUTTOMSHOWVIEW_LOCK;//同步锁，每次执行时要保证只有一个在进行中
static CGColorRef UIBASEBUTTOMSHOWVIEW_BORDERCOLOR;//边框颜色
static UIColor *UIBASEBUTTOMSHOWVIEW_BACKGROUNDCOLORLABLE;//背景颜色
static float UIBASEBUTTOMSHOWVIEW_TEXTSIZE;//字体大小
static float UIBASEBUTTOMSHOWVIEW_LABLEAQUE;//透明度
@implementation UIBaseButtomShowViewConfigure
+(void) initialize{
    UIBASEBUTTOMSHOWVIEW_LOCK = [[NSLock alloc]init];
    UIBASEBUTTOMSHOWVIEW_BORDERCOLOR = [UIColor colorWithRed:0.392 green:0.392 blue:0.392 alpha:1].CGColor;
    UIBASEBUTTOMSHOWVIEW_BACKGROUNDCOLORLABLE = [UIColor colorWithRed:0.525 green:0.718 blue:0.086 alpha:1];
    UIBASEBUTTOMSHOWVIEW_TEXTSIZE = 14.0f;
    UIBASEBUTTOMSHOWVIEW_LABLEAQUE = 0.9f;
}
+(NSLock*) getLock{
    return UIBASEBUTTOMSHOWVIEW_LOCK;
}
+(CGColorRef)  getBorderColor{
    return UIBASEBUTTOMSHOWVIEW_BORDERCOLOR;
}
+(UIColor*) getBackGroundColor{
    return UIBASEBUTTOMSHOWVIEW_BACKGROUNDCOLORLABLE;
}
+(float) getTextSize{
    return UIBASEBUTTOMSHOWVIEW_TEXTSIZE;
}
+(float) getLableAque{
    return UIBASEBUTTOMSHOWVIEW_LABLEAQUE;
}
@end
