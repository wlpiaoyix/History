//
//  LoginUser.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-19.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "LoginUser.h"


@implementation LoginUser


+(LoginUser *)getLoginUserFromJson:(NSString *)json{

    if (!json||[json isEqualToString:@""]) {
        return nil;
    }
    NSDictionary *temp = [json JSONValueNewMy];
    return [self getLoginUserFromDic:temp];
}
+(LoginUser *)getLoginUserFromDic:(NSDictionary *)temp{
    LoginUser * user = [LoginUser new];
   
        user.rankString = [NSString stringWithFormat:@"%@/%@",[temp objectForKey:@"rank"],[temp objectForKey:@"userNum"]];
    user.progressFloat = [[temp objectForKey:@"progress"]floatValue]/100;
    user.progressString = [NSString stringWithFormat:@"%@%@",[temp objectForKey:@"progress"],@"%"];
    user.task = [((NSString *)[temp objectForKey:@"task"]) intValue];
    user.complete = [((NSString *)[temp objectForKey:@"complete"]) intValue];
    temp = [temp objectForKey:@"user"];
    user.userObj = temp;
    NSString * userBgIamge =[[temp objectForKey:@"profileBg"] objectForKey:@"attachUrl"];
    if (userBgIamge) {
       user.userBgImg = API_IMAGE_URL_GET2(userBgIamge);
    }
    user.userCode = [temp objectForKey:@"userCode"];
    user.userDataId = [[temp valueForKey:@"id"]longValue];
    NSString * isTrafficAdminstr = [temp valueForKey:@"isTrafficAdmin"];
    user.isTrafficAdmin = [isTrafficAdminstr isEqualToString:@"1"];
    NSString * data;
    data = [temp objectForKey:@"rolesIds"];
    data =  [[data substringFromIndex:1]substringToIndex:1];
    user.userkey = ((NSNumber*)[temp objectForKey:@"id"]).longLongValue;
    user.roelId = [data intValue];
    user.username = [temp objectForKey:@"userName"];
    if (user.roelId == 4) {
        user.setString = [[((NSDictionary *)[temp objectForKey:@"organization"])objectForKey:@"type"]objectForKey:@"value"];
        user.type = [temp objectForKey:@"userType"];
    }else{
     user.setString = [((NSDictionary *)[temp objectForKey:@"organization"])objectForKey:@"shortName"];
     user.type = [temp objectForKey:@"userType"];
    }
    user.userId = [NSString stringWithFormat:@"%lli",[[temp objectForKey:@"userCode"] longLongValue]];
    data = [[temp objectForKey:@"portrait"] objectForKey:@"attachUrl"];
    user.headerImageUrl = API_IMAGE_URL_GET2(data);
    user.mobilePhone = [temp objectForKey:@"mobilePhone"];
    user.sexName = [@"女" isEqual:[temp objectForKey:@"gender"]]?@"女":@"男";
    user.sexValue = [user.sexName isEqual:@"女"]?0:1;

        user.userage = [[temp objectForKey:@"age"]intValue];
    
        user.organizationID = [NSString stringWithFormat:@"%lli",[[[temp objectForKey:@"organization"]objectForKey:@"id"]longLongValue]];
    user.organizationType =[[[[temp objectForKey:@"organization"]objectForKey:@"type"]objectForKey:@"id"]integerValue];
    user.organizationTypeName =[[[temp objectForKey:@"organization"]objectForKey:@"type"]objectForKey:@"value"];
    
    
    return user;
}
@end
