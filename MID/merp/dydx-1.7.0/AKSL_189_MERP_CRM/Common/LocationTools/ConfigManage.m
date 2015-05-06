//
//  ConfigManage.m
//  Anbaby－V2.0.0
//
//  Created by AKSL-td on 13-9-24.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "ConfigManage.h"
#import "Common.h"

@implementation ConfigManage
static LoginUser * loginuser = nil;
+(Organization*)getOrganization{
    return [Organization getInstance];
}
+(LoginUser *)getLoginUser{
    return loginuser;
}
+(LoginUser *)updateLoginUser{
    loginuser = [LoginUser getLoginUserFromJson:[ConfigManage getConfig:HTTP_API_JSON_PERSONINFO]];
    return  loginuser;
}
+(Organization*)updateOrganization{
    return  [Organization getNewInstance];
}
+(void)setConfig:(NSString *)key Value:(id)value{
    if([key isEqualToString:HTTP_API_JSON_PERSONINFO]){
        loginuser = [LoginUser getLoginUserFromJson:value];
        [Organization getNewInstance];
    }
    else if(loginuser && ![key isEqualToString:HTTP_API_PCODE] && ![key isEqualToString:APP_NAME_AND_RES] && ![key isEqualToString:STR_USER_PASSWORD]){
        key = [key stringByAppendingString:loginuser.userId];
    }
    NSUserDefaults *usrDefauls=[NSUserDefaults standardUserDefaults];
    [usrDefauls setValue:value forKey:key];
    [usrDefauls synchronize];
}
+(void)removeConfig:(NSString *)key{
 NSUserDefaults *usrDefauls=[NSUserDefaults standardUserDefaults];
[usrDefauls removeObjectForKey:key];
}
+(id)getConfig:(NSString *)key{
    if (loginuser && ![key isEqualToString:HTTP_API_PCODE] && ![key isEqualToString:HTTP_API_JSON_PERSONINFO] && ![key isEqualToString:STR_USER_PASSWORD] && ![key isEqualToString:APP_NAME_AND_RES]){
        key = [key stringByAppendingString:loginuser.userId];
    }
    NSUserDefaults *usrDefauls=[NSUserDefaults standardUserDefaults];
    return  [usrDefauls valueForKey:key];
}

+(BOOL)fileExistsAtPath:(NSString *)filename{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[ConfigManage getFilePath:filename]];
}


+(NSString *)getFilePath:(NSString *)filename{
    //创建文档文件夹
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentsDirectory]) {
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [documentsDirectory stringByAppendingPathComponent:filename];
}


+(NSString *)getUpdateFileName:(NSString *)type{
    double time=CFAbsoluteTimeGetCurrent()*100;
    NSString *filename =  [NSString stringWithFormat:@"%@%11.0f%@.jpg",type,time,[ConfigManage getConfig:@"UserInfoId"]];
    return filename;
}
+(NSString *)saveJPEGImageForUpdate:(UIImage *)image FileName:(NSString *)filename{
    
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
//    // 获取沙盒目录
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:filename];
//    // 将图片写入文件
//    [imageData writeToFile:fullPath atomically:NO];
    NSString *fullFilename = [ConfigManage getFilePath:filename];
    NSData* imageData =UIImageJPEGRepresentation(image, 0.7f);
    [imageData writeToFile:fullFilename atomically:NO];
    return fullFilename;
    
}
+(NSString *)savePNGImageForUpdate:(UIImage *)image FileName:(NSString *)filename{
    NSString *fullFilename = [ConfigManage getFilePath:filename];
    NSData* imageData =UIImagePNGRepresentation(image);
    [imageData writeToFile:fullFilename atomically:NO];
    return fullFilename;
}

+(void) clearAllData{
    NSUserDefaults *u=[NSUserDefaults standardUserDefaults];
    [u removeObjectForKey:HTTP_API_PCODE];
    [u removeObjectForKey:STR_USER_PASSWORD];
    [u removeObjectForKey:HTTP_API_JSON_PERSONINFO];
    [u removeObjectForKey:HTTP_API_JSON_ROLEINFOS];
}

+(void)clearFileCache{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:documentsDirectory]) {
        [fileManager removeItemAtPath:documentsDirectory error:nil];
    }
}
+(NSString *)getImageSamll:(NSString *)url{
    if (!url) {
        return url;
    }
    NSString * text = @".png";
    if ([url hasSuffix:@".jpg"]) {
        text = @".jpg";
    }
    url = [[[url substringToIndex:(url.length - 4)]stringByAppendingString:@"-200"]stringByAppendingString:text];
    return  url;
}
@end
