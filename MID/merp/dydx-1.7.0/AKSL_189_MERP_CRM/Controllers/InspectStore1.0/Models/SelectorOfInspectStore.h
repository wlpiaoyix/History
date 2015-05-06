//
//  SelectorOfInspectStore.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/17.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectorOfInspectStore : NSObject

@property (assign) BOOL isCanMove;//
@property (assign) BOOL isCanDelete;

@property (strong,nonatomic) NSString * title;
@property (assign) int tagId;
@property (assign) int countOfRemind;
@property (assign) int type;
@property (assign) int countOfLike;
@property (assign) int countOfComment;
@property (strong,nonatomic) NSString * imageUrl;
@property (strong,nonatomic) NSString * dateSelect;
@property (assign) int sortType;
@property (assign) int selectType;
@property (strong,nonatomic) NSString *userCode;

@property (assign) BOOL isMoveing;
@property (strong,nonatomic) NSString *condition;
+(NSMutableArray *)setjson:(NSArray *)array;

@end
