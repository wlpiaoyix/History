//
//  KnowledgeDataCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-16.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "EMAsyncImageView.h"
@interface KnowledgeDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *textContent;
@property (weak, nonatomic) IBOutlet UILabel *textTitle; 
@property (weak, nonatomic) IBOutlet UILabel *textDate;
@property (weak, nonatomic) IBOutlet UILabel *textReadNum;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *imageContent;
@property (weak, nonatomic) IBOutlet UIView *mainView;
-(void)setData:(NSString *)title ImageUrl:(NSString *)url Content:(NSString *)content Date:(NSDate *)date readNum:(int)readnum;
@end
