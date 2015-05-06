//
//  MainFlowInfoCell.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-18.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "MainFlowInfoCell.h"
@interface MainFlowInfoCell(){
    IBOutlet UILabel *labelPhone;
    IBOutlet UIButton *button01;
    IBOutlet UIButton *button02;
    IBOutlet UIButton *button03;
    IBOutlet UILabel *lableTime;
}
@end
@implementation MainFlowInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) setDatas:(NSString*) phone productType:(int) productTypes time:(NSString*) time{
    labelPhone.text = phone;
    lableTime.text = time;
    if(1&productTypes){
        [button01 setSelected:YES];
        [button01 setHidden:NO];
    }else{
        [button01 setSelected:NO];
        [button01 setHidden:YES];
    }
    if(2&productTypes){
        [button02 setSelected:YES];
        [button02 setHidden:NO];
    }else{
        [button02 setSelected:NO];
        [button02 setHidden:YES];
    }
    if(4&productTypes){
        [button03 setSelected:YES];
        [button03 setHidden:NO];
    }else{
        [button03 setSelected:NO];
        [button03 setHidden:YES];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
