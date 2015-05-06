//
//  SystemSetsAlertCell.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-5.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemSetsAlertCell : UITableViewCell
- (IBAction)valueChanges:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lableText;
@property (strong,nonatomic) NSIndexPath *indexPath;
-(void) setIsNo:(bool) isNo;
@end
