//
//  ReportDetailsViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-4-18.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ReportDetailsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *reportTableView;
@property (weak, nonatomic) IBOutlet UILabel *lblphoneNum;


- (IBAction)back:(id)sender;

- (IBAction)Report:(id)sender;
-(void)setPhoneNum:(NSString *)phoneNum;

@end
