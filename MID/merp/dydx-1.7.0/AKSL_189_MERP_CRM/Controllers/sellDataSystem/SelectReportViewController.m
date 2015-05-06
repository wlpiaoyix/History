//
//  SelectReportViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-10.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "SelectReportViewController.h"
#import "HttpApiCall.h"
#import "SwitchSelected.h"
#import "SelectFoyerTypeController.h"
#import "DatePickerOperation.h"
#import "SellSystemViewController.h"
#import "CommitDataViewController.h"

@interface SelectReportViewController (){
 NSString * typeForReport;
 LoginUser * loginUser;
    NSMutableArray *listForTdtype;
    NSMutableArray *listForProducts;
    NSMutableArray *listForArea;
    NSMutableArray *listForFzz;
    NSMutableArray *listForTdName;
     
    NSDate * startDate;
    NSDate * endDate;
}

@end

@implementation SelectReportViewController
 

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
    loginUser = [ConfigManage getLoginUser];
    
    listForTdtype = [NSMutableArray new];
    listForTdName = [NSMutableArray new];
    listForProducts = [NSMutableArray new];
    listForFzz = [NSMutableArray new];
    listForArea = [NSMutableArray new];
    
    startDate = [[NSDate new] offsetDay:-2];
    endDate = [[NSDate new] offsetDay:-1];
    if (_queryDate) {
        startDate = _queryDate;
        endDate = _queryDate;
    }
    [self setCornerRadiusAndBorder:_butForGetTable];
    [self setCornerRadiusAndBorder:_butForGetText];
    
    if(_isTableData){
    typeForReport = @"system";
    [_butForGetText setHidden:YES];
        CGRect farme=_butForGetTable.frame;
        farme.origin.x = (self.view.frame.size.width - farme.size.width)/2;
        _butForGetTable.frame =farme;
    }else{
    typeForReport =@"report";
    }
     UIButton * but;
    but =(UIButton *)[_tdSelectView viewWithTag:10002];
    [but setEnabled:NO];
    but =(UIButton *)[_areaSelectView viewWithTag:10004];
    [but setEnabled:NO];
    but =(UIButton *)[_areaSelectView viewWithTag:10005];
    [but setEnabled:NO];
    
    but =(UIButton *)[_dateSelectView viewWithTag:10006];
    [but setTitle:[NSDate dateFormateDate:startDate FormatePattern:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    but =(UIButton *)[_dateSelectView viewWithTag:10007];
    [but setTitle:[NSDate dateFormateDate:endDate FormatePattern:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    
    if (loginUser.roelId == 4) {
        [_areaSelectView setHidden:YES];
       CGRect frame =  _dateSelectView.frame ;
        frame.origin.y = 172;
        _dateSelectView.frame =frame;
        frame = _butForGetTable.frame;
        frame.origin.y -=165;
        _butForGetTable.frame = frame;
        frame = _butForGetText.frame;
        frame.origin.y -=165;
        _butForGetText.frame = frame;
        [self setUIButtonEnabled:10001];
        [self getYWTypeData:[NSString stringWithFormat:@",%d,",loginUser.organizationType]];
        
    }else{
        [self getTDTypeData];
        [self getAreaData];
    }
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getTDTypeData{
         NSString *url = @"/api/dic/allhalltype";
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_allhalltype_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            [listForTdtype removeAllObjects];
            //读取上次选择结果
            NSString * defTdtype = [ConfigManage getConfig:DEF_tdType];
            NSArray * select ;
            if (defTdtype&&defTdtype.length>0) {
                select = [self getDataForSelectedStr:defTdtype];
            }
            NSString * setToText = @"";
            for (int i=0; i<temp.count; i++) {
                SwitchSelected *obj = [SwitchSelected new];
                NSDictionary * dic = [temp objectAtIndex:i];
                NSString * key =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"]intValue]];
                obj.key = [key longLongValue];
                obj.value = [dic objectForKey:@"hallTypeNames"];
                obj.isSelected = NO;
                if (select) {
                    for (int i=0; i<select.count; i++) {
                        if ([select[i] isEqualToString:key]) {
                            obj.isSelected = YES;
                            setToText = [[setToText stringByAppendingString:obj.value]stringByAppendingString:@"/"];
                        }
                    }
                }else{
                obj.isSelected = YES;
                }
            [listForTdtype addObject:obj];
            }
            if (setToText.length==0){
                setToText =@"默认";
                [ConfigManage setConfig:DEF_tdType Value:@""];
            }
            [self setUIButtonText:10001 Value:setToText];
            [self getYWTypeData:defTdtype];
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
    }];
    [request startAsynchronous];
}
-(NSArray *)getDataForSelectedStr:(NSString *)str{
 NSArray * data;
 data = [str componentsSeparatedByString:@","];
    return data;
}
-(void)setUIButtonText:(int)tag Value:(NSString *)value{
    UIButton * but;
    if (tag<=10002&&tag>=10001) {
        but =(UIButton *) [_tdSelectView viewWithTag:tag];
    }
    if (tag<=10005&&tag>=10003) {
        but =(UIButton *) [_areaSelectView viewWithTag:tag];
        
    }
    if (tag==10007) {
        
    }
    if (tag == 1006) {
        
    }
    [but setTitle:value forState:UIControlStateNormal];
    [but setEnabled:YES];
}
-(void)setUIButtonEnabled:(int)tag{
    UIButton * but;
    if (tag<=10002&&tag>=10001) {
        but =(UIButton *) [_tdSelectView viewWithTag:tag];
    }
    if (tag<=10005&&tag>=10003) {
        but =(UIButton *) [_areaSelectView viewWithTag:tag];
        
    }
    [but setTitle:@"默认" forState:UIControlStateNormal];
    [but setEnabled:NO];
}

-(void)getYWTypeData:(NSString *)tdtypeID{
 
   //api/products/report/104/default/default
    //api/organizationsildren/5
    if (!tdtypeID || [tdtypeID isEqualToString:@""] ) {
        tdtypeID = @"default";
    }
    NSString *url =[NSString stringWithFormat:@"/api/products/%@/%@/default/default",typeForReport,tdtypeID];
    if (!_isTableData) {
        url = @"/api/dic/productsgroup";
    }
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_products_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            [listForProducts removeAllObjects];
            //读取上次选择结果
            NSString * defTdtype = [ConfigManage getConfig:DEF_products];
            NSArray * select ;
            if (defTdtype&&defTdtype.length>0) {
                select = [self getDataForSelectedStr:defTdtype];
            }
            NSString * setToText = @"";
            for (int i=0; i<temp.count; i++) {
                SwitchSelected *obj = [SwitchSelected new];
                NSDictionary * dic = [temp objectAtIndex:i];
                NSString * key =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"]intValue]];
                obj.key = [key longLongValue];
                obj.value = [dic objectForKey:@"name"];
                obj.isSelected = NO;
                if (select) {
                    for (int i=0; i<select.count; i++) {
                        if ([select[i] isEqualToString:key]) {
                            obj.isSelected = YES;
                            setToText = [[setToText stringByAppendingString:obj.value]stringByAppendingString:@"/"];
                        }
                    }
                }else{
                    obj.isSelected = YES;
                }
                [listForProducts addObject:obj];
            }
            if (setToText.length==0){
                setToText =@"默认";
                [ConfigManage setConfig:DEF_products Value:@""];
            }
            [self setUIButtonText:10002 Value:setToText];
            
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
    }];
    [request startAsynchronous];
    
}

-(void)getAreaData{
    
    NSString *url = @"/api/organizations/allareas";
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_allareas_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            [listForArea removeAllObjects];
            //读取上次选择结果
            NSString * defTdtype = [ConfigManage getConfig:DEF_Area];
            NSArray * select ;
            if (defTdtype&&defTdtype.length>0) {
                select = [self getDataForSelectedStr:defTdtype];
            }
            NSString * setToText = @"";
            for (int i=0; i<temp.count; i++) {
                SwitchSelected *obj = [SwitchSelected new];
                NSDictionary * dic = [temp objectAtIndex:i];
                NSString * key =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"]intValue]];
                obj.key = [key longLongValue];
                obj.value = [dic objectForKey:@"areasName"];
                obj.isSelected = NO;
                if (select) {
                    for (int i=0; i<select.count; i++) {
                        if ([select[i] isEqualToString:key]) {
                            obj.isSelected = YES;
                            setToText = [[setToText stringByAppendingString:obj.value]stringByAppendingString:@"/"];
                        }
                    }
                }else{
                    obj.isSelected = YES;
                }
                [listForArea addObject:obj];
            }
            if (!select){
                [self setUIButtonText:10003 Value:@"默认"];
            }else{
                [self setUIButtonText:10003 Value:setToText];
                //if(select.count==1){
                 [self getAreaChin:defTdtype  Type:10003];
               // }
            }
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
    }];
    [request startAsynchronous];
}

-(void)getAreaChin:(NSString *)areaId Type:(int)type{
    NSString *url =[NSString stringWithFormat:@"/api/organizations/children/%@",areaId];
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_products_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            if (type==10003) {
            [listForFzz removeAllObjects];
            //读取上次选择结果
            NSString * defTdtype = [ConfigManage getConfig:DEF_Area_Fzz];
            NSArray * select ;
            if (defTdtype&&defTdtype.length>0) {
                select = [self getDataForSelectedStr:defTdtype];
            }
            NSString * setToText = @"";
            for (int i=0; i<temp.count; i++) {
                SwitchSelected *obj = [SwitchSelected new];
                NSDictionary * dic = [temp objectAtIndex:i];
                NSString * key =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"]intValue]];
                obj.key = [key longLongValue];
                obj.value = [dic objectForKey:@"name"];
                obj.isSelected = NO;
                if (select) {
                    for (int i=0; i<select.count; i++) {
                        if ([select[i] isEqualToString:key]) {
                            obj.isSelected = YES;
                            setToText = [[setToText stringByAppendingString:obj.value]stringByAppendingString:@"/"];
                        }
                    }
                }else{
                    obj.isSelected = YES;
                }
                [listForFzz addObject:obj];
            }
            if (!select){
                [self setUIButtonText:10004 Value:@"默认"];
            }else{
                [self setUIButtonText:10004 Value:setToText];
               // if(select.count==1){
                    [self getAreaChin:defTdtype Type:10004];
               // }
            }
            }
            if (type==10004) {
                [listForTdName removeAllObjects];
                //读取上次选择结果
                NSString * defTdtype = [ConfigManage getConfig:DEF_Area_TdName];
                NSArray * select ;
                if (defTdtype&&defTdtype.length>0) {
                    select = [self getDataForSelectedStr:defTdtype];
                }
                NSString * setToText = @"";
                for (int i=0; i<temp.count; i++) {
                    SwitchSelected *obj = [SwitchSelected new];
                    NSDictionary * dic = [temp objectAtIndex:i];
                    NSString * key =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"]intValue]];
                    obj.key = [key longLongValue];
                    obj.value = [dic objectForKey:@"name"];
                    obj.isSelected = NO;
                    if (select) {
                        for (int i=0; i<select.count; i++) {
                            if ([select[i] isEqualToString:key]) {
                                obj.isSelected = YES;
                                setToText = [[setToText stringByAppendingString:obj.value]stringByAppendingString:@"/"];
                            }
                        }
                    }else{
                        obj.isSelected = YES;
                    }
                    [listForTdName addObject:obj];
                }
                if (!select){
                    [self setUIButtonText:10005 Value:@"默认"];
                }else{
                    [self setUIButtonText:10005 Value:setToText];
                }
            }
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{ 
    }];
    [request startAsynchronous];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectButClick:(id)sender {
    UIButton * but = sender;
    
    SelectFoyerTypeController *view = [[SelectFoyerTypeController alloc]initWithNibName:@"SelectFoyerTypeController" bundle:nil];
    switch (but.tag){
        case 10001:{
            view.catachData = listForTdtype;
            view.ifSingleSelected = NO;
            view.titleName = @"厅店类型";
            [view setRetureMethods:^(NSArray *selecteds) {
                if (selecteds.count>0) {
                    for (SwitchSelected * select in listForTdtype) {
                        select.isSelected = NO;
                    }
                    NSString * setToText = @"";
                    NSString * setTokey = @"";
                    for (int i=0; i<selecteds.count; i++) {
                        SwitchSelected *obj = (SwitchSelected *)selecteds[i];
                        for (SwitchSelected * select in listForTdtype) {
                            if (obj.key == select.key) {
                                select.isSelected = YES;
                            }
                        }
                        NSString * key = [NSString stringWithFormat:@"%lli",obj.key];
                        if (i>0) {
                            setToText = [setToText stringByAppendingString:@"/"];
                            setTokey = [setTokey stringByAppendingString:@","];
                        }
                        setToText = [setToText stringByAppendingString:obj.value];
                        setTokey = [setTokey stringByAppendingString:key];
                    }
                    
                    [ConfigManage setConfig:DEF_tdType Value:setTokey];
                    [ConfigManage setConfig:DEF_products Value:@""];
                    [self setUIButtonEnabled:10002];
                    [self getYWTypeData:setTokey];
                    [self setUIButtonText:10001 Value:setToText];
                }
            }];
            break;
            }
        case 10002:{
            view.catachData = listForProducts;
            view.ifSingleSelected = NO;
            view.titleName = @"业务类型";
            [view setRetureMethods:^(NSArray *selecteds) {
                if (selecteds.count>0) {
                    for (SwitchSelected * select in listForProducts) {
                            select.isSelected = NO;
                    }
                    NSString * setToText = @"";
                    NSString * setTokey = @"";
                    for (int i=0; i<selecteds.count; i++) {
                        SwitchSelected *obj = (SwitchSelected *)selecteds[i];
                        for (SwitchSelected * select in listForProducts) {
                            if (obj.key == select.key) {
                                select.isSelected = YES;
                            }
                        }
                        NSString * key = [NSString stringWithFormat:@"%lli",obj.key];
                        if (i>0) {
                            setToText = [setToText stringByAppendingString:@"/"];
                            setTokey = [setTokey stringByAppendingString:@","];
                          }
                        setToText = [setToText stringByAppendingString:obj.value];
                        setTokey = [setTokey stringByAppendingString:key];
                    }
                    [self setUIButtonText:10002 Value:setToText];
                    [ConfigManage setConfig:DEF_products Value:setTokey];
                }
            }];
            break;
        }
            
        case 10003:{
            view.catachData = listForArea;
            view.ifSingleSelected = NO;
            view.titleName = @"经营区域";
            [view setRetureMethods:^(NSArray *selecteds) {
                if (selecteds.count>0) {
                    for (SwitchSelected * select in listForArea) {
                        select.isSelected = NO;
                    }
                    NSString * setToText = @"";
                    NSString * setTokey = @"";
                    for (int i=0; i<selecteds.count; i++) {
                        SwitchSelected *obj = (SwitchSelected *)selecteds[i];
                        for (SwitchSelected * select in listForArea) {
                            if (obj.key == select.key) {
                                select.isSelected = YES;
                            }
                        }
                        NSString * key = [NSString stringWithFormat:@"%lli",obj.key];
                        if (i>0) {
                            setToText = [setToText stringByAppendingString:@"/"];
                            setTokey = [setTokey stringByAppendingString:@","];
                        }
                        setToText = [setToText stringByAppendingString:obj.value];
                        setTokey = [setTokey stringByAppendingString:key];
                    }
                    [self setUIButtonText:10003 Value:setToText];
                    [ConfigManage setConfig:DEF_Area Value:setTokey];
                    //[self setUIButtonEnabled:10004];
                    [self setUIButtonEnabled:10005];
                    [ConfigManage setConfig:DEF_Area_TdName Value:@""];
                    [ConfigManage setConfig:DEF_Area_Fzz Value:@""];
                    //if (selecteds.count==1) {
                        [self getAreaChin:setTokey Type:10003];
                   // }
                }
            }];
            break;
        }
        case 10004:{
            view.catachData = listForFzz;
            view.ifSingleSelected = NO;
            view.titleName = @"分支局";
            [view setRetureMethods:^(NSArray *selecteds) {
                if (selecteds.count>0) {
                    for (SwitchSelected * select in listForFzz) {
                        select.isSelected = NO;
                    }
                NSString * setToText = @"";
                NSString * setTokey = @"";
                for (int i=0; i<selecteds.count; i++) {
                    SwitchSelected *obj = (SwitchSelected *)selecteds[i];
                    for (SwitchSelected * select in listForFzz) {
                        if (obj.key == select.key) {
                            select.isSelected = YES;
                        }
                    }
                    NSString * key = [NSString stringWithFormat:@"%lli",obj.key];
                    if (i>0) {
                        setToText = [setToText stringByAppendingString:@"/"];
                        setTokey = [setTokey stringByAppendingString:@","];
                    }
                    setToText = [setToText stringByAppendingString:obj.value];
                    setTokey = [setTokey stringByAppendingString:key];
                }
                [self setUIButtonText:10004 Value:setToText];
                [ConfigManage setConfig:DEF_Area_Fzz Value:setTokey];
                //[self setUIButtonEnabled:10005];
                 [ConfigManage setConfig:DEF_Area_TdName Value:@""];
               // if (selecteds.count==1) {
                    [self getAreaChin:setTokey Type:10004];
               // }
                }
            }];
            break;
        }
        case 10005:{
            view.catachData = listForTdName;
            view.ifSingleSelected = NO;
            view.titleName = @"厅店名字";
            [view setRetureMethods:^(NSArray *selecteds) {
                if (selecteds.count>0) {
                    for (SwitchSelected * select in listForTdName) {
                        select.isSelected = NO;
                    }
                NSString * setToText = @"";
                NSString * setTokey = @"";
                for (int i=0; i<selecteds.count; i++) {
                    SwitchSelected *obj = (SwitchSelected *)selecteds[i];
                    for (SwitchSelected * select in listForTdName) {
                        if (obj.key == select.key) {
                            select.isSelected = YES;
                        }
                    }
                    NSString * key = [NSString stringWithFormat:@"%lli",obj.key];
                    if (i>0) {
                        setToText = [setToText stringByAppendingString:@"/"];
                        setTokey = [setTokey stringByAppendingString:@","];
                    }
                    setToText = [setToText stringByAppendingString:obj.value];
                    setTokey = [setTokey stringByAppendingString:key];
                }
                [self setUIButtonText:10005 Value:setToText];
                [ConfigManage setConfig:DEF_Area_TdName Value:setTokey];
            }
            }];
            break;
        }
         default:
            break;
    }
    [self.navigationController pushViewController:view animated:YES];
}

- (IBAction)selectDateClick:(id)sender {
    UIButton * but = sender;
    DatePickerOperation * datepicker = [DatePickerOperation new];
    if (but.tag==10006) {
        datepicker.curDate =startDate;
        [datepicker setCallBacks:^(NSDate *curDate) {
            startDate = curDate;
            [but setTitle:[NSDate dateFormateDate:curDate FormatePattern:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        }];
    }
    if (but.tag==10007) {
        datepicker.curDate =endDate;
        [datepicker setCallBacks:^(NSDate *curDate) {
            endDate = curDate;
            [but setTitle:[NSDate dateFormateDate:curDate FormatePattern:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        }];
    }

    [self.view addSubview:datepicker];
}
- (IBAction)getTextClick:(id)sender {
    
    CommitDataViewController * commit = [[CommitDataViewController alloc]initWithNibName:@"CommitDataViewController" bundle:Nil];
    commit.isTableData = _isTableData;
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:startDate forKey:@"startDate"];
    [dic setObject:endDate forKey:@"endDate"];
    commit.selectDic =dic;
    [self.navigationController pushViewController:commit animated:YES];
}
-(int)compareDate:(int)type one:(NSDate*)one tow:(NSDate *)tow{
    int year = one.year-tow.year;
    int month = one.month - tow.month;
    int day = one.day - tow.day;
    return year*100+month*10+day;
}
- (IBAction)getTableClick:(id)sender {
    if (startDate.timeIntervalSince1970>endDate.timeIntervalSince1970) {
        showMessageBox(@"查询起始时间大于截止时间!");
        return;
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:startDate forKey:@"startDate"];
    [dic setObject:endDate forKey:@"endDate"];
    SellSystemViewController * sell = [[SellSystemViewController alloc]initWithNibName:@"SellSystemViewController" bundle:nil isDataTable:_isTableData SelectDic:dic isFristPage:NO];
    sell.isSelectPage = YES;
    sell.title =[NSString stringWithFormat:@"%@数据筛选结果",(_isTableData?@"销售":@"上报")];
    [self.navigationController pushViewController:sell animated:YES];
    
}
@end
