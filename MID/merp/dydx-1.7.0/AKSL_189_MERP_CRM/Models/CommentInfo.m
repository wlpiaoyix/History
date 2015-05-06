//
//  CommentInfo.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-3-27.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "CommentInfo.h"

@implementation CommentInfo


+(CommentInfo *)getCommentInfo:(long)idForData Content:(NSString *)content ToUserName:(NSString *)touserName{
    CommentInfo * info = [CommentInfo new];
    info.Conents = content;
    info.fromUserName = [ConfigManage getLoginUser].username;
    info.fromUserId = [ConfigManage getLoginUser].userDataId;
    info.FromUserImageUrl = [ConfigManage getLoginUser].headerImageUrl;
    info.isMyself = YES;
    info.isHaveToUser = NO;
    if (touserName && touserName.length > 0) {
        info.isHaveToUser = YES;
        info.toUserName = touserName;
    }
    info.timeString =[NSDate dateFormateDate:[NSDate new] FormatePattern:@"HH:mm"];
    
    info.CommentId = idForData;
    
    CGFloat hieght = 34;
    hieght += [info.Conents sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(220, 1000)].height;
    info.higehtForConent = hieght>=45?hieght:45;
    return info;

}
+(CommentInfo *)getCommentInfoNew:(NSDictionary *)dic{
    CommentInfo * info = [CommentInfo new];
    info.Conents = [dic valueForKey:@"content"];
    info.fromUserName = [[dic valueForKey:@"fromUser"]valueForKey:@"userName"];
    info.FromUserImageUrl =API_IMAGE_URL_GET2([[dic valueForKey:@"fromUser"]valueForKey:@"portrait"]);
    long formUserId = [[[dic valueForKey:@"fromUser"]valueForKey:@"id"]longValue];
    info.isMyself =[ConfigManage getLoginUser].userDataId == formUserId;
    info.fromUserId = formUserId;
    NSDictionary * touser = [dic valueForKey:@"toUser"];
    info.isHaveToUser = NO;
    if (touser) {
        info.toUserName =[touser valueForKey:@"userName"];
        info.isHaveToUser = YES;
    }
    NSDate * date = [NSDate dateFormateString:[dic objectForKey:@"createTime"] FormatePattern:nil];
    info.timeString =[NSDate dateFormateDate:date FormatePattern:@"HH:mm"];
    
    info.CommentId = [[dic valueForKey:@"id"]longValue];
    
    CGFloat hieght = 34;
    hieght += [info.Conents sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(220, 1000)].height;
    info.higehtForConent = hieght>=55?hieght:55;
    return info;

}
+(CommentInfo *)getCommentInfo:(NSDictionary *)dic{
    CommentInfo * info = [CommentInfo new];
    info.Conents = [dic valueForKey:@"content"];
    info.fromUserName = [[dic valueForKey:@"fromUser"]valueForKey:@"userName"];
    info.FromUserImageUrl =API_IMAGE_URL_GET2([[dic valueForKey:@"fromUser"]valueForKey:@"userPortrait"]);
    long formUserId = [[[dic valueForKey:@"fromUser"]valueForKey:@"id"]longValue];
    info.isMyself =[ConfigManage getLoginUser].userDataId == formUserId;
    info.fromUserId = formUserId;
    NSDictionary * touser = [dic valueForKey:@"toUser"];
    info.isHaveToUser = NO;
    if (touser) {
      info.toUserName =[touser valueForKey:@"userName"];
        info.isHaveToUser = YES;
    }
    NSDate * date = [NSDate dateFormateString:[dic objectForKey:@"createTime"] FormatePattern:nil];
    info.timeString =[NSDate dateFormateDate:date FormatePattern:@"HH:mm"];
    
    info.CommentId = [[dic valueForKey:@"id"]longValue];
    
    CGFloat hieght = 34;
    hieght += [info.Conents sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(220, 1000)].height;
    info.higehtForConent = hieght>=55?hieght:55;
    return info;
}

@end
