//
//  EntityPersonInfo.h
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-4.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDObject.h"

@interface EntityPersonInfo : NSObject<ProtocolEntity>
@property (strong, nonatomic) NSNumber *personId;
@property (strong, nonatomic) NSNumber *personCode;
@property (strong, nonatomic) NSString *personName;
@property (strong, nonatomic) NSString *personSex;
@property (strong, nonatomic) NSString *personImageUrl;
@property (strong, nonatomic) UIImage *personImage;
@property (strong, nonatomic) NSDictionary *jsonData;
@end
