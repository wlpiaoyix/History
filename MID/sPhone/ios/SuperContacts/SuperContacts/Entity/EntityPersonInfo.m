//
//  ModelPersonInfo.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-4.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "EntityPersonInfo.h"

@implementation EntityPersonInfo
-(UIImage*) personImage{
    if (!_personImage&&[NSString isEnabled:_personImageUrl]) {
        NSFileManager *f = [NSFileManager defaultManager];
        if([f fileExistsAtPath:_personImageUrl]){
            _personImage = [UIImage imageWithContentsOfFile:_personImageUrl];
        }
    }
    return _personImage;
}
-(void) setJsonData:(NSDictionary *)jsonData{
    if ([jsonData isKindOfClass:[NSString class]]&&[NSString isEnabled:jsonData]) {
        _jsonData = [((NSString*)jsonData) JSONValue];
    }else{
        _jsonData = jsonData;
    }
}

+(NSString*) getKey{
    return @"personId";
}
+ (NSArray*) getColums{
    return [NSArray arrayWithObjects:@"personName",@"personCode",@"personSex",@"personImageUrl",@"jsonData", nil];
}
+(long long int) getTypes{
    return 133333;
}
+(NSString*) getTable{
    return @"EntityPersonInfo";
}

@end
