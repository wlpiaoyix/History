//
//  HttpApiCall.m
//  test02
//
//  Created by qqpiaoyi on 13-10-16.
//  Copyright (c) 2013年 qqpiaoyi. All rights reserved.
//

#import "HttpApiCall.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "SBJsonParser.h"
#import "ConfigManage.h"
#import "HashSHA256.h"
#import "HT_CheckHttp.h"
static HashSHA256 *hashSh = false;
static int defaultOutTimeForReqeust = 30;
@implementation HttpApiCall

+(ASIFormDataRequest*) requestCallPOST:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo{
    return [HttpApiCall requestCallPOST:_url Params:_params Logo:_logo OutTime:defaultOutTimeForReqeust];
}
+(ASIFormDataRequest*) requestCallPOST:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo OutTime:(int) _outTime{
    NSURL *url = [HttpApiCall createBaseURL:_url Params:nil Logo:_logo];
    if(!url)return nil;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if (_params!=nil){
        const char* str = [[_params JSONRepresentation] UTF8String];
        NSMutableData *data = [[NSMutableData alloc]initWithBytes:(str) length:strlen(str)];
        [request setPostBody:data];
    }
    [request setTimeOutSeconds:_outTime];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:COMMON_HTTP_API_POST];
    return request;
}

+(ASIFormDataRequest*) requestCallPOST:(NSString*) _url ParamsData:(NSString *)_params Logo:(NSString*) _logo{
    NSURL *url = [HttpApiCall createBaseURL:_url Params:nil Logo:_logo];
    if(!url)return nil;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if (_params!=nil){
        const char* str = [_params UTF8String];
        NSMutableData *data = [[NSMutableData alloc]initWithBytes:(str) length:strlen(str)];
        [request setPostBody:data];
    }
    [request setTimeOutSeconds:defaultOutTimeForReqeust];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:COMMON_HTTP_API_POST];
    return request;
}
+(ASIFormDataRequest*) requestCallPUT:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo{
    return [HttpApiCall requestCallPUT:_url Params:_params Logo:_logo OutTime:defaultOutTimeForReqeust];
}
+(ASIFormDataRequest*) requestCallPUT:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo OutTime:(int) _outTime{
    NSURL *url = [HttpApiCall createBaseURL:_url Params:nil Logo:_logo];
    if(!url)return nil;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if (_params!=nil){
        const char* str = [[_params JSONRepresentation] UTF8String];
        NSMutableData *data = [[NSMutableData alloc]initWithBytes:(str) length:strlen(str)];
        [request setPostBody:data];
    }
    [request setTimeOutSeconds:_outTime];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:COMMON_HTTP_API_PUT];
    return request;
}
+(ASIFormDataRequest*) requestCallGET:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo{
    NSURL *url = [HttpApiCall createBaseURL:_url Params:_params Logo:_logo];
    if(!url)return nil;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:defaultOutTimeForReqeust];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:COMMON_HTTP_API_GET];
    return request;
}
+(ASIFormDataRequest*) requestCallDELET:(NSString*) _url Logo:(NSString*) _logo{
    NSURL *url = [HttpApiCall createBaseURL:_url Params:nil Logo:_logo];
    if(!url)return nil;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:defaultOutTimeForReqeust];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:COMMON_HTTP_API_DELETE];
    return request;
}
+(ASIFormDataRequest*) requestCallUpload:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo OutTime:(double)outTime{
    NSURL *url = [HttpApiCall createFileURL:_url Params:nil Logo:_logo];
    if(!url)return nil;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if (_params!=nil){
        const char* str = [[_params JSONRepresentation] UTF8String];
        NSMutableData *data = [[NSMutableData alloc]initWithBytes:(str) length:strlen(str)];
        [request setPostBody:data];
    }
    [request setTimeOutSeconds:outTime];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:COMMON_HTTP_API_POST];
    return request;
}

/**
 构造一个String URL
 */
+(NSString*) createURL:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo{
    @synchronized(hashSh){
        if(!hashSh){
            hashSh = [HashSHA256 new];
        }
    }
    NSString *code = (NSString*)[ConfigManage getConfigTemp:COMMON_KEY_AT];//@"10000101";//
    NSString *password = (NSString*)[ConfigManage getConfigTemp:COMMON_KEY_PW];//@"wewq";//
    if(![HT_CheckHttp checkLogStatus]){
        return nil;
    }
    NSString *url;
    if([NSString isEnabled:code]&&[NSString isEnabled:password]){
        NSString *ak = [hashSh hashedValue:password andData:[[COMMON_HTTP_URL_SUFFIX stringByAppendingString:_url] stringByAppendingString:code]];
        url = [[[[[[[[[[[[
                                    _url stringByAppendingString:@"?"]
                                   stringByAppendingString:CMCK_PCODE]
                                  stringByAppendingString:@"="]
                                 stringByAppendingString:code]
                                stringByAppendingString:@"&" ]
                               stringByAppendingString:CMCK_PAK]
                              stringByAppendingString:@"="]
                             stringByAppendingString:ak]
                            stringByAppendingString:@"&" ]
                           stringByAppendingString:CMCK_PLOGO]
                          stringByAppendingString:@"="]
                         stringByAppendingString:_logo];
    }else{
        url = [[[[_url stringByAppendingString:@"?"]
                 stringByAppendingString:CMCK_PLOGO]
                stringByAppendingString:@"="]
               stringByAppendingString:_logo];
    }
    
    if(_params != nil){
        NSArray *keys = [(NSDictionary*)_params allKeys];
        for (NSString *key in keys) {
            NSString *value = [(NSDictionary*)_params objectForKey:key];
            url = [[[[url stringByAppendingString:@"&"]
                     stringByAppendingString:key]
                    stringByAppendingString:@"="]
                   stringByAppendingString:value];
        }
    }
    //中文字符转换处理
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return  url;
}
/**
 构造一个BaseURL
 */
+(NSURL*) createBaseURL:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo{
    NSString *temp = [HttpApiCall createURL:_url Params:_params Logo:_logo];
    if([NSString isEnabled:temp]) temp = COMMON_GET_BASE_URL(temp);
    else return nil;
    NSLog(@"HTTP访问：url:%@",temp);
    NSURL *ourl = [NSURL URLWithString:temp];
    return  ourl;
}

/**
 构造一个FileURL
 */
+(NSURL*) createFileURL:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo{
    NSString *temp = [HttpApiCall createURL:_url Params:_params Logo:_logo];
    if([NSString isEnabled:temp]) temp = COMMON_GET_FILE_URL(temp);
    else return nil;
    NSLog(@"HTTP访问：url:%@",temp);
    NSURL *ourl = [NSURL URLWithString:temp];
    return  ourl;
}
@end;
