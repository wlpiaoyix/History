//
//  TrafficCell.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-4-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrafficCell : UITableViewCell
-(void)setData:(NSMutableArray *)array;
-(void)setReportdetailData:(NSMutableArray *)arrayx;

@property (nonatomic,assign) int btnBackgroundImageState;

@end
