//
//  FlowSubOrgViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "FlowSubOrgViewController.h"
#import "HttpApiCall.h"
#import "FlowInfoSetCell.h"
#import "FlowInfoAppCell.h"
#import "SelectFoyerTypeController.h"
#import "DatePickerOperation.h"

@interface FlowSubOrgViewController (){
    NSMutableArray * listForMonthData;
}

@end

@implementation FlowSubOrgViewController

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
    UINib *nib = [UINib nibWithNibName:@"FlowInfoSetCell" bundle:nil];
    [_dataTableView registerNib:nib forCellReuseIdentifier:@"FlowInfoSetCell"];
    nib = [UINib nibWithNibName:@"FlowInfoAppCell" bundle:nil];
    [_dataTableView registerNib:nib forCellReuseIdentifier:@"FlowInfoAppCell"];
    
    
    if (urlForQueryFlow) {
        if (_isSingerPhoneNum) {
            _textForPhoneNum.text = [@"手机号码: " stringByAppendingString:_phoneNumStr];
            _textForPhoneNum.hidden = NO;
            _textSetTitle.hidden = YES;
            _textCountForPeple.hidden = YES;
        }else{
        _textForPhoneNum.hidden = YES;
        }
        isQueryRest = YES;
        _dateSelectView.hidden = YES;
        CGRect farme = _dataTableView.frame;
        farme.origin.y -= 70;
        farme.size.height += 70;
        _dataTableView.frame = farme;
        farme = _textCountForPeple.frame;
        farme.origin.y -= 70;
        _textCountForPeple.frame = farme;
        farme = _textSetTitle.frame;
        farme.origin.y -= 70;
        _textSetTitle.frame = farme;
        _textTitleTop.text = @"流量经营查询结果";
        [_ButForBack setImage:[UIImage imageNamed:@"icon_w_back.png"] forState:UIControlStateNormal];
        [self getDataFromServer];
    }else{
        [self setCornerRadiusAndBorder:_dateSelectView];
        isQueryRest = NO;
        [_ButForBack setImage:[UIImage imageNamed:@"icon_w_menu.png"] forState:UIControlStateNormal];
        
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
        UIButton * but;
        but =(UIButton *)[_dateSelectView viewWithTag:10006];
        [but setTitle:startDate.value forState:UIControlStateNormal];
        but =(UIButton *)[_dateSelectView viewWithTag:10007];
        [but setTitle:endDate.value forState:UIControlStateNormal];
       _textTitleTop.text = @"流量经营";
        
        NSString * startDateString = [NSDate dateFormateDate:[NSDate monthStartOfDay:startDate.tempDate] FormatePattern:@"yyyyMMdd"];
        NSString * endDateString = [NSDate dateFormateDate:[NSDate monthEndOfDay:endDate.tempDate] FormatePattern:@"yyyyMMdd"];
        ///api/traffic/manager/{startTime}/{endTime}
        urlForQueryFlow = [[[[[@"/api/traffic/v2/hallbrief/all/"stringByAppendingString:[ConfigManage getLoginUser].userId ]stringByAppendingString:@"/" ] stringByAppendingString:startDateString]stringByAppendingString:@"-"]stringByAppendingString:endDateString];
        [self getDataFromServer];
    }
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUrlForQuery:(NSString *)url{
    urlForQueryFlow = url;
}

-(void)getDataFromServer{
    [self showActivityIndicator];
    NSString *url = urlForQueryFlow;
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_FlowQuery_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                
                return;
            }
            
            NSDictionary * trafficPack = [temp valueForKey:@"trafficPackBrief"];
           
            
                 listForFirstDayActiveData = [temp valueForKey:@"trafficUsageBrief"];
            _textCountForPeple.text = [NSString stringWithFormat:@"%ld",[[temp valueForKey:@"userCount"] longValue]];
                listForTrafficAppData = [[temp valueForKey:@"trafficAppBrief"]valueForKey:@"listTrafficApp"];
             NSArray * listName = [trafficPack valueForKey:@"listTrafficType"];
            
            [listForTrafficPackData removeAllObjects];
            for (NSDictionary * namedic in listName) {
                NSString * name = [namedic valueForKey:@"packType"];
                NSString * nameType = [namedic valueForKey:@"packTypeName"];
                NSArray * listData = [trafficPack valueForKey:name];
                
                int i = 0;
                for (NSMutableDictionary * dicData in listData) {
                   
                    if (i>0) {
                        [dicData setValue:nil forKey:@"trafficPackTypeName"];
                    }else{
                    [dicData setValue:nameType forKey:@"trafficPackTypeName"];
                    }
                    if(!listForTrafficPackData){
                        listForTrafficPackData = [NSMutableArray new];
                    }
                    [listForTrafficPackData addObject:dicData];
                    i++;
                }
            }
            [_dataTableView reloadData];
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];


}
//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0 && listForTrafficPackData) {
        return listForTrafficPackData.count;
    }
    if (section==1 && listForTrafficAppData) {
        return listForTrafficAppData.count;
    }
    if (section==2) {
        if (_isSingerPhoneNum && [listForFirstDayActiveData objectForKey:@"url"]) {
            NSString * data = [listForFirstDayActiveData objectForKey:@"url"];
         return [data isEqualToString:@""]?0:1;
        }
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * ret;
    switch (section) {
        case 0:
            ret = _viewForTitleLiuliangbao;
            break;
        case 1:
            ret = _viewForTitleLiuliangApp;
            break;
        case 2:
            ret = _viewForTitleShourijihuo;
            break;
    }
    return ret;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {
            FlowInfoSetCell * cellTemp= [tableView dequeueReusableCellWithIdentifier:@"FlowInfoSetCell"];
            [cellTemp setData:listForTrafficPackData[indexPath.row] isShowNum:!_isSingerPhoneNum];
            cell = cellTemp;
            }
            break;
        case 1:
        {
            FlowInfoAppCell * cellTemp= [tableView dequeueReusableCellWithIdentifier:@"FlowInfoAppCell"];
            NSDictionary * dic = listForTrafficAppData[indexPath.row];
            if (_isSingerPhoneNum) {
                [cellTemp setData:[dic valueForKey:@"itemName"] Number:[NSNumber numberWithDouble:[[dic valueForKey:@"payment"] doubleValue]]];
            }else{
                [cellTemp setData:[dic valueForKey:@"itemName"] Number:[NSNumber numberWithInt:[[dic valueForKey:@"count"] intValue]]];
            }
            cell = cellTemp;
        }
            break;
        case 2:
        {
            FlowInfoAppCell * cellTemp= [tableView dequeueReusableCellWithIdentifier:@"FlowInfoAppCell"];
            if (_isSingerPhoneNum) {
                [cellTemp setData:@"流量使用" Number:[NSNumber numberWithInt:1]];
            }else{
                 [cellTemp setData:@"流量使用" Number:[NSNumber numberWithInt:[[listForFirstDayActiveData valueForKey:@"count"] intValue]]];
            
            }
            cell = cellTemp;
        }
            break;
        default:
            break;
    }
    if (!cell) {
     cell = [UITableViewCell new];
    }
    return cell;
}
- (IBAction)goBack:(id)sender {
    if (isQueryRest) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
      [self topButtonClick:sender];
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
                NSString * startDateString = [NSDate dateFormateDate:[NSDate monthStartOfDay:startDate.tempDate] FormatePattern:@"yyyyMMdd"];
                NSString * endDateString = [NSDate dateFormateDate:[NSDate monthEndOfDay:endDate.tempDate] FormatePattern:@"yyyyMMdd"];
                ///api/traffic/manager/{startTime}/{endTime}
                urlForQueryFlow = [[[[[@"/api/traffic/v2/hallbrief/all/"stringByAppendingString:[ConfigManage getLoginUser].userId ]stringByAppendingString:@"/" ] stringByAppendingString:startDateString]stringByAppendingString:@"-"]stringByAppendingString:endDateString];
                [self getDataFromServer];
            }
            if (but.tag==10007) {
                if (obj.key < startDate.key) {
                    showMessageBox(@"开始时间必须小于或等于结束时间。");
                    return;
                }
                endDate = obj;
                [but setTitle:obj.value forState:UIControlStateNormal];
                NSString * startDateString = [NSDate dateFormateDate:[NSDate monthStartOfDay:startDate.tempDate] FormatePattern:@"yyyyMMdd"];
                NSString * endDateString = [NSDate dateFormateDate:[NSDate monthEndOfDay:endDate.tempDate] FormatePattern:@"yyyyMMdd"];
                ///api/traffic/manager/{startTime}/{endTime}
                urlForQueryFlow = [[[[[@"/api/traffic/v2/hallbrief/all/"stringByAppendingString:[ConfigManage getLoginUser].userId ]stringByAppendingString:@"/" ] stringByAppendingString:startDateString]stringByAppendingString:@"-"]stringByAppendingString:endDateString];
                [self getDataFromServer];
            }
        }
    }];
    
    [self.navigationController pushViewController:select animated:YES];
}

@end
