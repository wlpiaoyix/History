//
//  main.m
//  aa
//
//  Created by wlpiaoyi on 15/4/11.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "kkk.h"
#import "Octest.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        double currentTime = CFAbsoluteTimeGetCurrent();
        long long int sum = [Octest funcarray];
        currentTime = CFAbsoluteTimeGetCurrent() - currentTime;
        NSLog(@"object-c:%f,%lli",currentTime,sum);
        
    }
    return 0;
}


