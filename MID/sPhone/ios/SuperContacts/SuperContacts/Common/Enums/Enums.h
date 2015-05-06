//
//  Enums.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-18.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol EnumsInterface
@required
+(int) enumByName:(NSString*) name;
+(int) enumByValue:(NSString*) value;
+(NSString*) nameByEnum:(int) enums;
+(NSString*) valueByEnum:(int) enums;
@optional
-(id<EnumsInterface>) enumcurt;
@end
