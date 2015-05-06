//
//  SSY_Contants.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-9.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SSY_Contants.h"
#import "SABFromDataBaseService.h"
#import "SABFromLocationContentService.h"
#import "EntityUser.h"
#import "EntityPhone.h"
#import "ChineseToPinyin.h"
#import "ParsetVcardAndEntity.h"
#import "EntityPhone.h"
#import "MADE_COMMON.h"
#import "CTM_MainController.h"
#import "CTM_RightController.h"
@interface SSY_Contants()
@property SABFromDataBaseService *fdbs;
@property SABFromLocationContentService *flcs;
@end
@implementation SSY_Contants
-(id) init{
    self = [super init];
    if (self) {
        _fdbs = COMMON_FDBS;
        _flcs = COMMON_FLCS;
    }
    return self;
}
-(bool) ifWouldSynchroze{
    NSArray *allLS = [_flcs query:nil Phone:nil];
    NSArray *allDS = [_fdbs queryEntityUserByName:nil];
    if([allDS count]!=[allLS count]){
        return true;
    }
    for (EntityUser *userl in allLS) {
        EntityUser *userd = [self synchrozeLocationTagert:userl allInDataBaseUser:allDS];
        if(!userd||userd==nil)return true;
    }
    return false;
}
-(bool) synchrozeLocationAllData{
    NSArray *allLS = [_flcs query:nil Phone:nil];
    NSArray *allDS = [_fdbs queryEntityUserByName:nil];
//    NSFileManager *fmanager = [NSFileManager defaultManager];
    for (EntityUser *userl in allLS) {
        EntityUser *userd = [self synchrozeLocationTagert:userl allInDataBaseUser:allDS];
        if(!userd){
            userd = [[EntityUser alloc]init];
        }
        if(!userl.telephones|| ![userl.telephones count]){
            continue;
        }
        if(![NSString isEnabled:userd.defaultPhone]){
            userd.defaultPhone = [userl.telephones objectAtIndex:0];
            userd.defaultPhone = COMMON_CHOOSENUM(userd.defaultPhone);
        }
        if([NSString isEnabled:userl.userName]){
            userd.userName = userl.userName;
        }else{
            continue;
        }
        if([NSString isEnabled:userl.longPingYing]){
            userd.longPingYing = userl.longPingYing;
        }
        if([NSString isEnabled:userl.shortPingYing]){
            userd.shortPingYing = userl.shortPingYing;
        }
        if([userl.dataImage isKindOfClass:[NSData class]]){
            UIImage *image = [[UIImage alloc]initWithData:userl.dataImage];
            NSString *imageName = [ChineseToPinyin pinyinFromChiniseString:userl.userName];
            NSString *imageUrl = [ConfigManage saveJPEGImageForUpdate:image FileName:[imageName stringByAppendingString:@".jpg"]];
            if(imageUrl){
                userd.dataImage = imageUrl;
                [MADE_COMMON pasetImageAddWrite110ak640:userd.dataImage];
            }
        }
        userd.locationStatus = 2;
        NSMutableArray *temp = [NSMutableArray new];
        int i=0;
        for (NSString *_phone in userl.telephones) {
            EntityPhone *mp = [EntityPhone new];
            mp.phoneNum = COMMON_CHOOSENUM(_phone);
            switch (i) {
                case phone_default:
                    mp.type = phone_default;
                    break;
                case phone_mobile:
                    mp.type = phone_mobile;
                    break;
                case phone_home:
                    mp.type = phone_home;
                    break;
                case phone_company:
                    mp.type = phone_company;
                    break;
                case phone_other:
                    mp.type = phone_other;
                    break;
                default:
                    break;
            }
            [temp addObject:mp];
            i++;
        }
        userd.telephones = temp;
        [_fdbs mergeEntityUser:userd];
    }
    [ConfigManage setConfigCache:@"copy" Value:[NSString stringWithFormat:@"%f",[NSDate new].timeIntervalSince1970]];
    [[CTM_RightController getSingleInstance] refreshData];
    [[CTM_MainController getSingleInstance] refreshRecord];
    return false;
}
-(NSString*) synchrozeWebAllData{
    NSArray *allDS = [_fdbs queryEntityUserByName:nil];
    NSString *temp = [ParsetVcardAndEntity parseEntityToVcard:allDS];
    //字符串写文件
    NSError *error;
    NSString *szPath =  [NSString stringWithFormat:@"%@/temp.vcf",[ConfigManage getTempDirectory]];  //附加路径地址
    if (![temp writeToFile:szPath atomically:YES  //atomically:是否是原子访问文件的
                        encoding:NSUTF8StringEncoding error:&error]) {          //写入成功返回yes 否则no
        NSLog(@"Error writing to file :%@",[error localizedDescription]);       //输出错误描述
        return nil;
    }
    return szPath;
}
-(EntityUser*) synchrozeLocationTagert:(EntityUser*) userLoction allInDataBaseUser:(NSArray*) allDs{
    for (EntityUser *userd in allDs) {
        NSArray *phones = userLoction.telephones;
        for (NSString *phone in phones) {
            NSString *temp = COMMON_CHOOSENUM(phone);
            NSArray *tempP = userd.telephones;
            for (EntityPhone *ph in tempP) {
                if([temp  isEqual:ph.phoneNum]){
                    return userd;
                }
            }
        }
    }
    return nil;
}
@end
