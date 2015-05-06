//
//  PublicInfo.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-22.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicInfo : NSObject

@property (strong,nonatomic) NSString * infoId;
@property (strong,nonatomic) NSString * contents;
@property (strong,nonatomic) NSString * picUrl;
@property (strong,nonatomic) NSDate * createTime;
@property (strong,nonatomic) NSString *userheaderImageUrl;
@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) NSString *userCode;
@property (strong,nonatomic) NSDate *TimeToNote;

+(PublicInfo *)getPulicInfoByJson:(NSString *)json;
+(PublicInfo *)getPulicInfoByDic:(NSDictionary *)dic;
@end
