//
//  MainPageViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-21.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EMAsyncImageView.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"


@interface MainPageViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    bool nibsRegistered;
    NSMutableArray * notelist;
    NSMutableArray * mydaylistData;
    bool commitDataViewIsHide;
}
@property (weak, nonatomic) IBOutlet UIButton *toXiaoShouZC;
@property (weak, nonatomic) IBOutlet UIPageControl *pageContrl;
- (IBAction)toXiaoShouDataView:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollImageView;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *userHeaderImg;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progress_label_bg;
@property (weak, nonatomic) IBOutlet UILabel *progress_label;
@property (weak, nonatomic) IBOutlet UILabel *progress_label_all;
@property (weak, nonatomic) IBOutlet UIView *dataForSell;
@property (weak, nonatomic) IBOutlet UITableView *myDayli;
@property (weak, nonatomic) IBOutlet UILabel *titleMyDayli;
@property (weak, nonatomic) IBOutlet UIImageView *titleMyDayliImage;
@property (weak, nonatomic) IBOutlet UILabel *lableUserName;
@property (weak, nonatomic) IBOutlet UILabel *lableProf;
@property (weak, nonatomic) IBOutlet UILabel *rankSet;
  
+(id)getMainPage;
+(void)NewMainPage;
@end
