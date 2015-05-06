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
    CallBackeMethod targetMethod;
}
-(void) setTargets:(id)target;
-(void) setTargetMethods:(CallBackeMethod) _targetMethod;
+(CLLocationManagerImpl*) getInstance;
@end
