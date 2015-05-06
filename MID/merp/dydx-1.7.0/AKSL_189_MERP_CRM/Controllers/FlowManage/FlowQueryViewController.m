//
//  FlowQueryViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "FlowQueryViewController.h"
#import "SwitchSelected.h"
#import "SelectFoyerTypeController.h"
#import "FlowSubOrgViewController.h"
#import "TrafficInfoQueryViewController.h"

@interface FlowQueryViewController (){
    NSMutableArray * listForMonthData;
}

@end

@implementation FlowQueryViewController

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
    selectPepleType = 1;
    selectBusType = 111;
    
    // Do any additional setup after loading the view from its nib.
    [self setCornerRadiusAndBorder:_viewForBus];
    [self setCornerRadiusAndBorder:_viewForPeple];
    [self setCornerRadiusAndBorder:_butToQuery];
    [self setCornerRadiusAndBorder:_dateSelectView];
    UIButton * but;
    NSDate * currdate = [[NSDate new]offsetMonth:-5];
    listForMonthData = [NSMutableArray new];
    for (int i=0; i<6; i++) {
        SwitchSelected * obj = [SwitchSelected new];
        obj.key = i;
        obj.value = [[NSString stringWithFormat:@"%d-",currdate.year]stringByAppendingString:[NSString stringWithFormat:@"%d",currdate.month]];
        obj.isSelected = NO;
        obj.tempDate = currdate;
        [listForMonthData addObject:obj];
       currdate = [currdate offsetMonth:1];
    }
    startDate =(SwitchSelected *)listForMonthData[5];
    endDate =(SwitchSelected *)listForMonthData[5];
    but =(UIButton *)[_dateSelectView viewWithTag:10006];
    [but setTitle:startDate.value forState:UIControlStateNormal];
    but =(UIButton *)[_dateSelectView viewWithTag:10007];
    [but setTitle:endDate.value forState:UIControlStateNormal];
    if ([ConfigManage getLoginUser].roelId==6){
        _viewForPeple.hidden = YES;
     CGRect frame =  _viewForBus.frame;
     frame.origin.y -= _viewForPeple.frame.size.height+10;
        _viewForBus.frame = frame;
        frame = _butToQuery.frame;
        frame.origin.y -= _viewForPeple.frame.size.height+10;
        _butToQuery.frame = frame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)busButClick:(id)sender {
    UIButton * but = sender;
    [but setSelected:!but.selected];
    switch (but.tag) {
        case 1001:
            selectBusType += but.selected?100:-100;
            break;
        case 1002:
             selectBusType += but.selected?10:-10;
            break;
        case 1003:
            selectBusType += but.selected?1:-1;
            break;
    }
}

- (IBAction)pepleButClick:(id)sender {
    UIButton * but = sender;
    [but setSelected:!but.selected];
    if (but.selected) {
     selectPepleType = but.tag - 2000;
    for (int i=2001; i<=2003; i++) {
        UIButton * temp = (UIButton *)[_viewForPeple viewWithTag:i];
        if (temp.tag != but.tag) {
            [temp setSelected:NO];
        }
    }
    }else{
        selectPepleType = -1;
    }
}

- (IBAction)selectDateClick:(id)sender {
    UIButton * but = sender;
    SelectFoyerTypeController * select = [[SelectFoyerTypeController alloc]initWithNibName:@"SelectFoyerTypeController" bundle:nil];
    for (SwitchSelected * selobj in listForMonthData) {
        selobj.isSelected = NO;
        if ((but.tag==10006&&selobj.key==startDate.key)||(but.tag==10007&&selobj.key==endDate.key)) {
            selobj.isSelected = YES;
        }
    }
    select.catachData = listForMonthData;
    select.ifSingleSelected = YES;
    select.titleName = @"选择月份";
    [select setRetureMethods:^(NSArray *selecteds) {
        if (selecteds.count>0) {
            SwitchSelected * obj = (SwitchSelected *)selecteds[0];
            if (but.tag==10006) {
                
                if (obj.key > endDate.key) {
                    showMessageBox(@"开始时间必须小于或等于结束时间。");
                    return;
                }
                startDate = obj;
                [but setTitle:obj.value forState:UIControlStateNormal];
            }
            if (but.tag==10007) {
                if (obj.key < startDate.key) {
                    showMessageBox(@"开始时间必须小于或等于结束时间。");
                    return;
                }
                endDate = obj;
                [but setTitle:obj.value forState:UIControlStateNormal];
            }
        }
    }];

    [self.navigationController pushViewController:select animated:YES];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)QueryCommit:(id)sender {
 
    if (selectBusType==0) {
        showMessageBox(@"必须选择一种业务类型进行查询。");
        return;
    }
    if (selectPepleType==-1) {
        showMessageBox(@"必须选择一种人员类型进行查询。");
        return;
    }
    //all/self/month
    NSString * url=@"";
    int bus = selectBusType;
    if (bus>=100) {
        url = [url stringByAppendingString:@"package,"];
        bus -= 100;
    }
    if (bus>=10) {
        url = [url stringByAppendingString:@"app,"];
        bus -= 10;
    }
    if (bus>=1) {
        url = [url stringByAppendingString:@"achieve,"];
    }
    url = [url substringToIndex:url.length-1];
    NSString * userid =[NSString stringWithFormat:@"/%ld",[ConfigManage getLoginUser].userDataId];
    if ([ConfigManage getLoginUser].roelId==6) {
        url = [url stringByAppendingString:userid];
    }else{
        switch (selectPepleType) {
            case 1:
                url =[url stringByAppendingString:userid];
                break;
            case 2:
                url =[url stringByAppendingString:@"/salesmen"];
                break;
            case 3:
                url =[[[@"/api/traffic/v2/hallbrief/" stringByAppendingString:url]stringByAppendingString:@"/"]stringByAppendingString:[ConfigManage getLoginUser].userId];
                break;
        }
    
    }
    
    //添加产品
    url = [url stringByAppendingString:@"/"];
    NSString * startDateString = [NSDate dateFormateDate:[NSDate monthStartOfDay:startDate.tempDate] FormatePattern:@"yyyyMMdd"];
     NSString * endDateString = [NSDate dateFormateDate:[NSDate monthEndOfDay:endDate.tempDate] FormatePattern:@"yyyyMMdd"];
    url = [[[url stringByAppendingString:startDateString]stringByAppendingString:@"-"]stringByAppendingString:endDateString];
    if (selectPepleType==3) {
        FlowSubOrgViewController * view = [[FlowSubOrgViewController alloc]initWithNibName:@"FlowSubOrgViewController" bundle:nil];
        [view setUrlForQuery:url];
         [self.navigationController pushViewController:view animated:YES];
    }else{
    TrafficInfoQueryViewController * infoQuery = [[TrafficInfoQueryViewController alloc]initWithNibName:@"TrafficInfoQueryViewController" bundle:nil];
    infoQuery.title = @"流量经营查询结果";
    infoQuery.urlForData = url;
    infoQuery.type = selectPepleType-1;
    int sm = startDate.tempDate.month;
    int em = endDate.tempDate.month;
    if (startDate.key==endDate.key) {
        infoQuery.noteForTableTitle = [NSString stringWithFormat:@"%d月上报",sm];
    }else{
    infoQuery.noteForTableTitle = [NSString stringWithFormat:@"%d月至%d月上报",sm,em];
    }
    [self.navigationController pushViewController:infoQuery animated:YES];
    }
}
@end
