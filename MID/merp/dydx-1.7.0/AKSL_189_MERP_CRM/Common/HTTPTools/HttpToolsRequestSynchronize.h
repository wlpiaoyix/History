//
//  HttpToolsRequestSynchronize.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 13-12-8.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
/**
    creator:wlpiaoyi
    createTime:2013年12月8日 下午5:10
 */
@interface HttpToolsRequestSynchronize : NSObject
/**
    添加request保证每次只有一个请求
 */
+(void) addASIFormDataRequest:(ASIFormDataRequest*)  reqeust;
/**
    向下一步走，如果不执行这一个，就无法进行下一步
 */
+(void)  releaseToNextReqeust;
@end
