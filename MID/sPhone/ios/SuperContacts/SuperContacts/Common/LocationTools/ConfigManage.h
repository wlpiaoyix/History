//
//  ConfigManage.h
//  Anbaby－V2.0.0
//
//  Created by AKSL-td on 13-9-24.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModleUser.h"

@interface ConfigManage : NSObject;
//保存本地信息
+(bool) setConfigCache:(NSString *)key Value:(id)value;
//获取本地信息
+(NSString*) getConfigCache:(NSString *)key;
//保存本地信息
+(bool)setConfigTemp:(NSString *)key Value:(id)value;
//获取本地信息
+(NSString*)getConfigTemp:(NSString*)key;
//保存本地信息
+(bool)setConfigPublic:(NSString *)key Value:(id)value;
//获取本地信息
+(NSString*)getConfigPublic:(NSString*)key;
//获得本地文件地址
+(NSString *)getDocumentsDirectory;
//获得本地临时文件地址
+(NSString*) getTempDirectory;
//保存图片JPEG
+(NSString *)saveJPEGImageForUpdate:(UIImage *)image FileName:(NSString *)filename;
//保存图片PNG
+(NSString *)savePNGImageForUpdate:(UIImage *)image FileName:(NSString *)filename;
//==>清除所有的数据
+(void) clearAllCacheData;
+(void) clearAllTempData;
+(void) clearAllPublicData;
+(void) clearFileCache;
+(void) clearCacheUser;
//<==

//==>拓展
+(ModleUser*) getCurrentUser;
+(bool) synchronizeCurrentUser;
+(void) setCacheUser:(ModleUser*) user;
+(ModleUser*) getCacheUser;
@end
