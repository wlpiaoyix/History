//
//  ConfigManage.m
//  Anbaby－V2.0.0
//
//  Created by AKSL-td on 13-9-24.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "ConfigManage.h"
#import "Common.h"
static ModleUser *currentUser;
static ModleUser *cacheUser;
@implementation ConfigManage
+(bool) setConfigCache:(NSString *)key Value:(id)value{
    if(![NSString isEnabled:key]&&![NSString isEnabled:value])return false;
    NSString *currentAccount = [ConfigManage getConfigPublic:COMMON_KEY_AT];
    if(![NSString isEnabled:currentAccount])return false;
    if([key hasPrefix:currentAccount])return false;
    return [ConfigManage setConfig:[currentAccount stringByAppendingString:key] Value:value];
    return true;
}
+(NSString*) getConfigCache:(NSString *)key{
    if(![NSString isEnabled:key])return nil;
    NSString *currentAccount = [ConfigManage getConfigPublic:COMMON_KEY_AT];
    if(![NSString isEnabled:currentAccount])return nil;
    if([key hasPrefix:currentAccount])return nil;
    return [ConfigManage getConfig:[currentAccount stringByAppendingString:key]];
}
+(bool) setConfigTemp:(NSString *)key Value:(id)value{
    if(![NSString isEnabled:key]&&![NSString isEnabled:value])return false;
    if([key hasPrefix:COMMON_KEY_TEMP])return false;
    return [ConfigManage setConfig:[COMMON_KEY_TEMP stringByAppendingString:key] Value:value];
}
+(NSString*) getConfigTemp:(NSString *)key{
    if(![NSString isEnabled:key])return nil;
    if([key hasPrefix:COMMON_KEY_TEMP])return nil;
    return [ConfigManage getConfig:[COMMON_KEY_TEMP stringByAppendingString:key]];
}
//保存本地信息
+(bool)setConfigPublic:(NSString *)key Value:(id)value{
    if(![NSString isEnabled:key]&&![NSString isEnabled:value])return false;
    if([key hasPrefix:COMMON_KEY_PU])return false;
    return [ConfigManage setConfig:[COMMON_KEY_PU stringByAppendingString:key] Value:value];
}
//获取本地信息
+(NSString*)getConfigPublic:(NSString*)key{
    if(![NSString isEnabled:key])return nil;
    if([key hasPrefix:COMMON_KEY_PU])return nil;
    return [ConfigManage getConfig:[COMMON_KEY_PU stringByAppendingString:key]];
}
+(NSString*) getTempDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
    }
    documentsDirectory = [[ConfigManage getDocumentsDirectory] stringByAppendingString:@"/temp" ];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentsDirectory]) {
        //创建文档文件夹
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentsDirectory;
}
+(NSString *)getDocumentsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:documentsDirectory]) {
        //创建文档文件夹
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return documentsDirectory;
}
+(NSString *)saveJPEGImageForUpdate:(UIImage *)image FileName:(NSString *)filename{
    NSString *fullFilename = [[[ConfigManage getDocumentsDirectory] stringByAppendingString:@"/" ] stringByAppendingString:filename];
    NSData* imageData =UIImageJPEGRepresentation(image, 1.0f);
    [imageData writeToFile:fullFilename atomically:NO];
    return fullFilename;
}
+(NSString *)savePNGImageForUpdate:(UIImage *)image FileName:(NSString *)filename{
    NSString *fullFilename =[[[ConfigManage getDocumentsDirectory] stringByAppendingString:@"/" ] stringByAppendingString:filename];
    NSData* imageData =UIImagePNGRepresentation(image);
    [imageData writeToFile:fullFilename atomically:NO];
    return fullFilename;
}
+(void) clearAllCacheData{
    NSString *perfix = [ConfigManage getConfigTemp:COMMON_KEY_AT];
    if(![NSString isEnabled:perfix ])return;
    NSUserDefaults *usrDefauls=[NSUserDefaults standardUserDefaults];
    NSDictionary *datas = [usrDefauls dictionaryRepresentation];
    NSArray *keys = [datas allKeys];
    for (NSString *key in keys) {
        if([key hasPrefix:perfix]){
            [usrDefauls removeObjectForKey:key];
        }
    }
    datas = [usrDefauls dictionaryRepresentation];
}
+(void) clearCacheUser{
    cacheUser = nil;
}
+(void) clearAllTempData{
    NSUserDefaults *usrDefauls=[NSUserDefaults standardUserDefaults];
    NSDictionary *datas = [usrDefauls dictionaryRepresentation];
    NSArray *keys = [datas allKeys];
    for (NSString *key in keys) {
        if(![key hasPrefix:COMMON_KEY_TEMP])continue;
        [usrDefauls removeObjectForKey:key];
    }
    currentUser = nil;
    cacheUser = nil;
}
+(void) clearAllPublicData{
    NSUserDefaults *usrDefauls=[NSUserDefaults standardUserDefaults];
    NSDictionary *datas = [usrDefauls dictionaryRepresentation];
    NSArray *keys = [datas allKeys];
    for (NSString *key in keys) {
        if(![key hasPrefix:COMMON_KEY_PU])continue;
        [usrDefauls removeObjectForKey:key];
    }
}
+(void)clearFileCache{
    NSString *directory = [ConfigManage getTempDirectory];
    [ConfigManage deleteAllFile:directory];
}
+(bool)setConfig:(NSString *)key Value:(id)value{
    NSUserDefaults *usrDefauls=[NSUserDefaults standardUserDefaults];
    [usrDefauls setValue:value forKey:key];
    [usrDefauls synchronize];
    return true;
}
+(NSString*)getConfig:(NSString *)key{
    NSUserDefaults *usrDefauls=[NSUserDefaults standardUserDefaults];
    return  [usrDefauls valueForKey:key];
}
+(void) deleteAllFile:(NSString*) filePath{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSArray *temp = [fileManager subpathsAtPath:filePath];
        if(temp){
            for (NSString *temp2 in temp) {
                NSError* e = NULL;
                [fileManager removeItemAtPath:[[filePath stringByAppendingString:@"/" ] stringByAppendingString:temp2] error:&e];
                NSLog(@"%@",[[filePath stringByAppendingString:@"/" ] stringByAppendingString:temp2]);
            }
        }
    }
}

+(ModleUser*) getCurrentUser{
    @synchronized(currentUser){
        if(!currentUser){
            [ConfigManage synchronizeCurrentUser];
        }
    }
    return currentUser;
}
+(bool) synchronizeCurrentUser{
    @synchronized(currentUser){
        NSString *str = [ConfigManage getConfigCache:CMCK_ACCONTINFO];
        if(![NSString isEnabled:str])return false;
        currentUser = [ModleUser modelInitWithJSON:[str JSONValue]];
        return true;
    }
    return false;
}
+(void) setCacheUser:(ModleUser*) user{
    cacheUser = user;
    if(cacheUser)[ConfigManage setConfigCache:[[user toJSON] JSONRepresentation] Value:@"tempUser"];
    else [ConfigManage setConfigCache:false Value:@"tempUser"];
}
+(ModleUser*) getCacheUser{
    if(!cacheUser)cacheUser = [ModleUser modelInitWithJSON:[[ConfigManage getConfigTemp:@"tempUser"] JSONValue]];
    return cacheUser;
}
//+(ModleUser*) parseJSONtoClass:(NSString*) key{
//    NSString *str = [ConfigManage getConfigCache:key];
//    if(![NSString isEnabled:str])return nil;
//    NSDictionary *json = [str JSONValue];
//    if(json){
//        ModleUser *user = [ModleUser new];
//        user.key = [json objectForKey:@"id"];
//        user.name = [json objectForKey:@"name"];
//        user.defaultPicUrl = [json objectForKey:@"defaultPicUrl"];
//        user.sex = [json objectForKey:@"sex"];
//        user.phoneNum = [json objectForKey:@"phoneNum"];
//        user.qq = [json objectForKey:@"qq"];
//        user.weixin = [json objectForKey:@"weixin"];
//        user.weibo = [json objectForKey:@"weibo"];
//        user.email = [json objectForKey:@"email"];
//        user.homeAddress = [json objectForKey:@"homeAddress"];
//        user.companyAddress = [json objectForKey:@"companyAddress"];
//        return user;
//    }
//    return nil;
//}

@end
