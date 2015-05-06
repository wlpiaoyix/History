//
//  InspectStoreSelectViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-27.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

#define  DEF_TDJL_inspect @"selectReport_def_TDJL_inspect"
#define  DEF_Area_inspect  @"selectReport_def_Area_inspect"
#define  DEF_Area_Fzz_inspect   @"selectReport_def_Area_Fzz_inspect"
#define  DEF_Area_TdName_inspect  @"selectReport_def_Area_TdName_inspect"

@interface InspectStoreSelectViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *butToQuery;
@property (weak, nonatomic) IBOutlet UIView *viewSelectAll;
- (IBAction)selectButClick:(id)sender;

@end
