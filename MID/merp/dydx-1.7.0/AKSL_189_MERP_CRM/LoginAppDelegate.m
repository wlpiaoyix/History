//
//  LoginAppDelegate.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-18.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "LoginAppDelegate.h"
#import "LoginViewController.h"
#import "LaunchViewController.h"
#import "UtilsNotifyLocalnotification.h"
#import "MobClick.h"
#import "UMSocial.h"
#import "UMSocialYixinHandler.h"
#import "UMSocialWechatHandler.h"
#import "InspectStoreMainPage.h"
#import "NewInspectCameraPage.h"
#import "BPush.h"
#import "HttpApiCall.h"
#import "LeftMenuViewController.h"
#import "MainPageViewController.h"
#import "CompulsoryUpdateController.h"

@interface LoginAppDelegate()
@property NSDictionary *datas;
@end
@implementation LoginAppDelegate

-(void)baiduPush:(NSDictionary *)data{
    [BPush setupChannel:data];
    [BPush setDelegate:self];
    //[BPush setAccessToken:@"18990289797"];
    //[BPush bindChannel];
}
- (void) onMethod:(NSString*)method response:(NSDictionary*)data
{
    if ([BPushRequestMethod_Bind isEqualToString:method])
    {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
         NSString *userid = [res valueForKey:BPushRequestUserIdKey];
         NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
         int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
         NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
       // NSString * mes = [NSString stringWithFormat:@"%@,%@,%@,%@,%d",userid,channelid,appid,requestid,returnCode];
        //api/user/bccs/{pushUserId}/{pushChannelId}/{clientType}
        NSLog(@"%@,%@,%@,%@,%d",userid,channelid,appid,requestid,returnCode);
        LoginUser * user = [ConfigManage getLoginUser];
        // showMessageBox(userID);
        if (userid&&channelid&&user) {
            NSString * dataUser =[NSString stringWithFormat:@"{\"pushUserId\":\"%@\",\"pushChannelId\":\"%@\",\"clientType\":\"ios\"}",userid,channelid];
            NSString * url =  [NSString stringWithFormat:@"/api/user/bccs/%@/%@/ios",userid,channelid];
            ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:url Params:[dataUser JSONValue] Logo:@"set_push_data"];
            __weak ASIFormDataRequest *request = requestx;
            [request setCompletionBlock:^{
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *reArg = [request responseString];
                NSLog(@"%@",reArg);
            }];
            [request startAsynchronous];
            
        }

    }
}

- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    NSString * key;
    if ([@"dxdx" isEqualToString:TITLE_APP_EN]) {
        key = UMENG_APPKEY;
    }
    if ([@"zydx" isEqualToString:TITLE_APP_EN]) {
        key = UMENG_APPKEY_ZYDX;
    }
    if ([@"njdx" isEqualToString:TITLE_APP_EN]) {
        key = UMENG_APPKEY_NJDX;
    }
    if ([@"msdx" isEqualToString:TITLE_APP_EN]) {
        key = UMENG_APPKEY_MSDX;
    }
    if ([@"cddx" isEqualToString:TITLE_APP_EN]) {
        key = UMENG_APPKEY_CDDX;
    }
    if ([@"mydx" isEqualToString:TITLE_APP_EN]) {
        key = UMENG_APPKEY_MYDX;
    }
    [MobClick startWithAppkey:key reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
     
    [UMSocialData setAppKey:UMENG_APPKEY];
    
    //设置微信AppId，url地址传nil，将默认使用友盟的网址
    //wxd930ea5d5a258f4f
    [UMSocialWechatHandler setWXAppId:@"wx7538612aa439adcd" url:[NSString stringWithFormat:@"http://aksl.net/%@",TITLE_APP_EN]];
   // [UMSocialConfig setWXAppId:@"wx7538612aa439adcd" url:[NSString stringWithFormat:@"http://aksl.net/%@",TITLE_APP_EN]];
    
    //打开新浪微博的SSO开关
    [UMSocialConfig setSupportSinaSSO:YES];
    
}
- (void)onlineConfigCallBack:(NSNotification *)note {
    
    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self umengTrack]; 
    [self baiduPush:launchOptions];
     
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    // Override point for customization after application launch.
    UIViewController * viewController ;
    NSString *start = [ConfigManage getConfig:APP_NAME_AND_RES];
    if (start) {
        viewController= [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    }else{
    viewController= [[LaunchViewController alloc]initWithNibName:@"LaunchViewController" bundle:nil];
    }
    UINavigationController * nav= [[UINavigationController alloc]initWithRootViewController:viewController];
    nav.navigationBarHidden = YES;
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor colorWithRed:0.518 green:0.714 blue:0.078 alpha:1];
    [self.window makeKeyAndVisible];
    [MobClick beginEvent:@"app_start"];
    [application setApplicationIconBadgeNumber:0];
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];
     return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MobClick endEvent:@"app_start"];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    [BPush handleNotification:userInfo];
    NSLog(@"didReceiveRemoteNotification====================");
    //NSDictionary * temp = [userInfo valueForKey:@"aps"];
    NSString * type = [userInfo valueForKey:@"type"];
    if (!type||type.length==0){
        return;
    }
    type = [type stringByAppendingString:@"-Notification"];
    int badge = [[ConfigManage getConfig:type]intValue];
    badge++;
    [ConfigManage setConfig:type Value:[NSString stringWithFormat:@"%d",badge]];
    
    if ([type isEqualToString:@"update-Notification"]) {
        NSString *version = [userInfo objectForKey:@"appVersionName"];
        if([NSString isEnabled:version] && ![version isEqualToString:SYSTEM_VERSION_NUMBER]){
            NSArray *tempx1 = [version componentsSeparatedByString:@"."];
            NSArray *tempx2 = [SYSTEM_VERSION_NUMBER componentsSeparatedByString:@"."];
            int speca = 0;
            int specatemp = 10000;
            for(int i=0;i<[tempx1 count];i++){
                specatemp /= 10;
                int tempx3 = [((NSString*)tempx1[i]) intValue];
                int tempx4 = [tempx2[i] intValue];
                if(tempx3>tempx4){
                    speca += specatemp;
                    break;
                }else if(tempx3==tempx4){
                    continue;
                }else{
                    return;
                }
            }
            NSString *tempx = [NSString stringWithFormat:@"版本更新:%@",[userInfo objectForKey:@"content"]];
            NSMutableDictionary * newtemp = [[NSMutableDictionary alloc]initWithDictionary:userInfo];
            [newtemp setValue:[NSNumber numberWithInt:speca] forKey:@"updateType"];
            [newtemp setValue:version forKey:@"version"];
             [ConfigManage setConfig:@"update-Notification-Dic" Value:newtemp];
                    CompulsoryUpdateController * view = [[CompulsoryUpdateController alloc]initWithNibName:@"CompulsoryUpdateController" bundle:nil];
                view.noteString = tempx;
                view.updateType = speca;
        [self.window.rootViewController presentModalViewController:view animated:YES];
              //  [self.mm_drawerController presentModalViewController:view animated:YES];
        }
    
    }}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSString *key = [notification.userInfo objectForKey:@"key"];
    didStartDoIt(key, notification);
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

@end
