//
//  DataForCommitViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-27.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "DataForCommitViewController.h"
#import "SellDataCell.h"

@interface DataForCommitViewController ()

@end

@implementation DataForCommitViewController

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
    NSDictionary *dic = [_listForData lastObject];
    _textForOne.text =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"completeOne"]integerValue]];
    _textForTow.text =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"completeTwo"]integerValue]];
    _textForThree.text =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"completeThree"]integerValue]];
    _textForFrou.text =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"completeFour"]integerValue]];
    
    UINib *nib = [UINib nibWithNibName:@"SellDataCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"CustomSellDataCell"];
}

//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_listForData){
        return _listForData.count-1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SellDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomSellDataCell"];
    
    NSDictionary * dic = [_listForData objectAtIndex:indexPath.row];
    NSString * isReport =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"isReport"]intValue]];
    bool report = NO;
    if (isReport&&![isReport isEqualToString:@"0"]) {
        report = YES;
    }
    [cell setData:[dic objectForKey:@"area"] Plan:[[dic objectForKey:@"completeOne"]integerValue] Today:[[dic objectForKey:@"completeTwo"]integerValue] Month:[[dic objectForKey:@"completeThree"]integerValue] Over:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"completeFour"]integerValue]] isCommit:report];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = [_listForData objectAtIndex:indexPath.row];
    long orgid = [[dic valueForKey:@"areaId"]longValue];
    NSString * title = @"手工上报";//[[dic valueForKey:@"area"]stringByAppendingString:@"上报"];
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
