//
//  TourRoundContentViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-6-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TourRoundContentViewController.h"
#import "InspectStoreListViewController.h"

@interface TourRoundContentViewController ()
{
    NSArray *tableContent;
    //UITableView *_table;
    NSInteger indexOne;
    NSInteger indexTow;
}

@end

@implementation TourRoundContentViewController

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
    [self._table setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bar_bg.png"]]];
    [self._table setHidden:YES];
    indexOne = 0;
    indexTow = 0;
    InspectStoreListViewController * list = [[InspectStoreListViewController alloc]initWithNibName:@"InspectStoreListViewController" bundle:nil];
    list.ids = 77;
    list.CountForMsg = 10;
    [list setMainView:self];
    [list willMoveToParentViewController:self];
    list.view.frame = CGRectMake(0., 0., _mainView.frame.size.width, self.mainView.frame.size.height);
    [_mainView addSubview:list.view];
    [list didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)xundian_chaodian:(id)sender {
    UIButton *bt = (UIButton *)[self.view viewWithTag:140];
    
    [bt setImage:[UIImage imageNamed:@"btn_zan_pinglun02.png"] forState:UIControlStateNormal];
    
    UIButton *btn = sender;
    indexTow = 1;
    if (indexOne == 2) {
        btn.tag = 110;
        indexOne = 0;
    }
    if (btn.tag != 120) {
        [btn setImage:[UIImage imageNamed:@"btn_xundian_001.png"] forState:UIControlStateNormal];
        NSArray *array = [[NSArray alloc] initWithObjects:@"全部",@"炒店",@"巡店",@"竞争对手活动", nil];
        [self._table setHidden:NO];
        self._table.frame = CGRectMake(170, 65, 150, 175);
        tableContent = array;
        self._table.delegate = self;
        self._table.dataSource = self;
        [self._table reloadData];
        btn.tag = 120;
        
    }
    else if(btn.tag == 120)
    {
        [btn setImage:[UIImage imageNamed:@"btn_xundian_002.png"] forState:UIControlStateNormal];
        [self._table setHidden:YES];
        btn.tag = 110;
    }
    
}

- (IBAction)zan_pinglun:(id)sender {
    UIButton *bt = (UIButton *)[self.view viewWithTag:120];
    
    [bt setImage:[UIImage imageNamed:@"btn_xundian_002.png"] forState:UIControlStateNormal];
    
    UIButton *btn = sender;
    indexOne = 2;
    if (indexTow == 1) {
        btn.tag = 110;
        indexTow = 0;
    }
    if (btn.tag != 140) {
        [btn setImage:[UIImage imageNamed:@"btn_zan_pinglun01.png"] forState:UIControlStateNormal];
        NSArray *array = [[NSArray alloc] initWithObjects:@"最新",@"点赞",@"评论", nil];
        [self._table setHidden:NO];
        self._table.frame = CGRectMake(170, 65, 150, 130);
        tableContent = array;
        self._table.delegate = self;
        self._table.dataSource = self;
        [self._table reloadData];
        btn.tag = 140;
    }
   else if (btn.tag == 140)
   {
       [btn setImage:[UIImage imageNamed:@"btn_zan_pinglun02.png"] forState:UIControlStateNormal];
       [self._table setHidden:YES];
       btn.tag = 130;
   }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [tableContent objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bar_bg.png"]];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableContent count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}
@end
