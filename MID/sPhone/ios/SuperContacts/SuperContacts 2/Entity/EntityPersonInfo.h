//
//  EntityPersonInfo.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-4.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EntityPersonInfo : NSObject
@property (strong, nonatomic) NSString *personName;
@property (strong, nonatomic) UIImage *personImage;
@property (strong, nonatomic) NSString *personSex;
@property (strong, nonatomic) NSDictionary *jsonData;
@end
