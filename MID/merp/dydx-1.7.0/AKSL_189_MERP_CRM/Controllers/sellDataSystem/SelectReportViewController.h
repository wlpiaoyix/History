//
//  SelectReportViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-10.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#define  DEF_tdType  @"selectReport_def_tdType"
#define  DEF_products @"selectReport_def_products"
#define  DEF_Area  @"selectReport_def_Area"
#define  DEF_Area_Fzz   @"selectReport_def_Area_Fzz"
#define  DEF_Area_TdName  @"selectReport_def_Area_TdName"

@interface SelectReportViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *dateSelectView;
@property (weak, nonatomic) IBOutlet UIView *tdSelectView;
@property (weak, nonatomic) IBOutlet UIView *areaSelectView;
@property (weak, nonatomic) IBOutlet UIButton *butForGetTable;
@property (weak, nonatomic) IBOutlet UIButton *butForGetText;
@property (strong,nonatomic) NSDate * queryDate;
- (IBAction)selectButClick:(id)sender;

- (IBAction)selectDateClick:(id)sender;
@property (assign,nonatomic) bool isTableData; 

@end
