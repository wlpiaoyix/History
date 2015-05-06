//
//  MessageListCell.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-3-27.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
/*
 @property (nonatomic,strong) NSDate *comment_createTime;
 @property (nonatomic,strong) NSString *defaultPic;
 @property (nonatomic,strong) NSString *comment_fromUser_userName;
 @property (nonatomic,strong) NSString *comment_fromUser_userPortrait;
 @property (nonatomic,strong) NSString *comment_content;
 @property (nonatomic,strong) NSString *likes_userName;
 @property (nonatomic,strong) NSString *likes_attachDir;
 @property (nonatomic,strong) NSDate *likes_creatTime;
 */

@interface MessageListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet EMAsyncImageView *imgHead;

@property (weak, nonatomic) IBOutlet EMAsyncImageView *imgPlace;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *imgAttachDir;

-(void)setDate:(NSString *)userName UserPortraint:(NSString *)userPortraint Content:(NSString *)content PicturePath :(NSString *)picturePath MsgType:(NSInteger)msgType CreateTime:(NSDate *)date;
@end
