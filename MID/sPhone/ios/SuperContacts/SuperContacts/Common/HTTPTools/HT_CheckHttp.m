//
//  HT_CheckHttp.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-3-2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "HT_CheckHttp.h"
#import "LoginController.h"
#import "CTM_MainController.h"
#import "MMDrawerController.h"
#import "Reachability.h"
@implementation HT_CheckHttp{
@private
    Reachability *hostReach;
    HCH_CallBackeMethod methodResultx;
}
+(bool) checkLogStatus{
    NSString *code = (NSString*)[ConfigManage getConfigPublic:COMMON_KEY_AT];//@"10000101";//
    NSString *password = (NSString*)[ConfigManage getConfigPublic:COMMON_KEY_PW];//@"wewq";//
    if(![NSString isEnabled:code]||![NSString isEnabled:password]){
        COMMON_SHOWALERT(@"请先登录您的帐号才能访问数据!");
        LoginController *lc = [LoginController getNewInstance];
        id controller = [HT_CheckHttp getCurrentRootViewController];
        if([controller isKindOfClass:[UIViewController class]]){
            [((UIViewController*) controller).navigationController pushViewController:lc animated:YES];
        }
        return false;
    }
    return true;
}
-(void) checkOnLine:(NSString*) urlPath methodResult:(HCH_CallBackeMethod) methodResult{
    if(![NSString isEnabled:urlPath]){
        urlPath =  COMMON_HTTP_BASE_URL;//[NSString stringWithFormat:@"%@:%d%@%@",COMMON_HTTP_BASE_URL,COMMON_APP_API_PORT,COMMON_HTTP_URL_SUFFIX,@"/regist/ping"];
    }
    methodResultx = methodResult;
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityConnection:) name:kReachabilityChangedNotification object:nil];
    hostReach = [Reachability reachabilityWithHostName:urlPath] ;
    [hostReach startNotifier];  //开始监听,会启动一个run loop
    
}

+ (UIViewController *)getCurrentRootViewController {
    UIViewController *result;
    // Try to find the root view controller programmically
    // Find the top window (that is not an alert view or other window)
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = [HT_CheckHttp getCurrentController:nextResponder];
        NSArray *viewControllers;
        if([result isKindOfClass:[UINavigationController class]]){
            viewControllers = ((UINavigationController*)result).viewControllers;
        }else{
            viewControllers = result.navigationController.viewControllers;
        }
        for (UIViewController *viewController in viewControllers){
            result = viewController;
        }
        if([result isKindOfClass:[MMDrawerController class]]){
            result = ((MMDrawerController*)result).centerViewController;
            viewControllers = ((UINavigationController*)result).viewControllers;
            for (UIViewController *viewController in viewControllers){
                result = viewController;
            }
        }
        result = [HT_CheckHttp getLastController:result];
        return result;
    }
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    return result;    
}
+(UIViewController*) getCurrentController:(UIViewController*) cl{
    id nextResponder = [cl nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        if (nextResponder) {
            return [self getCurrentController:cl];
        }else{
            return nextResponder;
        }
    }
    return cl;
}
+(UIViewController*) getLastController:(UIViewController*) cl{
    NSArray *controllers = cl.navigationController.viewControllers;
    UIViewController *clx = nil;
    for (UIViewController *_cl in controllers) {
        clx = _cl;
    }
    if([clx hash]==[cl hash]){
        return cl;
    }
    if(clx){
        clx =[HT_CheckHttp getLastController:clx];
    }
    return cl;
}
//网络链接改变时会调用的方法
-(void)reachabilityConnection:(NSNotification *)note
{
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    if(self->methodResultx){
        methodResultx(status);
    }else{
        switch (status) {
            case NotReachable:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:@"暂无法访问网络信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
                break;
            case kReachableViaWiFi:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接正常" message:@"将在WIFI环境下访问网络信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
                break;
            case kReachableViaWWAN:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接正常" message:@"将在2G/3G/4G环境下访问网络信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            default:
                break;
        }
    }
}

@end
