//
//  MyScheduleViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-10-24.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "BaseViewController.h"
#import "VRGCalendarView.h"
@interface MyScheduleViewController : BaseViewController<VRGCalendarViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    bool nibsRegistered;
}
@property (retain, nonatomic) IBOutlet UITableView *listViewForDateli;
@property (retain, nonatomic) VRGCalendarView * calendarView;

- (IBAction)topbarbutton:(id)sender;
-(void) getScheduleByMonth:(NSDate*) startDate EndDate:(NSDate*) endDate;

@end
