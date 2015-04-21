//
//  FDCBaseManger.m
//  FDC
//
//  Created by wlpiaoyi on 15/1/16.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "FDCBaseManger.h"
#import "ConfigManage+Expand.h"

NSString *const URL_BASE_HTTP = @"http://125.64.9.232:61/HWT.WEB/index.aspx?ActionModel=";


NSString *const KEY_STATU_CODE = @"StatuCode";
NSString *const KEY_PROMPT_MSG = @"PromptMsg";
NSString *const KEY_RESULT_DATA = @"ResultData";

static FDEntityManager *STATIC_EM;
@implementation FDCBaseManger
+(void) initialize{
    STATIC_EM = [FDEntityManager getSingleInstanceWithDBName:@"FDC.DATABASE"];
    [FDEntityManager checkAllTables:@[[UserEntity class]] dbName:@"FDC.DATABASE"];
}
-(id) init{
    if (self=[super init]) {
        self.em = STATIC_EM;
    }
    return self;
}
-(id) checkData:(id) data{
    id result;
    if (data) {
        result = [data JSONValue];
    }
    if(result){
        NSNumber *statusCode = [result objectForKey:KEY_STATU_CODE];
        NSString *promptMsg = [result objectForKey:KEY_PROMPT_MSG];
        id resultData = [result objectForKey:KEY_RESULT_DATA];
        if (statusCode.intValue == 1) {
            result = resultData;
        }else{
            [Utils showAlert:promptMsg?promptMsg:@"" title:nil];
            result = 0;
        }
    }
    return result;
}
-(id<HttpUtilRequestDelegate>) createRequestWith:(NSString*) action{
    id<HttpUtilRequestDelegate> htr = [HttpUtilRequest new];
    if ([ConfigManage getLoginUser]&&LoginUserName&&LoginUserPassoword) {
        [htr setRequestString:[NSString stringWithFormat:@"%@%@&UserName=%@&UserPwd=%@",URL_BASE_HTTP,action,LoginUserName,LoginUserPassoword]];
    }else{
        [htr setRequestString:[NSString stringWithFormat:@"%@%@",URL_BASE_HTTP,action]];
    }
    return htr;
}
-(NSString*) getKeyConfiger:(NSString*) key{
    NSString *keyConfiger = [NSString stringWithFormat:@"%@_%@_%@",key,LoginUserName,LoginUserPassoword];
    return keyConfiger;

}
@end
