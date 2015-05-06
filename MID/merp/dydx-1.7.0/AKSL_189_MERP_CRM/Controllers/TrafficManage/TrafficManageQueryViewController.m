//
//  TrafficManageQueryViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-22.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TrafficManageQueryViewController.h"
#import "DatePickerOperation.h"
#import "TrafficOrgInfoViewController.h"

@interface TrafficManageQueryViewController ()
{
    DatePickerOperation * datepicker;
    NSDate * startDate;
    NSDate * endDate;
}

@end

@implementation TrafficManageQueryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    datepicker = [DatePickerOperation new];
    startDate = [[NSDate new] offsetDay:0];
    endDate = [[NSDate new] offsetDay:0];
    UIButton * but;
    but =(UIButton *)[_dateSelectView viewWithTag:10016];
    [but setTitle:[NSDate dateFormateDate:startDate FormatePattern:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    but =(UIButton *)[_dateSelectView viewWithTag:10017];
    [but setTitle:[NSDate dateFormateDate:endDate FormatePattern:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setStartDate:(NSDate*)date{
    startDate = date;
}
-(void)setEndDate:(NSDate*)date{
    endDate = date;
}
- (IBAction)ObtainDate:(id)sender {
    UIButton * but = sender;
    DatePickerOperation * datepickerTemp = datepicker;
    if (but.tag==10016) {
        datepickerTemp.curDate =startDate;
        [datepickerTemp setCallBacks:^(NSDate *curDate) {
             startDate = curDate;
            [but setTitle:[NSDate dateFormateDate:curDate FormatePattern:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        }];
    }
    if (but.tag==10017) {
        datepickerTemp.curDate =endDate;
        [datepickerTemp setCallBacks:^(NSDate *curDate) {
            endDate = curDate;
            [but setTitle:[NSDate dateFormateDate:curDate FormatePattern:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        }];
    }
    
    [self.view addSubview:datepicker];
}

- (IBAction)trafficQuery:(id)sender {
    if (startDate.timeIntervalSince1970>endDate.timeIntervalSince1970) {
        showMessageBox(@"查询起始时间大于截止时间!");
        return;
    }
    NSString *startDateStr = [NSDate dateFormateDate:startDate FormatePattern:@"yyyyMMdd"];
    NSString *endDateStr = [NSDate dateFormateDate:endDate FormatePattern:@"yyyyMMdd"];
    NSString *str = [[startDateStr stringByAppendingString:@"-"] stringByAppendingString:endDateStr];
    [[TrafficOrgInfoViewController getNewInstance] setQueryDate:str];
    _returnMethod(str,startDate,endDate);
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)setRetureMethods:(RetureMethod) returnMethod{
    _returnMethod = returnMethod;
}
@end
