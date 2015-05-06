//
//  DetailedSellInfoView.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-9.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKUIChartView.h"
#import "BaseViewController.h"

@interface SingerProductCell : UITableViewCell{
    
}
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelValueText;
@end

@interface DetailedSellInfoView : UIView<MBProgressHUDDelegate,AKUIChartViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    AKUIChartView *chartview;
    UITableView *tabelview;
    NSMutableArray *listDataForChart;
    NSMutableArray *listDataForTable;
    NSString * typeString;
    bool isload;
    BaseViewController * base;
    MBProgressHUD* myMBProgressHUD;
   
}
@property (retain,nonatomic) NSString *UserCode;
@property (assign,nonatomic) int type;
-(void)setBase:(BaseViewController *)baseview;
@end
