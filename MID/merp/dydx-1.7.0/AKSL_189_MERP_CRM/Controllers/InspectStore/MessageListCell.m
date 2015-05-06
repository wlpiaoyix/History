
//
//  MessageListCell.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-3-27.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"MessageListCell" owner:self options:Nil]  firstObject];
        [self.imgAttachDir setHidden:YES];
        self.imgHead.layer.cornerRadius = 25;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDate:(NSString *)userName UserPortraint:(NSString *)userPortraint Content:(NSString *)content PicturePath :(NSString *)picturePath MsgType:(NSInteger)msgType CreateTime:(NSDate *)date
{
 
    
    self.lblTime.text = [date getFriendlyTime:YES];
        if(msgType == 0 && content != NULL)
    {
        [self.lblContent setHidden:NO];
        [self.imgAttachDir setHidden:YES];
        self.lblName.text = userName;
        self.lblContent.text = content;
        self.imgHead.imageUrl = userPortraint;
        self.imgPlace.imageUrl = picturePath;
 
        }
    else if (msgType == 1)
    {
        [self.imgAttachDir setHidden:NO];
        [self.lblContent setHidden:YES];
        self.lblName.text = userName;
        self.imgHead.imageUrl = userPortraint;
        self.imgPlace.imageUrl = picturePath;
        self.imgAttachDir.image = [UIImage imageNamed:@"icon_g_like_zan.png"];
        
    }
}

@end
