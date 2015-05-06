//
//  DataViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-6.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "DataViewController.h"
#import "SellDataCell.h"

@interface DataViewController ()

@end

@implementation DataViewController

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
    // Do any additional setup after loading the view from its nib.
    for (int i=30000; i<=30004; i++) {
        UILabel *view = (UILabel *)[self.view viewWithTag:i];
        if (view) {
            view.layer.borderColor = [UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1].CGColor;
            view.layer.borderWidth = 0.5;
            if (_fristName&&(i-29999)<=_fristName.count){
                view.text = _fristName[i-30000];
            }
            
        }
    }
    _textDayTotalCount.text = [((NSString *)_fristName[2])stringByAppendingString:@"销量"];
    _sumOfToday.text = @"0";
    _sunOfMonth.text = @"0";
    if (_listForTotal) {
        _sumOfToday.text = [NSString stringWithFormat:@"%d",[[_listForTotal objectAtIndex:0]integerValue]];
        _sunOfMonth.text = [NSString stringWithFormat:@"%d",[[_listForTotal objectAtIndex:1]integerValue]];
    }
    
    UINib *nib = [UINib nibWithNibName:@"SellDataCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"CustomSellDataCell"];
}

//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_listForData){
        return _listForData.count;
    }
    return 0;
}
 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SellDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomSellDataCell"];
   
    NSDictionary * dic = [_listForData objectAtIndex:indexPath.row];
    NSString * isReport = [dic objectForKey:@"isReport"];
    bool report = NO;
    if (isReport&&![isReport isEqualToString:@"0"]) {
        report = YES;
    }
    [cell setData:[dic objectForKey:@"area"] Plan:[[dic objectForKey:@"task"]integerValue] Today:[[dic objectForKey:@"cdComplete"]integerValue] Month:[[dic objectForKey:@"cmComplete"]integerValue] Over:[NSString stringWithFormat:@"%d%@",[[dic objectForKey:@"completeRate"]integerValue],@"%"] isCommit:report];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = [_listForData objectAtIndex:indexPath.row];
    long orgid = [[dic valueForKey:@"areaId"]longValue];
    NSString * title =@"系统日报";// [[dic valueForKey:@"area"]stringByAppendingString:@"日报"];
    if (_sellpage) {
        [_sellpage toNextPage:orgid Title:title];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
