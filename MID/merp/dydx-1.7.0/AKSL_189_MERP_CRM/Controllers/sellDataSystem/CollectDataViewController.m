//
//  CollectDataViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-7.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "CollectDataViewController.h"
#import "CollectDataCell.h"

@interface CollectDataViewController ()

@end

@implementation CollectDataViewController

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
    for (int i=30000; i<=30001; i++) {
        UILabel *view = (UILabel *)[self.view viewWithTag:i];
        if (view) {
            view.layer.borderColor = [UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1].CGColor;
            view.layer.borderWidth = 0.5;
            if (_fristName&&(i-29999)<=_fristName.count){
                view.text = _fristName[i-30000];
            }
        }
    }
    _SumSellData.text = @"0";
    if (_listForTotal) {
        _SumSellData.text = [NSString stringWithFormat:@"%d",_listForTotal];
    }
    _endTime.text = @"0000-00-00";
    _statrTime.text = @"0000-00-00";
    if (_startTimeStr) {
        _statrTime.text = _startTimeStr;
    }
    if(_endTimeStr){
        _endTime.text = _endTimeStr;
    }
    UINib *nib = [UINib nibWithNibName:@"CollectDataCell" bundle:nil];
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
    
   CollectDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomSellDataCell"];
    NSDictionary * dic = [_listForData objectAtIndex:indexPath.row];
    
    [cell setData:[dic objectForKey:@"area"] Value:[[dic objectForKey:@"complete"]integerValue]];
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
