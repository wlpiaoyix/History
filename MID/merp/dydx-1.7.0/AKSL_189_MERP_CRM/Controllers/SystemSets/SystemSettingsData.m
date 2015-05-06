//
//  SystemSettingsData.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-4-14.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "SystemSettingsData.h"
#import "HttpApiCall.h"


@implementation SystemSettingsData

/*
 {
 "data":[
 {
 "gerenzhongxin":"个人中心"
 },
 {
 "xiugaimima":"修改密码"
 },
 {
 "yijianfankui":"意见反馈"
 },
 {
 "guanyuruanjian":"关于软件"
 },
 {
 "ruanjiangengxin":"软件更新:1.6.0"
 },
 {
 "qingchuhuancun":"清除缓存"
 }
 ]
 }
 
 
 {
 "touxiang":       {"img":"test_hader.jpg"},
 "mingzi":
 {"name":"糜风波"},
 "dianhua":
 {"phoneNum":"18990289797"},
 "xingbie":
 {"sex":"男"},
 "xiaoxiliebiao":
 {"message":""},
 "type":
 [
 {"type":"touxiang","name":"头像"},
 {"type":"mingzi","name":"名字"},
 {"type":"dianhua","name":"电话"},
 {"type":"xingbie","name":"性别"},
 {"type":"xiaoxiliebiao","name":"消息列表"}
 ]
 }
 */
+(NSDictionary *)setData :(NSString *)api :(BOOL)updateYesOrNo
{
    NSDictionary *dataDic = [[NSDictionary alloc] init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentD = [paths objectAtIndex:0];
    NSString *configFile = [documentD stringByAppendingPathComponent:@"system.txt"];
    NSMutableDictionary *configDic =[[NSMutableDictionary alloc] initWithContentsOfFile:configFile];
    if(configDic && updateYesOrNo == NO)
    {
        dataDic = configDic;
    }
    else if(configDic == nil || updateYesOrNo == YES)
    {
        ASIFormDataRequest *request = [HttpApiCall requestCallGET:api Params:nil Logo:@"setData"];
        __weak ASIFormDataRequest *requestx = request;
    
        [requestx setCompletionBlock:^
         {
             [requestx setResponseEncoding:NSUTF8StringEncoding];
             NSString *str = [requestx responseString];
             NSDictionary *dic = [str JSONValueNewMy];
             if (dic == nil) {
                 showMessageBox(@"暂无数据");
                 return;
             }
             if (![fileManager fileExistsAtPath:configFile]) {
                 
                 [fileManager createFileAtPath:configFile contents:nil attributes:nil];
             }
             
             [configDic writeToFile:configFile atomically:YES];

             [dataDic setValue:dic forKey:@"dataDic"];
         }];
        [requestx setFailedBlock:^
         {
         
         }];
        [requestx startAsynchronous];
    }
    return dataDic;
}


@end
