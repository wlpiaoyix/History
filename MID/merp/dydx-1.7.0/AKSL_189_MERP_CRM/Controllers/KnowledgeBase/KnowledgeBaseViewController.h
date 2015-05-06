//
//  KnowledgeBaseViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-15.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface KnowledgeBaseViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate>{
    NSInteger isLoadStart;
    NSInteger selectedIndex; 
    NSMutableArray * listForSellData;
    NSMutableArray * listForSellPower;
    NSMutableArray * listForWorkKnow;
    NSMutableArray * listForFlowManage;
    NSMutableArray * listForSearch;
    LoginUser * loginuser;
}
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UIButton *topButton;
@property (weak, nonatomic) IBOutlet UIScrollView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *selectBackgroundLabel;
@property (weak, nonatomic) IBOutlet UIButton *butToAdd;
- (IBAction)tabButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
+(KnowledgeBaseViewController *)getKnowledgeBase;
+(void)newKnowledgeBase;
@end
