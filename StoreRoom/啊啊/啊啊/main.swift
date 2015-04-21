//
//  main.swift
//  啊啊
//
//  Created by wlpiaoyi on 15/4/11.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

import Foundation

func forcircle()->Int64{
    var sum:Int64 = 1;
    var value:Int64 = 1;
    for var i = 0; i < 99999999; i++ {
        sum = sum << 1;
        if(sum > (value << 61)){
            sum = 1;
        }
    }
    return Int64(sum);
}
func forarray()->Int{
    var array = NSMutableArray();
    var value = NSNumber(int: 1);
    for var i = 0; i < 9999999; i++ {
        array.addObject(value);
    }
    return array.count;
}
func fornew()->Int32{
    var value = NSNumber(int: 0);
//    for var i = Int32(0); i < 9999999; i++ {
//        value = NSNumber(int: i);
//    }
    var bb:Dictionary<NSObject,NSNumber> = ["key1":1,"key2":2];
    var keys:[NSObject] = bb.keys.array;
    var values:[NSNumber] = bb.values.array;
    var index = 0;
    for a in keys {
        var value = values[index];
        NSLog("key:%@ value:%d", a,value.integerValue);
        index++;
    }
    
    var kk:NSMutableDictionary = NSMutableDictionary();
    return value.intValue;
}

func excu(){
    println("Hello, World!")
    var currentTime:Double = CFAbsoluteTimeGetCurrent();
    //funcTimer();
    NSLog("%f,%lli", currentTime,fornew());
    currentTime = CFAbsoluteTimeGetCurrent() - currentTime;
    NSLog("swift:%f", currentTime)
}
excu();


