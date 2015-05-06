//
//  dydxTrafficManageCell.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-8-6.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "dydxTrafficManageCell.h"

@implementation dydxTrafficManageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setdata:(NSDictionary *)datadic
{
    if (datadic) {
        self.lblName.text = [datadic objectForKey:@"name"];
        self.lblPakageCount.text = [[datadic objectForKey:@"pakageCount"] stringValue];
        self.lblPakagePayment.text = [[datadic objectForKey:@"pakagePayment"] stringValue];
        self.lblAppCount.text = [[datadic objectForKey:@"appCount"] stringValue];
        self.lblAppPayment.text = [[datadic objectForKey:@"appPayment"] stringValue];
        self.lblUserCount.text = [datadic objectForKey:@"userCount"];
    }
    self.mainView.layer.borderColor = [UIColor colorWithRed:0.906 green:0.925 blue:0.945 alpha:1].CGColor;
    self.mainView.layer.borderWidth = 0.5;
    self.mainView.layer.cornerRadius = 4;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
