//
//  UserManager.m
//  FDC
//
//  Created by wlpiaoyi on 15/1/16.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "UserManager.h"
#import "ConfigManage+Expand.h"
#import "CustomerMainManager.h"
#import "AdminManager.h"
@implementation UserManager
-(void) loginWithUserName:(NSString*) userName password:(NSString*) password success:(CallBackHttpUtilRequest) success faild:(CallBackHttpUtilRequest) faild{
    
    LoginUserName =  userName;
    LoginUserPassoword = password;
    id<HttpUtilRequestDelegate> hur = [self createRequestWith:@"CheckLoginUserInfo"];
    [hur setUserInfo:@{@"success":success,@"faild":faild}];
    [hur setSuccessCallBack:^(id data, NSDictionary *userInfo) {
        id result = [self checkData:data];
        CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
        if (success) {
            [ConfigManage setConfigValueByUser:result Key:[self getKeyConfiger:@"CheckLoginUserInfo"]];
            UserEntity *user = [UserEntity instanceWithJson:result];
            [ConfigManage setLoginUser:user];
            success(result,nil);
            if (result) {
                CustomerMainManager *cm = [CustomerMainManager new];
                [cm birthDayForCustomerWithObjectId:nil success:^(id data, NSDictionary *userInfo) {
                    
                } faild:^(id data, NSDictionary *userInfo) {
                    
                }];
                AdminManager *am = [AdminManager new];
                [am queryManagerMainInfoWithObjectId:@"XMA0000001" startTime:@"2012-01-10" endTime:@"2015-03-02" success:^(id data, NSDictionary *userInfo) {
                    
                } faild:^(id data, NSDictionary *userInfo) {
                    
                }];
            }
        }
    }];
    [hur setFaildCallBack:^(id data, NSDictionary *userInfo) {
        id result = [ConfigManage getConfigValueByUser:[self getKeyConfiger:@"CheckLoginUserInfo"]];
        if (result) {
            CallBackHttpUtilRequest success = [userInfo objectForKey:@"success"];
            if (success) {
                UserEntity *user = [UserEntity instanceWithJson:result];
                [ConfigManage setLoginUser:user];
                success(result,nil);
            }
            return;
        }
        
        CallBackHttpUtilRequest faild = [userInfo objectForKey:@"faild"];
        if (faild) {
            faild(data,nil);
        }
    }];
    [hur requestGET:[ConfigManage getLoginUser]?@{}:@{@"UserName":userName,@"UserPwd":password}];
}

@end
