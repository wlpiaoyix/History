//
//  HT_CheckHttp.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-3-2.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef id (^HCH_CallBackeMethod)(int status);
@interface HT_CheckHttp : NSObject{

}
//检察登录状态
+(bool) checkLogStatus;
//检察是否能ping通对应的服务器
-(void) checkOnLine:(NSString*) urlPath methodResult:(HCH_CallBackeMethod) methodResult;
@end
