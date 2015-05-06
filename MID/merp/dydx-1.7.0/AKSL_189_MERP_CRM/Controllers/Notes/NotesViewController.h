//
//  NotesViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-25.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "BaseViewController.h"
#import "EMAsyncImageView.h"
#import "AKUIChartView.h"
//#import <CoreLocation/CoreLocation.h>

@interface NotesViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AKUIChartViewDelegate>{
//    CLLocationManager * locationManager;
   @private bool nibsRegistered;
}
@property (strong, nonatomic) IBOutlet UIButton *buttonConfirm;
@property (retain, nonatomic) IBOutlet UITableView *tableViewNotes;
- (IBAction)topButClick:(id)sender;
 
@end
