//
//  SellSystemViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-6.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "BaseViewController.h"

@interface SellSystemViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *MainPage;
@property (weak, nonatomic) IBOutlet UIView *commitView;
@property (weak, nonatomic) IBOutlet UILabel *TitleName;
@property (weak, nonatomic) IBOutlet UIButton *buttonForSum;
@property (weak, nonatomic) IBOutlet UITableView *CommitList;
@property (weak, nonatomic) IBOutlet UIButton *toButtonLeft;
@property (assign,nonatomic) bool isSelectPage;
@property (assign,nonatomic) long orgId;

-(void)toNextPage:(long)NextOrgId Title:(NSString *)title;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isDataTable:(bool)istable SelectDic:(NSDictionary *)selectdic isFristPage:(bool)isfrist;
@end
