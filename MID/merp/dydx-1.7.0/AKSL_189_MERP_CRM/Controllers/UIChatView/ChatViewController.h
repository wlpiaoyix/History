//
//  ChatViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-11.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ChatViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
   NSString * titleString;
   NSMutableArray * listData;
}
- (IBAction)goBack:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIView *MainView;
-(void)setTitleLabelString:(NSString *)str;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end
