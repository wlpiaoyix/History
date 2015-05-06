//
//  TelephonyCenterListner.h
//  SuperContacts
//
//  Created by wlpiaoyi on 13-12-31.
//  Copyright (c) 2013年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol TelephonyListnerOpt
@required -(void) hasCallComing:(NSString*) phoneNum;
@required -(void) hasCallOuting:(NSString*) phoneNum;
@required -(void) hasCallDack:(NSString*) phoneNum;
@required -(void) hasCallGeting:(NSString*) phoneNum;
@end
@interface TelephonyCenterListner : NSObject
+(id) startExcu;
+(void) setTLOInterface:(id<TelephonyListnerOpt>) _tlo_;
@end
