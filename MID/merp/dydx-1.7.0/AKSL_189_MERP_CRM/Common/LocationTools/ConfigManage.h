//
//  ConfigManage.h
//  Anbaby－V2.0.0
//
//  Created by AKSL-td on 13-9-24.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginUser.h"
#import "Organization.h"

@interface ConfigManage : NSObject

//获取当前登陆用户
+(LoginUser *)getLoginUser;
//获取当前登陆用户所在部门
+(Organization*)getOrganization;
//更新当前登陆用户
+(LoginUser *)updateLoginUser;
//更新当前登陆用户所在部门
+(Organization*)updateOrganization;
//本地保存信息
+(void)setConfig:(NSString *)key Value:(id)value;

//获取本地信息
+(id)getConfig:(NSString*)key;

+(void)removeConfig:(NSString *)key;

//获取本地文件地址是否存在文件
+(BOOL)fileExistsAtPath:(NSString *)filename;

//获得本地文件地址
+(NSString *)getFilePath:(NSString *)filename;

//保存图片
+(NSString *)saveJPEGImageForUpdate:(UIImage *)image FileName:(NSString *)filename;
//保存图片
+(NSString *)savePNGImageForUpdate:(UIImage *)image FileName:(NSString *)filename;

//获得上传文件名
+(NSString *)getUpdateFileName:(NSString *)type;

+(NSString *)getImageSamll:(NSString *)url;
//清除所有的数据
+(void) clearAllData;
+(void) clearFileCache;
@end
