//
//  SaleCell.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-4-18.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "SaleCell.h"

@implementation SaleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setButton:(NSString *)title
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(7,7 , 95, 25)];
    [imgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_report_img"]]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7,7 , 95, 25);
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_report_update.png"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:title forState:0];
    [btn setUserInteractionEnabled:NO];
    [self addSubview:imgView];
    [self addSubview:btn];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
