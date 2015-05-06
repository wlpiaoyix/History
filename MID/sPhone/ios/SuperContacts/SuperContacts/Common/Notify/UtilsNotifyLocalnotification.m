//
//  UtilsNotifyLocalnotification.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-10-29.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//
static NSDictionary *DicUtilsNotifyLocalnotifications;
static NSDictionary *NsNotifyLocalnotifications;
#import "UtilsNotifyLocalnotification.h"
@interface UtilsNotifyLocalnotification(){
}
@property bool ifOnceNotify;//是否只执行一次

@end
@implementation UtilsNotifyLocalnotification
-(UtilsNotifyLocalnotification*) eventSet:(CallBackeMethod)didDo{
    _didDo = didDo;
    return self;
}
-(UtilsNotifyLocalnotification*) setIfOnceNotifys:(bool) ifOnceNotifys{
    self.ifOnceNotify = ifOnceNotifys;
    return self;
}
-(void) checkAndDoEvent:(id) data{
    UILocalNotification *notification = (UILocalNotification*)data;
    NSString *_title_ = notification.alertAction;
    NSString *_msg_ = notification.alertBody;
    UIAlertView *uv = [[UIAlertView alloc]
                       initWithTitle:_title_ message:_msg_ delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
    [uv show];
    [NsNotifyLocalnotifications setValue:notification forKey:[NSString stringWithFormat:@"%lu",(unsigned long)uv.hash]];
}
+(void) eventAdd:(id) key Value:(UtilsNotifyLocalnotification*) value{
    @synchronized (DicUtilsNotifyLocalnotifications){
        if(!DicUtilsNotifyLocalnotifications){
            DicUtilsNotifyLocalnotifications = [[NSMutableDictionary alloc]init];
        }
        [DicUtilsNotifyLocalnotifications setValue:value forKey:key];
    }
}
+(void) eventDo:(id) key Data:(id) data{
    UtilsNotifyLocalnotification *unfl = [DicUtilsNotifyLocalnotifications objectForKey:key];
    [unfl checkAndDoEvent:data];
}
+(void) eventDelet:(id) key{
    [DicUtilsNotifyLocalnotifications delete:key];
}
+(void) initDicUtilsNotifyLocalnotifications{
    DicUtilsNotifyLocalnotifications = [[NSMutableDictionary alloc]init];
}
+(void) initNsNotifyLocalnotifications{
    NsNotifyLocalnotifications = [[NSMutableDictionary alloc]init];
} 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //==>找出对应的提醒计划
    NSString *key1 = [NSString stringWithFormat:@"%d",alertView.hash];
    UILocalNotification *notify = [NsNotifyLocalnotifications objectForKey:key1];
    //<==
    //==>提醒计划对应的操作如果有
    NSString *key2 = [notify.userInfo objectForKey:@"key"];
    if(_didDo){
        switch (buttonIndex) {
            case 0:
                _didDo(notify.userInfo);
                //删除对应的日程提醒
                [NsNotifyLocalnotifications setValue:false forKey:key1];
                if([NSString isEnabled:key2])[DicUtilsNotifyLocalnotifications setValue:false forKey:key2];
                break;
            default:
                break;
        }
    }
    //<==
}
@end
