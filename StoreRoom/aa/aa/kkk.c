//
//  kkk.c
//  aa
//
//  Created by wlpiaoyi on 15/4/11.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#include "kkk.h"
#include <time.h>

long functest(){
    
    unsigned long currentTime = clock();
    long long int sum = 0;
    for (int i = 0; i < 9999; i++) {
        sum += i;
    }
    currentTime = clock() - currentTime;
    return sum;
}
