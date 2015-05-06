//
//  HttpToolsRequestSynchronize.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 13-12-8.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "HttpToolsRequestSynchronize.h"
#import "ASIFormDataRequest.h"
static id xHttpToolsRequestSynchronize;
//存储在执行中的request
static NSMutableArray *HTTPTOOLSREQUESTARRAY;
//要保证HTTPTOOLSIFEXCUS不能被同时操作
static NSLock *HTTPTOOLSLOCK_1;
//要保证request不能被同时操作
static NSLock *HTTPTOOLSLOCK_2;
//是否是在执行中
static bool HTTPTOOLSIFEXCUS = NO;
//当前正在执行的request INDEX
static int unsigned HTTPTOOLSCURREQUESTINDEX = 0;
//最长的等待时间
static int unsigned const HTTPTOOLSOUTTIMES = 60;
@interface HttpToolsRequestSynchronize()
//异步连接请求数据
@property (strong,nonatomic) NSURLConnection* aSynConnection;
@end;
@implementation HttpToolsRequestSynchronize
+(void) initialize{
    HTTPTOOLSREQUESTARRAY = [[NSMutableArray alloc]init];
    HTTPTOOLSLOCK_1 = [[NSLock alloc]init];
    HTTPTOOLSLOCK_2 = [[NSLock alloc]init];
}
+(id) getInstance{
    @synchronized(xHttpToolsRequestSynchronize){
        if(!xHttpToolsRequestSynchronize){
            xHttpToolsRequestSynchronize = [[HttpToolsRequestSynchronize alloc]init];
        }
    }
    return xHttpToolsRequestSynchronize;
}
+(void) addASIFormDataRequest:(id)  reqeust{
    [HttpToolsRequestSynchronize addHTTPTOOLSREQUESTARRAY:reqeust];
    if([HttpToolsRequestSynchronize ifFirstExcu]){//执行request请求，如果还没有在执行
        __strong id target = [HttpToolsRequestSynchronize getInstance];//使用强引用
        NSThread* myThread = [[NSThread alloc] initWithTarget:target
                                                     selector:@selector(excuASIFormDataRequest)
                                                       object:nil];
        [myThread start];
        [myThread release];
    }
}
-(void) excuASIFormDataRequest{
    NSTimer *lastTimer;
    while ([HttpToolsRequestSynchronize hasNextHTTPTOOLSREQUESTARRAY]) {
        [HTTPTOOLSLOCK_2 lock];
        id request = HTTPTOOLSREQUESTARRAY[0];
        @try {
            if (lastTimer) {
                [lastTimer invalidate];//释放上一个的timer
            }
            if([request isKindOfClass:[ASIFormDataRequest class]]){
                [((ASIFormDataRequest*)request) startAsynchronous];
            }else if([request isKindOfClass:[NSMutableURLRequest class]]){
                NSLog(@"there has no implament the method for NSMutableURLRequest!");
            } else{
                @throw [[NSException alloc]initWithName:@"class type erro" reason:@"has no correspond class type" userInfo:nil];
            }
        }
        @finally {
            [HttpToolsRequestSynchronize removeHTTPTOOLSREQUESTARRAY:request];
            ++HTTPTOOLSCURREQUESTINDEX;
            lastTimer = [NSTimer timerWithTimeInterval:[[NSDate new] timeIntervalSince1970]+HTTPTOOLSOUTTIMES target:self selector:@selector(outTimeReleaseToNextReqeust) userInfo:nil repeats:NO];
            [lastTimer release];
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
            HTTPTOOLSCURREQUESTINDEX = 0;
            return YES;
        }
    }
    @finally {
        [HTTPTOOLSLOCK_1 unlock];
    }
}
//同步添加request
+(void) addHTTPTOOLSREQUESTARRAY:(id) target{
    @synchronized(HTTPTOOLSREQUESTARRAY){
        [HTTPTOOLSREQUESTARRAY addObject:target];
    }
}
//同步删除request
+(void) removeHTTPTOOLSREQUESTARRAY:(id) target{
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
