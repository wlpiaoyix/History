//
//  SystemSetsMergeUserCell.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-26.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetsMergeUserCell.h"
#import "ConfigManage.h"
@implementation SystemSetsMergeUserCell

+(id)init{
    SystemSetsMergeUserCell *ssc = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetsMergeUserCell" owner:self options:nil] lastObject];
    return ssc;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    //==>设置样式
    self.imageUserHead.layer.masksToBounds = YES;
    self.imageUserHead.layer.cornerRadius = self.imageUserHead.frame.size.width/2;
    [self cornerRadius:self.viewUserName];
    [self cornerRadius:self.viewUserPhone];
    [self cornerRadius:self.viewUserSex];
    [self cornerRadius:self.viewPost];
    [self cornerRadius:self.viewLocation];
    [self.lableIfEditPhoto setHidden:YES];
    //<==
    //==>用户数据
    LoginUser *u = [ConfigManage getLoginUser];
    if(u.headerImageUrl&&u.headerImageUrl!=nil){
       self.imageUserHead.imageUrl = nil;
        self.imageUserHead.imageUrl = u.headerImageUrl;}
    self.textFieldUserName.text = u.username;
    self.textFieldUserPhone.text = u.mobilePhone;
    self.lableUserSex.text = u.sexName;
    self.lableUserCode.text = u.userId;
    self.lablePost.text = u.type;
    self.lableLocation.text = [Organization getInstance].orgFullName;
    //<==
    //==>
    self.textFieldUserName.tag = 912301;
    self.textFieldUserPhone.tag = 912302;
    self.lableUserSex.tag = 912303;
    self.lableUserCode.tag = 912304;
    self.lablePost.tag = 912305;
    self.lableLocation.tag = 912306;
    self.lableIfEditPhoto.tag = 912307;
    //<==
    
}
-(void) cornerRadius:(UIView*) v{
    v.layer.masksToBounds = YES;
    v.layer.cornerRadius = 5;
    v.layer.borderWidth = 0.5;
    v.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
}

@end
