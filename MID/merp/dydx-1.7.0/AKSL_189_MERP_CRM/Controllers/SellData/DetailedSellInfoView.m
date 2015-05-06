//
//  DetailedSellInfoView.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-9.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "DetailedSellInfoView.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "HttpApiCall.h"
#import "BaseViewController.h"
#define MyMBProgressHUDTAG  78495

@implementation SingerProductCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    
    _labelValueText.layer.cornerRadius = 6;
   // _labelValueText.backgroundColor = [UIColor colorWithRed:0.522 green:0.714 blue:0.086 alpha:1];
        //_labelValueText.layer.borderColor = [UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:1].CGColor;
   // _labelValueText.layer.borderWidth = 1;
}

@end
@implementation DetailedSellInfoView

NSArray * weekSet ;//= [[NSArray alloc]initWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
NSArray * mothSet;
-(void)setBase:(BaseViewController *)baseview{
    base = baseview;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isload = NO;
        // Initialization code
        //初始化图表
        chartview = [[AKUIChartView alloc]initWithHeight:150 Top:0 Delegate:self];
        chartview.viewLeftMargins= 5;
        chartview.viewTopMargins = 20;
        [self addSubview:chartview];
        
        //初始化列表
        tabelview = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, 320, self.frame.size.height-155)];
        UINib *nib = [UINib nibWithNibName:@"SingerProductCell" bundle:nil];
        [tabelview registerNib:nib forCellReuseIdentifier:@"SingerProductCell"];
        tabelview.delegate = self;
        tabelview.dataSource = self;
        if(IOS7_OR_LATER)
            tabelview.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self addSubview:tabelview];
    }
    return self;
}
-(void)didMoveToSuperview{
    if(isload)return;
[self getDataForServer:-1];
    isload=YES;
}
-(void)setType:(int)type{
    _type = type;
    typeString = _type==0?@"/year":@"/week";
}
-(void)getDataForServer:(int)set{
    [self showActivityIndicator];
    // /api/user/channelfilter/year/,29,32,41,/,81,82,83,/,1,2,/1/1
    // /api/user/agentfilter/year/,29,32,41,/,81,82,83,/,1,2,/0/20
    if(![ConfigManage getConfig:PRODUCTS_INFO_SELECT_KEY] && [ConfigManage getLoginUser].roelId!=4){
        [ConfigManage setConfig:PRODUCTS_INFO_SELECT_KEY Value:@"/all"];
        [ConfigManage setConfig:DATE_SELECT_KEY Value:@"/week"];
        [ConfigManage setConfig:DISTRICT_INFO_SELECT_KEY Value:@"/all"];
        [ConfigManage setConfig:STORETYPE_INFO_SELECT_KEY Value:@"/all"];
    }
    
    //添加 年周 产品 厅店类型 区域
    NSString *url =  @"/api/datareports/detail/%@%@/%d";
    if([ConfigManage getLoginUser].roelId!=4){
        url = [[url stringByAppendingString:[ConfigManage getConfig:PRODUCTS_INFO_SELECT_KEY]]stringByAppendingString:[ConfigManage getConfig:STORETYPE_INFO_SELECT_KEY]];
    }else{
        url = [url stringByAppendingString:@"/all/all"];
    }
    
    url = [NSString stringWithFormat:url,_UserCode,typeString,set];
     ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_desellinfo_data"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            //            LoginUser * user = [LoginUser getLoginUserFromJson:reArg];
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                return;
            }
            int toM =[[temp objectForKey:@"default"]integerValue];
            if(set==-1){
                listDataForChart =[[NSMutableArray alloc]initWithArray:[[temp objectForKey:@"system"]subarrayWithRange:NSMakeRange(0, toM)]];
                if (!listDataForChart.count) {
                    [listDataForChart addObject:[NSNumber numberWithInt:0]];
                }
                [chartview  replaceData];
            }
            NSMutableArray * arry = [temp objectForKey:@"product"];
            int sunnum = 0;
            for (int i=0; i<arry.count; i++) {
                int complete =[[[arry objectAtIndex:i]objectForKey:@"complete"]intValue];
                sunnum += complete;
                if (complete==0) {
                    [arry removeObjectAtIndex:i];
                    i--;
                }
            }
            if (!arry.count) {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [dic setValue:[NSNumber numberWithInt:0] forKey:@"complete"];
                [dic setValue:@"该区间没有销量" forKey:@"name"];
                [arry addObject:dic];
            }else{
                NSMutableDictionary *dic = [NSMutableDictionary new];
                [dic setValue:[NSNumber numberWithInt:sunnum] forKey:@"complete"];
                if(set!=-1){
                    toM = set;}
                NSString * str = _type==0?[NSString stringWithFormat:@"%d月",toM]:[weekSet objectAtIndex:toM-1];
                [dic setValue:[NSString stringWithFormat:@"%@总销量",str] forKey:@"name"];
                [arry insertObject:dic atIndex:0];
            }
            listDataForTable = arry;
            
            [tabelview reloadData];
            
        }
        @catch (NSException *exception) {
          
        }
        @finally {
            return;
        }
    }];
    [request setFailedBlock:^{
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];
    
}
-(NSArray*)DataListForOptions:(NSInteger)optionsIndex{
    return  listDataForChart;
}
-(NSArray*)DataNameList{
    switch (_type) {
        case 0:
            if (!mothSet) {
                mothSet = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"月",nil];
            }
            return mothSet;
            break;
        case 1:
            if(!weekSet){
                weekSet =[[NSArray alloc]initWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
            }
            return weekSet;
            break;
    }
    return nil;
}
-(void)AKUIChartView:(AKUIChartView *)chartView selectedNode:(NSInteger)nodeIndex{
    [self getDataForServer:nodeIndex+1];
}

//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(listDataForTable)
        return listDataForTable.count;
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SingerProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingerProductCell"];
    if(cell){
      NSDictionary *dic = [listDataForTable objectAtIndex:indexPath.row];
        cell.labelProductName.text = [dic objectForKey:@"name"];
        cell.labelValueText.text =[NSString stringWithFormat:@"%d", [[dic objectForKey:@"complete"]intValue]];
    }
    return cell;
    
}


- (void) showActivityIndicator
{
    self.userInteractionEnabled=NO;
    MBProgressHUD * tempMBProgressHUD =(MBProgressHUD *)[self viewWithTag:MyMBProgressHUDTAG];
    if (tempMBProgressHUD!=nil) {
        [tempMBProgressHUD removeFromSuperview];
    }
    myMBProgressHUD = [[MBProgressHUD alloc] initWithView:self];
    myMBProgressHUD.tag=MyMBProgressHUDTAG;
	[self addSubview:myMBProgressHUD];
	[self bringSubviewToFront:myMBProgressHUD];
    myMBProgressHUD.delegate = self;
    myMBProgressHUD.labelText =@"请稍后，加载数据...";
	[myMBProgressHUD show:YES];
    
}



- (void) hideActivityIndicator
{
    
    self.userInteractionEnabled=YES;
    if (myMBProgressHUD)
    {
        [myMBProgressHUD removeFromSuperview];
        myMBProgressHUD = nil;
    }
    MBProgressHUD * tempMBProgressHUD =(MBProgressHUD *)[self viewWithTag:MyMBProgressHUDTAG];
    if (tempMBProgressHUD!=nil) {
        [tempMBProgressHUD removeFromSuperview];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
