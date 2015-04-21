//
//  SiginOverTimeTableViewCell.m
//  FDC
//
//  Created by NewDoone on 15/1/28.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "SiginOverTimeTableViewCell.h"

@implementation SiginOverTimeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)contactAction:(id)sender {
    self.contactBtn.selected=!self.contactBtn.selected;
    
}
- (IBAction)callAction:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumber]]];
}
- (IBAction)sendMessageAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",self.phoneNumber]]];

}

@end
