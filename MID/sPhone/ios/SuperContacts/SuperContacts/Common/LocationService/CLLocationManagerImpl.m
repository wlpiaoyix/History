//
//  CLLocationManagerImpl.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-18.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "CLLocationManagerImpl.h"
static CLLocationManagerImpl *xStaticCLLocationManagerImpl;
@interface CLLocationManagerImpl()
@property (strong, nonatomic)CLLocationManager *manager;
@property (strong, nonatomic)id target;
@property bool stopUpdateFlag;
@property bool stopThreadFlag;
@property NSLock *lock;
@end
@implementation CLLocationManagerImpl

+(CLLocationManagerImpl*) getInstance{
    @synchronized(xStaticCLLocationManagerImpl){
        if(!xStaticCLLocationManagerImpl){
            xStaticCLLocationManagerImpl = [[CLLocationManagerImpl alloc]init];
            if ([CLLocationManager locationServicesEnabled]) {
                xStaticCLLocationManagerImpl.manager =[[CLLocationManager alloc]init];
                xStaticCLLocationManagerImpl.manager.distanceFilter = 100.0f;
                xStaticCLLocationManagerImpl.manager.desiredAccuracy = kCLLocationAccuracyBest;
                xStaticCLLocationManagerImpl.manager.delegate = xStaticCLLocationManagerImpl;
                xStaticCLLocationManagerImpl.lock = [[NSLock alloc]init];
            }else{
                COMMON_SHOWALERT(@"无法启动定位功能！");
            }
        }
    }
    if(xStaticCLLocationManagerImpl.manager){
        [xStaticCLLocationManagerImpl.manager stopUpdatingLocation];
        [xStaticCLLocationManagerImpl.manager startUpdatingLocation];
//        NSThread *t = [[NSThread alloc]initWithTarget:xStaticCLLocationManagerImpl selector:@selector(forStopUpdating) object:nil];
//        [t start];
    }
    return  xStaticCLLocationManagerImpl;
}
-(void) forStopUpdating{
    unsigned int index = 0;
    self.stopThreadFlag = YES;
    @try {
        [self.lock lock];
        self.stopThreadFlag = NO;
        while (!self.stopUpdateFlag) {
            [NSThread sleepForTimeInterval:1.0f];
            if(self.stopThreadFlag){
                return;
            }
            NSLog(@"%lu======%d",(unsigned long)[NSThread currentThread].hash,index);
            if (index>30) {
                break;
            }
            index++;
        }
        NSLog(@"%lu====== stopUpdatingLocation",(unsigned long)[NSThread currentThread].hash);
        [self.manager stopUpdatingLocation];
    }
    @finally {
        [self.lock unlock];
        NSLog(@"%lu====== unlock",(unsigned long)[NSThread currentThread].hash);
    }
}
/*
 *  locationManager:didUpdateLocations:
 *
 *  Discussion:
 *    Invoked when new locations are available.  Required for delivery of
 *    deferred locations.  If implemented, updates will
 *    not be delivered to locationManager:didUpdateToLocation:fromLocation:
 *
 *    locations is an array of CLLocation objects in chronological order.
 */
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    if(targetMethod){
        targetMethod(self.target,manager,newLocation,oldLocation);
    }
//    [manager stopUpdatingLocation];
}

-(void) setTargets:(id)target{
    self.target = target;
}
-(void) setTargetMethods:(CallBackeMethod) _targetMethod{
    targetMethod = _targetMethod;
}
@end
