//
//  UseCell.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-4-18.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UseCell.h"

@implementation UseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setData:(NSDictionary *)dic
{
    if ([[dic objectForKey:@"alert"] isEqualToString:@"有值"]) {
        self.lblPrompt.hidden = YES;
        NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"payment"]];
        self.lblMoney.text = str;
        self.imgMoney.image = [UIImage imageNamed:@"flowmanager_returnmoney.png"];
    }
    else
    {
        self.lblPrompt.text = @"请在次月查询";
        self.lblMoney.hidden = YES;
        self.imgMoney.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
