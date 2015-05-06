//
//  FlowInfoSetCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowInfoSetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineshow;
@property (weak, nonatomic) IBOutlet UILabel *textType;
@property (weak, nonatomic) IBOutlet UILabel *textName;
@property (weak, nonatomic) IBOutlet UILabel *textNum;

-(void)setData:(NSDictionary *)dataDic isShowNum:(BOOL)isshownum;
@end
