//
//  TourRoundAddTagsViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-6-25.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TourRoundAddTagsViewController.h"
#import "AddTagsCell.h"
#import "DatePickerOperation.h"
#import "HttpApiCall.h"
#import "InspectStoreMainPage.h"


@interface TourRoundAddTagsViewController ()
{
    DatePickerOperation * datepicker;
    NSDate * startDate;
    NSDate * endDate;
    NSMutableArray *tableDataArray;
}

@end

@implementation TourRoundAddTagsViewController

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
    [self.dataTable setHidden:YES];
    [self._btnQingchu setHidden:YES];
    // Do any additional setup after loading the view from its nib.
    self.imgView.backgroundColor = [UIColor colorWithRed:0.518 green:0.714 blue:0.078 alpha:1];
    datepicker = [DatePickerOperation new];
    startDate = [[NSDate new] offsetDay:0];
    endDate = [[NSDate new] offsetDay:0];
    self.lblStartDay.text = [NSString stringWithFormat:@"%i",startDate.day];
    self.lblStartYear.text = [[[NSString stringWithFormat:@"%i",startDate.year] stringByAppendingString:@"-"] stringByAppendingString:[NSString stringWithFormat:@"%i",startDate.month]];

    self.lblEndDay.text = [NSString stringWithFormat:@"%i",endDate.day];
    self.lblEndYear.text = [[[NSString stringWithFormat:@"%i",endDate.year] stringByAppendingString:@"-"] stringByAppendingString:[NSString stringWithFormat:@"%i",endDate.month]];
    self.textContent.returnKeyType = UIReturnKeySearch;
    self.textContent.delegate = self;
    [self.dataTable registerNib:[UINib nibWithNibName:@"AddTagsCell" bundle:nil] forCellReuseIdentifier:@"addTagsCell"];
    tableDataArray = [NSMutableArray new];
    self.dataTable.dataSource = self;
    self.dataTable.delegate = self;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self._btnQingchu setHidden:NO];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [self._btnQingchu setHidden:YES];
        [self.textContent resignFirstResponder];
        [self.dataTable setHidden:NO];
        [tableDataArray removeAllObjects];
        [self setTableData];
        return NO;
    }
    
    return YES;
}
-(void)setTableData
{
    NSString *url = [NSString stringWithFormat:@"/api/common/so/tab/%@",self.textContent.text];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"collect_get_data"];
    __weak ASIFormDataRequest *request = requestx;
    //[self showActivityIndicator];
    [request setCompletionBlock:^
     {
         [request setResponseEncoding:NSUTF8StringEncoding];
         NSString *reArg = [request responseString];
         NSDictionary *dic = [reArg JSONValueNewMy];
         if (dic == nil) {
             showMessageBox(@"暂无数据！");
             return;
         }
         if ([[dic objectForKey:@"dataDic"] count] != 0) {
             for (int i=0;i<[[dic objectForKey:@"dataDic"] count];i++) {
                 NSMutableDictionary *newdic = [NSMutableDictionary new];
                 [newdic setObject:[dic objectForKey:@"dataDic"][i] forKey:@"name"];
                 [newdic setObject:@"btn_date_xuanze01.png" forKey:@"img"];
                 [tableDataArray addObject:newdic];
             }
         }
         if ([[dic objectForKey:@"areas"] count] != 0) {
             for (int i=0;i<[[dic objectForKey:@"areas"] count];i++) {
                 NSMutableDictionary *newdic = [NSMutableDictionary new];
                 [newdic setObject:[dic objectForKey:@"areas"][i] forKey:@"name"];
                 [newdic setObject:@"btn_date_xuanze01.png" forKey:@"img"];
                 [tableDataArray addObject:newdic];
             }
         }
         if ([[dic objectForKey:@"fzzs"] count] != 0) {
             for (int i=0;i<[[dic objectForKey:@"fzzs"] count];i++) {
                 NSMutableDictionary *newdic = [NSMutableDictionary new];
                 [newdic setObject:[dic objectForKey:@"fzzs"][i] forKey:@"name"];
                 [newdic setObject:@"btn_date_xuanze01.png" forKey:@"img"];
                 [tableDataArray addObject:newdic];
             }
         }
         if ([[dic objectForKey:@"tds"] count] != 0) {
             for (int i=0;i<[[dic objectForKey:@"tds"] count];i++) {
                 NSMutableDictionary *newdic = [NSMutableDictionary new];
                 [newdic setObject:[dic objectForKey:@"tds"][i] forKey:@"name"];
                 [newdic setObject:@"btn_date_xuanze01.png" forKey:@"img"];
                 [tableDataArray addObject:newdic];
             }
         }
         if ([[dic objectForKey:@"users"] count] != 0) {
             for (int i=0;i<[[dic objectForKey:@"users"] count];i++) {
                 NSMutableDictionary *newdic = [NSMutableDictionary new];
                 [newdic setObject:[dic objectForKey:@"users"][i] forKey:@"name"];
                 [newdic setObject:@"btn_date_xuanze01.png" forKey:@"img"];
                 [tableDataArray addObject:newdic];
             }
         }

         [self.dataTable reloadData];
     }];
    [request setFailedBlock:^{
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableDataArray.count == 0) {
        return 0;
    }
    return [tableDataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddTagsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addTagsCell"];
    if(!cell)
    {
        cell = [[AddTagsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addTagsCell"];
    }
    cell.textName.text = [[[tableDataArray objectAtIndex:indexPath.row] objectForKey:@"name"] objectForKey:@"label"];
    cell.xuanze.image = [UIImage imageNamed:[[tableDataArray objectAtIndex:indexPath.row] objectForKey:@"img"]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textContent resignFirstResponder];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.textContent resignFirstResponder];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i = 0; i<[tableDataArray count]; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:@"btn_date_xuanze01.png" forKey:@"img"];
        [dic setObject:[[tableDataArray objectAtIndex:i] objectForKey:@"name"] forKey:@"name"];
        [tableDataArray replaceObjectAtIndex:i withObject:dic];
    }
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"btn_date_xuanze02.png" forKey:@"img"];
    [dic setObject:[[tableDataArray objectAtIndex:indexPath.row] objectForKey:@"name"] forKey:@"name"];
    [tableDataArray replaceObjectAtIndex:indexPath.row withObject:dic];
    [self.dataTable reloadData];
    
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
-(void)setDate:(id)sender
{
    UIButton * but = sender;
    DatePickerOperation * datepickerTemp = datepicker;
    if (but.tag==100007) {
        datepickerTemp.curDate =startDate;
        [datepickerTemp setCallBacks:^(NSDate *curDate) {
            startDate = curDate;
            self.lblStartDay.text = [NSString stringWithFormat:@"%i",startDate.day];
            self.lblStartYear.text = [[[NSString stringWithFormat:@"%i",startDate.year] stringByAppendingString:@"-"] stringByAppendingString:[NSString stringWithFormat:@"%i",startDate.month]];
        }];
    }
    if (but.tag==100008) {
        datepickerTemp.curDate =endDate;
        [datepickerTemp setCallBacks:^(NSDate *curDate) {
            endDate = curDate;
            self.lblEndDay.text = [NSString stringWithFormat:@"%i",endDate.day];
            self.lblEndYear.text = [[[NSString stringWithFormat:@"%i",endDate.year] stringByAppendingString:@"-"] stringByAppendingString:[NSString stringWithFormat:@"%i",endDate.month]];
        }];
    }
    
    [self.view addSubview:datepicker];
}

- (IBAction)Complete:(id)sender {
    if (startDate.timeIntervalSince1970>endDate.timeIntervalSince1970) {
        showMessageBox(@"查询起始时间大于截止时间!");
        return;
    }
    if (tableDataArray.count == 0) {
        showMessageBox(@"请选择巡店！！");
        return;
    }
//    for (int i = 0 ; i<[tableDataArray count]; i++) {
//        if ([[[tableDataArray objectAtIndex:i] objectForKey:@"img"] isEqualToString:@"btn_date_xuanze02.png"]) {
            [self postData];
//        }
//    }
}
-(void)postData
{
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    NSDictionary *dic = [NSDictionary new];
    for (int i = 0 ; i<[tableDataArray count]; i++) {
        if ([[[tableDataArray objectAtIndex:i] objectForKey:@"img"] isEqualToString:@"btn_date_xuanze02.png"]) {
            dic = [[tableDataArray objectAtIndex:i] objectForKey:@"name"];
        }
    }
    NSString *startDateStr = [NSDate dateFormateDate:startDate FormatePattern:@"yyyyMMdd"];
    NSString *endDateStr = [NSDate dateFormateDate:endDate FormatePattern:@"yyyyMMdd"];
    NSString *str = [[startDateStr stringByAppendingString:@"-"] stringByAppendingString:endDateStr];
    
    [postDic setObject:[dic objectForKey:@"label"] forKey:@"title"];
    [postDic setObject:[dic objectForKey:@"label"] forKey:@"desc"];
    [postDic setObject:str forKey:@"period"];
    [postDic setObject:[dic objectForKey:@"value"] forKey:@"condition"];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/api/inspection/tab" Params:postDic Logo:@"inspection_tab"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^
     {
         [request setResponseEncoding:NSUTF8StringEncoding];
         NSString *responseString = [request responseString];
         NSDictionary * dicRes = [responseString JSONValueNewMy];
         if (!dicRes) {
             [self.navigationController popViewControllerAnimated:YES];
             showMessageBox(@"添加失败！");
             return;
         }
         _returnMethod(dicRes);
         [self.navigationController popViewControllerAnimated:YES];
     }];
    [request setFailedBlock:^
     {

     }];
    [request startAsynchronous];
}
- (IBAction)btnQingchu:(id)sender {
    self.textContent.text = @"";
    [self.dataTable setHidden:YES];
}

-(void) setRetureMethods:(RetureMethod) returnMethod{
    _returnMethod = returnMethod;
}
@end
