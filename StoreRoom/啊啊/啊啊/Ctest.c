//
//  Ctest.c
//  啊啊
//
//  Created by wlpiaoyi on 15/4/11.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#include "Ctest.h"
#include <time.h>
long long int funcTimer(){
    unsigned long currentTime = clock();
//    printf("%lu\n",currentTime);
    long long int sum = 0;
    unsigned long long int value = 1;
    for (int i = 0; i < 99999999; i++) {
        sum = sum << 1;
        if(sum > (value << 61)){
            sum = 1;
        }

    }
    currentTime = clock() - currentTime;
    return value << 61;
//    printf("%lu\n",currentTime);
}
