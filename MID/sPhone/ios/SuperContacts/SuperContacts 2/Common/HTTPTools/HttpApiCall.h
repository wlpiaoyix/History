//
//  HttpApiCall.h
//  test02
//
//  Created by qqpiaoyi on 13-10-16.
//  Copyright (c) 2013年 qqpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
@interface HttpApiCall : NSObject

+(ASIFormDataRequest*) requestCallPOST:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo;
+(ASIFormDataRequest*) requestCallPOST:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo OutTime:(int) outTime;
+(ASIFormDataRequest*) requestCallPUT:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo OutTime:(int) outTime;
+(ASIFormDataRequest*) requestCallPUT:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo;
+(ASIFormDataRequest*) requestCallGET:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo;
+(ASIFormDataRequest*) requestCallDELET:(NSString*) _url Logo:(NSString*) _logo;
+(ASIFormDataRequest*) requestCallPOST:(NSString*) _url ParamsData:(NSString *)_params Logo:(NSString*) _logo;
+(ASIFormDataRequest*) requestCallUpload:(NSString*) _url Params:(NSDictionary*) _params Logo:(NSString*) _logo OutTime:(double)outTime;
@end
