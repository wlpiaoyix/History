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
static int defaultOutTimeForReqeust = 40;
static HashSHA256 *hashSh = false;
@implementation HttpApiCall

+(ASIFormDataRequest*) requestCallPOST:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo{
    return [HttpApiCall requestCallPOST:_url Params:_params Logo:_logo OutTime:defaultOutTimeForReqeust];
}
+(ASIFormDataRequest*) requestCallPOST:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo OutTime:(int) _outTime{
    NSURL *url = [HttpApiCall createURL:_url Params:nil Logo:_logo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if (_params!=nil){
        const char* str = [[_params JSONRepresentation] UTF8String];
        NSMutableData *data = [[NSMutableData alloc]initWithBytes:(str) length:strlen(str)];
        [request setPostBody:data];
    }
    [request setTimeOutSeconds:_outTime];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:HTTP_API_POST];
    return request;
}

+(ASIFormDataRequest*) requestCallPOST:(NSString*) _url ParamsData:(NSString *)_params Logo:(NSString*) _logo{
    NSURL *url = [HttpApiCall createURL:_url Params:nil Logo:_logo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if (_params!=nil){
        const char* str = [_params UTF8String];
        NSMutableData *data = [[NSMutableData alloc]initWithBytes:(str) length:strlen(str)];
        [request setPostBody:data];
    }
    [request setTimeOutSeconds:defaultOutTimeForReqeust];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:HTTP_API_POST];
    return request;
}
+(ASIFormDataRequest*) requestCallPUT:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo{
    return [HttpApiCall requestCallPUT:_url Params:_params Logo:_logo OutTime:defaultOutTimeForReqeust];
}
+(ASIFormDataRequest*) requestCallPUT:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo OutTime:(int) _outTime{
    NSURL *url = [HttpApiCall createURL:_url Params:nil Logo:_logo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if (_params!=nil){
        const char* str = [[_params JSONRepresentation] UTF8String];
        NSMutableData *data = [[NSMutableData alloc]initWithBytes:(str) length:strlen(str)];
        [request setPostBody:data];
    }
    [request setTimeOutSeconds:_outTime];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:HTTP_API_PUT];
    return request;
}
+(ASIFormDataRequest*) requestCallGET:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo{
    NSURL *url = [HttpApiCall createURL:_url Params:_params Logo:_logo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:defaultOutTimeForReqeust];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:HTTP_API_GET];
    return request;
}
+(ASIFormDataRequest*) requestCallDELET:(NSString*) _url Logo:(NSString*) _logo{
    NSURL *url = [HttpApiCall createURL:_url Params:nil Logo:_logo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:defaultOutTimeForReqeust];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:HTTP_API_DELETE];
    return request;
}
+(ASIFormDataRequest*) requestCallUpload:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo OutTime:(double)outTime{
    NSURL *url = [HttpApiCall createFileURL:_url Params:nil Logo:_logo];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if (_params!=nil){
        const char* str = [[_params JSONRepresentation] UTF8String];
        NSMutableData *data = [[NSMutableData alloc]initWithBytes:(str) length:strlen(str)];
        [request setPostBody:data];
    }
    [request setTimeOutSeconds:outTime];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setRequestMethod:HTTP_API_POST];
    return request;
}
/**
 构造一个Base URL
 */
+(NSURL*) createURL:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo{
    @synchronized(hashSh){
        if(!hashSh){
            hashSh = HTTP_API_HashSHA;
        }
    }
    //中文字符转换处理
    _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *code = (NSString*)[ConfigManage getConfig:HTTP_API_PCODE];//@"10000101";//
    NSString *password = (NSString*)[ConfigManage getConfig:STR_USER_PASSWORD];//@"wewq";//
    NSString *ak = [hashSh hashedValue:password andData:[_url stringByAppendingString:code]];
    NSString *url = [[[[[[[[[[[[
                                _url stringByAppendingString:@"?"]
                               stringByAppendingString:HTTP_API_PCODE]
                              stringByAppendingString:@"="]
                             stringByAppendingString:code]
                            stringByAppendingString:@"&" ]
                           stringByAppendingString:HTTP_API_PAK]
                          stringByAppendingString:@"="]
                         stringByAppendingString:ak]
                        stringByAppendingString:@"&" ]
                       stringByAppendingString:HTTP_API_PLOGO]
                      stringByAppendingString:@"="]
                     stringByAppendingString:_logo];
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
    url=API_BASE_URL(url);
    NSLog(@"HTTP访问：url:%@",url);
    NSURL *ourl = [NSURL URLWithString:url];
    return  ourl;
}
/**
 构造一个FileURL
 */
+(NSURL*) createFileURL:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo{
    @synchronized(hashSh){
        if(!hashSh){
            hashSh = HTTP_API_HashSHA;
        }
    }
    //中文字符转换处理
    _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *code = (NSString*)[ConfigManage getConfig:HTTP_API_PCODE];//@"10000101";//
    NSString *password = (NSString*)[ConfigManage getConfig:STR_USER_PASSWORD];//@"wewq";//
    NSString *ak = [hashSh hashedValue:password andData:[_url stringByAppendingString:code]];
    NSString *url = [[[[[[[[[[[[
                                _url stringByAppendingString:@"?"]
                               stringByAppendingString:HTTP_API_PCODE]
                              stringByAppendingString:@"="]
                             stringByAppendingString:code]
                            stringByAppendingString:@"&" ]
                           stringByAppendingString:HTTP_API_PAK]
                          stringByAppendingString:@"="]
                         stringByAppendingString:ak]
                        stringByAppendingString:@"&" ]
                       stringByAppendingString:HTTP_API_PLOGO]
                      stringByAppendingString:@"="]
                     stringByAppendingString:_logo];
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
    url=API_FILE_URL(url);
    NSLog(@"HTTP访问：url:%@",url);
    NSURL *ourl = [NSURL URLWithString:url];
    return  ourl;
}
@end;
