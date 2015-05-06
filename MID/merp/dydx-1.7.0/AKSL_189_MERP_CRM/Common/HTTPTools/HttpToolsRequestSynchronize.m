//
//  HttpToolsRequestSynchronize.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 13-12-8.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "HttpToolsRequestSynchronize.h"
//存储在执行中的request
static NSMutableArray *HTTPTOOLSREQUESTARRAY;
//要保证HTTPTOOLSIFEXCUS不能被同时操作
static NSLock *HTTPTOOLSLOCK_1;
//要保证ASIFormDataRequest不能被同时操作
static NSLock *HTTPTOOLSLOCK_2;
//是否是在执行中
static bool HTTPTOOLSIFEXCUS = NO;
//当前正在执行的request INDEX
static int HTTPTOOLSCURREQUESTINDEX = 0;
//最长的等待时间
static float HTTPTOOLSOUTTIMES = 60;
@interface HttpToolsRequestSynchronize()
@end;
@implementation HttpToolsRequestSynchronize
+(void) initialize{
    HTTPTOOLSREQUESTARRAY = [[NSMutableArray alloc]init];
    HTTPTOOLSLOCK_1 = [[NSLock alloc]init];
    HTTPTOOLSLOCK_2 = [[NSLock alloc]init];
}
+(void) addASIFormDataRequest:(ASIFormDataRequest*)  reqeust{
    [HttpToolsRequestSynchronize addHTTPTOOLSREQUESTARRAY:reqeust];
    if([HttpToolsRequestSynchronize ifFirstExcu]){//执行request请求，如果还没有在执行
        __strong id target = [[HttpToolsRequestSynchronize alloc]init];//使用强引用
        NSThread* myThread = [[NSThread alloc] initWithTarget:target
                                                     selector:@selector(excuASIFormDataRequest)
                                                       object:nil];
        [myThread start];
    }
}
-(void) excuASIFormDataRequest{
    NSTimer *lastTimer;
    while ([HttpToolsRequestSynchronize hasNextHTTPTOOLSREQUESTARRAY]) {
        [HTTPTOOLSLOCK_2 lock];
        ASIFormDataRequest *request = HTTPTOOLSREQUESTARRAY[0];
        @try {
            if (lastTimer) {
                [lastTimer invalidate];//释放上一个的timer
            }
            [request startAsynchronous];
        }
        @finally {
            [HttpToolsRequestSynchronize removeHTTPTOOLSREQUESTARRAY:request];
            ++HTTPTOOLSCURREQUESTINDEX;
            lastTimer = [NSTimer timerWithTimeInterval:[[NSDate new] timeIntervalSince1970]+HTTPTOOLSOUTTIMES target:self selector:@selector(outTimeReleaseToNextReqeust) userInfo:nil repeats:NO];
        }
    }
}
-(void) outTimeReleaseToNextReqeust{
    [HttpToolsRequestSynchronize releaseToNextReqeust];
    NSLog(@"Unlock on time,you has out time");
}
+(void)  releaseToNextReqeust{
    [HTTPTOOLSLOCK_2 unlock];
}
//是否是第一次执行
+(bool) ifFirstExcu{
    [HTTPTOOLSLOCK_1 lock];
    @try {
        if(HTTPTOOLSIFEXCUS){
            return  NO;
        }else{
            HTTPTOOLSIFEXCUS = YES;
            return YES;
        }
    }
    @finally {
        [HTTPTOOLSLOCK_1 unlock];
    }
}
//同步添加request
+(void) addHTTPTOOLSREQUESTARRAY:(ASIFormDataRequest*) target{
    @synchronized(HTTPTOOLSREQUESTARRAY){
        [HTTPTOOLSREQUESTARRAY addObject:target];
    }
}
//同步删除request
+(void) removeHTTPTOOLSREQUESTARRAY:(ASIFormDataRequest*) target{
    @synchronized(HTTPTOOLSREQUESTARRAY){
        [HTTPTOOLSREQUESTARRAY removeObject:target];
    }
}
//是否有数据
+(bool) hasNextHTTPTOOLSREQUESTARRAY{
    @synchronized(HTTPTOOLSREQUESTARRAY){
        bool  tempFlag =  [HTTPTOOLSREQUESTARRAY count]==0?NO:YES;
        [HTTPTOOLSLOCK_1 lock];
        @try {
            if (!tempFlag) {
                HTTPTOOLSIFEXCUS = NO;//如果没有了数据就等待下一次执行
            }
        }
        @finally {
            [HTTPTOOLSLOCK_1 unlock];
        }
        return tempFlag;
    }
}
@end
