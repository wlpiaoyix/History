//
//  BarTools.h
//  test02
//
//  Created by qqpiaoyi on 13-10-18.
//  Copyright (c) 2013年 qqpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarTools : UIView
/**
 {
    topInfo:{
        title:tille,
        value:10
        date:2013-01-16
    }
    viewInfo:{
        maxValue:100;
        data:[
            {id:1,value:20,info:xx},
            {id:1,value:50,info:xx},
            {id:1,value:80,info:xx},
            {id:1,value:60,info:xx}
        ]
    }
 
 }
 */
+(BarTools*) inits:(NSDictionary*) json x:(int) x y:(int) y w:(int) w h:(int) h;
-(void) createDy;
@end
