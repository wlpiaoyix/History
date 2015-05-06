//
//  TrafficReportController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-4-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TrafficReportController.h"
#import "TrafficCell.h"
#import "HttpApiCall.h"
#import "TrafficTitleCell.h"
#import "TableViewHeadCell.h"
#import "SwitchSelected.h"

@interface TrafficReportController ()
{
    NSMutableArray *listTrafficType;
    NSMutableDictionary *trafficPack;
    NSMutableArray *promptArray;
    NSMutableArray *selectList;
    NSMutableArray *reportdetailArray;
    
}

@end

@implementation TrafficReportController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewHeadCell" bundle:nil] forCellReuseIdentifier:@"HeadCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TrafficCell" bundle:nil] forCellReuseIdentifier:@"trafficCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TrafficTitleCell" bundle:nil] forCellReuseIdentifier:@"titleCell"];
    self.textView.delegate = self;
    // Do any additional setup after loading the view from its nib.
    
    promptArray = [NSMutableArray new];

    [self.tableView setHidden:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger countx=0;
    if(section == 0)
    {
        countx = 1;
    }
    else if(section == 1)
    {
        if (listTrafficType.count == 0) {
            countx = 0;
        }
        countx = [listTrafficType count]*2;
    }
    return countx;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id celxx ;
    NSUInteger index = [indexPath section];
    if (index == 0) {
        
        TrafficCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trafficCell"];
        if(!cell)
        {
            cell = [[TrafficCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"trafficCell"];
        }
        
        [cell setReportdetailData:reportdetailArray];
        celxx = cell;
        
    }
    else if (index == 1)
    {
        if(indexPath.row %2 == 0)
        {
            TrafficTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
            if(!cell)
            {
                cell = [[TrafficTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
            }
            cell.imgTitle.image = [UIImage imageNamed:@"top_bar_bg.png"];
        
            cell.lblTitle.text = [[listTrafficType objectAtIndex:indexPath.row/2] objectForKey:@"packTypeName"];
            celxx = cell;
        }
        else if(indexPath.row %2 != 0)
        {
            TrafficCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trafficCell"];
            if(!cell)
            {
                cell = [[TrafficCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"trafficCell"];
            }
            NSString *str = [[listTrafficType objectAtIndex:indexPath.row/2] objectForKey:@"packType"];
            NSMutableArray *array = [trafficPack objectForKey:str];
            [cell setData:array];
        
            celxx = cell;
        }
    }
    return celxx;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath section];
    CGFloat heightX = 30;
    if (index == 0) {
        heightX = [reportdetailArray count]*13;
    }
    else if (index == 1)
    {
    
        if (indexPath.row %2 !=0) {
            NSString *str = [[listTrafficType objectAtIndex:indexPath.row/2] objectForKey:@"packType"];
            NSMutableArray *array = [trafficPack objectForKey:str];
        
            if([array count] %3 == 0)
            {
                heightX = 40*[array count]/3;
            }
            else
            {
                heightX = 40*([array count]/3+1);
            }
            for (int i = 0; i<[array count]; i++) {
                SwitchSelected * obj = array[i];

                if(obj.isReported && !obj.isSelf)
                {
                    [promptArray addObject:[array objectAtIndex:i]];
                }
            }
        }
    }
    return heightX;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id celxx ;
    if (section == 0) {
        
        TableViewHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadCell"];
        if(!cell)
        {
            cell = [[TableViewHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadCell"];
        }
        cell.lblType.text = @"上报历史";
        cell.img.image = [UIImage imageNamed:@"Reporthistory.png"];
        
        celxx = cell;
    }
    else if (section == 1)
    {
        TableViewHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadCell"];
        if(!cell)
        {
        cell = [[TableViewHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HeadCell"];
        }
        
        celxx = cell;
    }
    return celxx;
}

-(void)setData
{
    NSString *url = [NSString stringWithFormat:@"/api/traffic/v2/reportcondition/%@",self.textView.text];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"traffic_get_data"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^
     {
         @try {
             [self hideActivityIndicator];
             [request setResponseEncoding:NSUTF8StringEncoding];
             NSString *responseString = [request responseString];
             NSDictionary *dic = [responseString JSONValueNewMy];
             if (dic == nil) {
                 showMessageBox(@"暂无数据！");
                 return;
             }
             listTrafficType = [[dic objectForKey:@"trafficPack"] objectForKey:@"listTrafficType"];
             trafficPack = [NSMutableDictionary new];
             reportdetailArray = [dic objectForKey:@"listHistory"];
             NSDictionary * tempDic = [dic objectForKey:@"trafficPack"];
             for (NSDictionary * dicX in listTrafficType) {
                 NSArray * ary = [tempDic valueForKey:[dicX valueForKey:@"packType"]];
                 NSMutableArray * newAry = [NSMutableArray new];
                 for (NSDictionary * dicPack in ary) {
                     SwitchSelected * obj = [SwitchSelected new];
                     NSString *title = [dicPack objectForKey:@"productName"];
                     obj.key = [[dicPack objectForKey:@"productId"] longLongValue];
                     
                     obj.value = title;
                     obj.isSelf = [[dicPack objectForKey:@"isSelf"] integerValue]==1;
                     obj.isReported = [[dicPack objectForKey:@"isReported"] integerValue]==1;
                     [newAry addObject:obj];
                 }
                 [trafficPack setObject:newAry forKey:[dicX valueForKey:@"packType"]];
             }
             if(dic != nil)
             {
                 self.tableView.dataSource = self;
                 self.tableView.delegate = self;
                 
             }
             [self.tableView reloadData];
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
-(void)prompt
{
    for (int i = 0; i < [promptArray count]; i++) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 44+i*44, 200, 20)];
        lbl.text = [[promptArray objectAtIndex:i] objectForKey:@"productName"];
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.textColor = [UIColor redColor];
        [self.reportView addSubview:lbl];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self.textView resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)report:(id)sender {
    if(self.textView.text == nil || [@"" isEqualToString:self.textView.text])
    {
        showMessageBox(@"请输入手机号码！");
        return;
    }
    else
    {
        if (self.textView.text.length != 11) {
            showMessageBox(@"请输入11位手机号码！");
            return;
        }
        else
        {
            [self.tableView setHidden:NO];
        }
    }
    [reportdetailArray removeAllObjects];
    [self setData];
    [self.tableView setHidden:NO];
}
-(void)postData
{

    NSMutableArray *productArray = [[NSMutableArray alloc] init];

    for(NSDictionary *dic in listTrafficType)
    {
        NSArray *array = [trafficPack objectForKey:[dic objectForKey:@"packType"]];
        for(int j=0;j<[array count] ;j++)
        {
            SwitchSelected *obj = array[j];
            if(obj.isSelected)
            {
                NSNumber *num = [NSNumber numberWithLongLong:obj.key];
                [productArray addObject:num];
            }
        }
    }
    NSString *ids = @",";
    for(NSNumber *_id in productArray)
    {
        ids = [[ids stringByAppendingString:[_id stringValue]] stringByAppendingString:@","];
    }
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setValue:self.textView.text forKey:@"phoneNum"];
    [postDic setValue:ids forKey:@"productIds"];
    if (postDic == nil) {
        return;
    }
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/api/traffic/v2" Params:postDic Logo:@"traffic_get_data"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^
     {
         @try {
             [request setResponseEncoding:NSUTF8StringEncoding];
             NSString *responseString = [request responseString];
             NSDictionary *temp = [responseString JSONValueNewMy];
             if (temp == nil) {
                 showMessageBox(@"上报失败！");
                 return;
             }
             if(temp)
             {
                 showMessageBox(@"上报成功！");
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
         }
         @catch (NSException *exception) {
             showAlertBox(@"提示", exception.reason);
             return;
         }
         @finally {
             
         }
         
     }];
    [request setFailedBlock:^
     {
         [self hideActivityIndicator];
         showMessageBox(WEB_BASE_MSG_REQUESTOUTTIME);
     }];
    [request startAsynchronous];
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (self.textView.text.length != 11) {
        [self.tableView setHidden:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 22;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}
- (IBAction)postReport:(id)sender {
    if(self.textView.text == nil || [@"" isEqualToString:self.textView.text])
    {
        showMessageBox(@"您还未输入要上报的手机号码！");
        return;
}
[self postData];
    
}
@end
