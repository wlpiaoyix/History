//
//  CTM_RecordCell.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-13.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_RecordCell.h"
#import "MADE_COMMON.h"
@interface CTM_RecordCell()
@property EntityCallRecord *recorde;
@property (strong, nonatomic) IBOutlet UILabel *lableUserName;
@property (strong, nonatomic) IBOutlet UILabel *lablePhoneNum;
@property (strong, nonatomic) IBOutlet UILabel *lableActionTime;
@property (strong, nonatomic) IBOutlet EMAsyncImageView *imageUserHead;
@property (strong, nonatomic) IBOutlet UILabel *lableComing;
@property (strong, nonatomic) IBOutlet UILabel *lableAction;

@property (strong, nonatomic) IBOutlet UIImageView *imagePhoneStatu;
@property (strong, nonatomic) IBOutlet UIButton *buttonOpereation;

@end
@implementation CTM_RecordCell
+(id) getNewInstance{
    CTM_RecordCell  *ssc = [[[NSBundle mainBundle] loadNibNamed:@"CTM_RecordCell" owner:self options:nil] lastObject];
    return ssc;
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    _lableComing.layer.cornerRadius = _lableComing.frame.size.width/2;
    _lableComing.layer.masksToBounds = YES;
    _lableComing.layer.borderWidth = 2;
    _lableComing.layer.borderColor = [[UIColor grayColor]CGColor];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) setRecord:(EntityCallRecord*) record{
    _recorde = record;
    //用户
    EntityUser *user= [_recorde getEntityUser];
    _imageUserHead.image = nil;
    _lableUserName.text = _recorde.callPhoneNum;
    _lablePhoneNum.text = @"未知";
    if(user){
        if(user.dataImage){
            if([user.dataImage isKindOfClass:[NSString class]]){
                _imageUserHead.image = [UIImage imageWithContentsOfFile:[MADE_COMMON parsetAddTag:@"110" Url:(NSString*)user.dataImage]];
            }else if ([user.dataImage isKindOfClass:[NSData class]]){
                _imageUserHead.image = [[UIImage alloc]initWithData:user.dataImage];
            }
            _imageUserHead.layer.cornerRadius = _imageUserHead.frame.size.width/2;
            _imageUserHead.layer.borderWidth = 0.5;
            _imageUserHead.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
        }
        if([NSString isEnabled:user.userName]){
            //用户名
            _lableUserName.text = user.userName;
            //电话号码
            _lablePhoneNum.text = _recorde.callPhoneNum;
        }
        if (user.userId) {
            [_buttonOpereation setImage:[UIImage imageNamed:@"phone_call02.png"] forState:UIControlStateNormal];
        }else{
            [_buttonOpereation setImage:[UIImage imageNamed:@"phone_call02.png"] forState:UIControlStateNormal];
//            [_buttonOpereation setImage:[UIImage imageNamed:@"phone_add.png"] forState:UIControlStateNormal];
        }
    }else{
        [_buttonOpereation setImage:[UIImage imageNamed:@"phone_call02.png"] forState:UIControlStateNormal];
//        [_buttonOpereation setImage:[UIImage imageNamed:@"phone_add.png"] forState:UIControlStateNormal];
    }
    [_buttonOpereation addTarget:self action:@selector(clickButtonCall:) forControlEvents:UIControlEventTouchUpInside];
    //发生时间
    _lableActionTime.text = [_recorde.createTime getFriendlyTime:false];
    //记录状态;
    switch (_recorde.statusCall) {
        case 0:{
            _imagePhoneStatu.image = [UIImage imageNamed:@"phone_drak.png"];
        }
            break;
        case 1:{
            _imagePhoneStatu.image = [UIImage imageNamed:@"phone_out.png"];
        }
            break;
        case 2:{
            _imagePhoneStatu.image = [UIImage imageNamed:@"phone_come.png"];
        }
            break;
        case 3:{
            _imagePhoneStatu.image = [UIImage imageNamed:@"phone_out.png"];
        }
            break;
        default:
            _imagePhoneStatu.image = [UIImage imageNamed:@"phone_drak.png"];
            break;
    }
}
-(void) setComing:(int)times{
    [_lableComing setHidden:true];
    if(times==0)return;
    _lableComing.text = [NSString stringWithFormat:@"%d",times];
    [_lableComing setHidden:false];
}
-(void) setAction:(int)action{
    [_lableAction setHidden:true];
    if(action<2)return;
    _lableAction.text = [NSString stringWithFormat:@"(%d)",action];
    [_lableAction setHidden:false];
}
-(void) clickButtonCall:(id)sender{
    if(clickCallx)clickCallx(sender);
}

-(void) setClickCallM:(ExcueClickButton) clickCall{
    clickCallx = clickCall;
}
/**
 是否隐藏操作按钮
 */
-(void) isHiddenOptButton:(bool) flag{
    [_buttonOpereation setHidden:flag];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
