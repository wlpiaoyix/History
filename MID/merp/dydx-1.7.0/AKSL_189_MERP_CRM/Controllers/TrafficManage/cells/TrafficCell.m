//
//  TrafficCell.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-4-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TrafficCell.h"
#import "SwitchSelected.h"
#import "TrafficReportController.h"

@implementation TrafficCell
{
    NSMutableArray * selectList;
    UIView * allTextView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.btnBackgroundImageState = 0;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(NSMutableArray *)array
{
    if (allTextView) {
        [allTextView removeFromSuperview];
    }
    
    
    int count;
    selectList = [NSMutableArray new];
    if([array count] %3 == 0)
    {
        count = [array count]/3;
    }
    else
    {
        count = [array count]/3+1;
    }
        for(int i=0; i< count; i++) {
            for(int j=0; j<3; j++) {
                if ((i*3+j)<[array count]) {
                    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10+98*j,10+35*i , 95, 25)];
                    [imgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_report_img"]]];
                    
                    SwitchSelected * obj = [array objectAtIndex:i*3+j];
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                    btn.frame = CGRectMake(10+98*j,10+35*i , 95, 25);
                    NSString *title = obj.value;
                    
                    btn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [btn setTitle:title forState:0];
                    obj.isSelected = NO;
                    if (obj.isSelf) {
                        obj.isSelected = YES;
                        [btn setBackgroundImage:[UIImage imageNamed:@"btn_report_update.png"] forState:UIControlStateNormal];
                    }
                    else if (obj.isReported) {
                        [btn setUserInteractionEnabled:NO];
                        [btn setBackgroundImage:[UIImage imageNamed:@"btn_report_update.png"] forState:UIControlStateNormal];
                        imgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_main.png"]];
                    }
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    btn.tag = i*3+j;
                    [selectList addObject:obj];
                    [btn addTarget:self action:@selector(updateBtn:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:imgView];
                    [self addSubview:btn];
                }
                else
                {
                    break;
                }
            }
        }
}
-(void)updateBtn:(UIButton *)btn
{
    SwitchSelected * obj = selectList[btn.tag];
    obj.isSelected = !obj.isSelected;
    if(obj.isSelected)
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_report_update.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }

}
-(void)setReportdetailData:(NSMutableArray *)arrayx
{
    if (allTextView) {
        [allTextView removeFromSuperview];
    }
    allTextView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, arrayx.count*13)];
    for (int i = 0; i<[arrayx count]; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 13*i, 250, 13)];
        lbl.textColor = [UIColor blackColor];
        lbl.font = [UIFont systemFontOfSize:11];
        lbl.text = [[[[[arrayx[i] objectForKey:@"userName"] stringByAppendingString:@"("] stringByAppendingString:[arrayx[i] objectForKey:@"userPhone"]] stringByAppendingString:@"):"] stringByAppendingString:[arrayx[i] objectForKey:@"productName"]];
        lbl.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0 alpha:0.4];
        [allTextView addSubview:lbl];

    }
    [self addSubview:allTextView];
    
}
@end
