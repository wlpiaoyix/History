//
//  CLLocationManagerImpl.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-18.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface CLLocationManagerImpl : NSObject<CLLocationManagerDelegate>{
    CallBakeMethod targetMethod;
}
-(void) setTargets:(id)target;
-(void) setTargetMethods:(CallBakeMethod) _targetMethod;
+(CLLocationManagerImpl*) getInstance;
@end
