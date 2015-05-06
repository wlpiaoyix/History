//
//  LikeCommentTableViewCell.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-3-31.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LikeCommentTableViewCell : UITableViewCell 

@property (weak, nonatomic) IBOutlet UILabel *textForData;
-(void)setData:(NSString *)dataString;
@end
