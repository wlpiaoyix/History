//
//  TourRoundAddTagsViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-6-25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


typedef void (^RetureMethod)(NSDictionary *tagDic);
@interface TourRoundAddTagsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    RetureMethod _returnMethod;
}

@property (weak, nonatomic) IBOutlet UITableView *dataTable;
@property (weak, nonatomic) IBOutlet UILabel *lblStartDay;
@property (weak, nonatomic) IBOutlet UILabel *lblEndDay;
@property (weak, nonatomic) IBOutlet UILabel *lblStartYear;
@property (weak, nonatomic) IBOutlet UILabel *lblEndYear;

@property (weak, nonatomic) IBOutlet UITextField *textContent;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
- (IBAction)btnQingchu:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *_btnQingchu;

-(void) setRetureMethods:(RetureMethod) returnMethod;
- (IBAction)back:(id)sender;
- (IBAction)Complete:(id)sender;
- (IBAction)setDate:(id)sender;
@end
