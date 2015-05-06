//
//  PublicInfo.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-22.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "PublicInfo.h"

@implementation PublicInfo

+(PublicInfo *)getPulicInfoByDic:(NSDictionary *)dic{
    PublicInfo * info = [PublicInfo new];
    NSString * data;
    info.infoId = [dic objectForKey:@"id"];
    info.contents = [dic objectForKey:@"contents"];
   
    data =[dic objectForKey:@"setTime"];
    if (data) {
        info.createTime = [NSDate dateFormateString:data FormatePattern:nil];
    }
    data =[dic objectForKey:@"createTime"];
    if (data) {
        info.TimeToNote = [NSDate dateFormateString:data FormatePattern:nil];
    }

    NSDictionary *user=[dic objectForKey:@"fromUser"];
    data = [[user objectForKey:@"portrait"] objectForKey:@"attachUrl"];
    info.userCode = [user objectForKey:@"userCode"];
    info.userheaderImageUrl = API_IMAGE_URL_GET2(data);
    info.username = [user objectForKey:@"userName"];
     info.picUrl  =API_IMAGE_URL_GET2([[dic objectForKey:@"digestPic"] objectForKey:@"attachUrl"]);
    return info;
}
+(PublicInfo *)getPulicInfoByJson:(NSString *)json{
    if (!json||[json isEqualToString:@""]) {
        return nil;
    }
    NSDictionary *temp = [json JSONValueNewMy];
    return [self getPulicInfoByDic:temp];
}
@end
