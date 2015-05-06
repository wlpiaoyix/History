//
//  IndividualCenterViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-8.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface IndividualCenterViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
- (IBAction)back:(id)sender;

- (IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableICData;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end
