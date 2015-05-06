//
//  FlowSubOrgViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SwitchSelected.h"

@interface FlowSubOrgViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{
    NSString * urlForQueryFlow;
    NSMutableArray * listForTrafficPackData;
    NSArray * listForTrafficAppData;
    NSDictionary * listForFirstDayActiveData;
    bool isQueryRest;
    SwitchSelected * startDate;
    SwitchSelected * endDate;
}
@property (strong, nonatomic) IBOutlet UIView *viewForTitleLiuliangbao;
@property (strong, nonatomic) IBOutlet UIView *viewForTitleLiuliangApp;
@property (strong, nonatomic) IBOutlet UIView *viewForTitleShourijihuo;
@property (weak, nonatomic) IBOutlet UITableView *dataTableView;
@property (weak, nonatomic) IBOutlet UILabel *textCountForPeple;
@property (weak, nonatomic) IBOutlet UILabel *textTitleTop;
@property (weak, nonatomic) IBOutlet UIView *dateSelectView;
@property (weak, nonatomic) IBOutlet UILabel *textSetTitle;
@property (weak, nonatomic) IBOutlet UIButton *ButForBack;
@property (weak, nonatomic) IBOutlet UILabel *textForPhoneNum;
@property (strong,nonatomic) NSString * phoneNumStr;
@property (assign) bool isSingerPhoneNum;
-(void)setUrlForQuery:(NSString *)url;
- (IBAction)selectDateClick:(id)sender;
@end
