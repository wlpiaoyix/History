//
//  MyTourroundViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-29.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MyTourroundViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableTourround;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

- (IBAction)back:(id)sender;
-(void)setUserCode:(NSString *)userCode;
-(void)setUserCode:(NSString *)userCode :(NSString *)name;
@end
