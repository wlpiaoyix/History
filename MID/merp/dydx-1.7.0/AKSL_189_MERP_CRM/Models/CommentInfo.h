//
//  CommentInfo.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-3-27.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInfo : NSObject

@property (assign) CGFloat higehtForConent;
@property (strong,nonatomic) NSString * Conents;
@property  (assign) long CommentId;
@property (strong,nonatomic) NSString * fromUserName;
@property (strong,nonatomic) NSString * toUserName;
@property (strong,nonatomic) NSString * timeString;
@property (strong,nonatomic) NSString * FromUserImageUrl;
@property (assign) bool isHaveToUser;
@property (assign) long fromUserId;
@property (assign) bool isMyself;

+(CommentInfo *)getCommentInfoNew:(NSDictionary *)dic;
+(CommentInfo *)getCommentInfo:(NSDictionary *)dic;
+(CommentInfo *)getCommentInfo:(long)idForData Content:(NSString *)content ToUserName:(NSString *)touserName;
@end
