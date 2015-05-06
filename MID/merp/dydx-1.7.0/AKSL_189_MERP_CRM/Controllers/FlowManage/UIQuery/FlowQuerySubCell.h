//
//  FlowQuerySubCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowQuerySubCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textUserName;
@property (weak, nonatomic) IBOutlet UILabel *textLiuliangbao;
@property (weak, nonatomic) IBOutlet UILabel *textLiuliangApp;
@property (weak, nonatomic) IBOutlet UILabel *textShouriJihuo;
@property (weak, nonatomic) IBOutlet UILabel *textPaymatCount;
@property (weak, nonatomic) IBOutlet UILabel *textDate;

-(void)setData:(NSDictionary *)dataDic;
@end
