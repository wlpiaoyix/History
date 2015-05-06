//
//  MonthReportedView.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-18.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthReportedView : UIView

@property (assign) int month;
@property (assign) double numForReport;

-(void)replaceData;

@end
