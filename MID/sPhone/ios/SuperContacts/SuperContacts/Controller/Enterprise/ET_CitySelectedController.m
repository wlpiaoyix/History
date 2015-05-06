//
//  ET_CitySelectedController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 3/21/14.
//  Copyright (c) 2014 wlpiaoyi. All rights reserved.
//

#import "ET_CitySelectedController.h"
#import "ET_CityTypeCell.h"
#import "UIRecordPhoneHeadView.h"

@interface ET_CitySelectedController (){
    IBOutlet UIButton *buttonReturn;
    IBOutlet UIButton *buttonConfirm;
    IBOutlet UITableView *tableViewCitys;
@private
    NSMutableArray * cityDatas;
}

@end

@implementation ET_CitySelectedController
+(id) getNewIntance{
    ET_CitySelectedController *c = [[ET_CitySelectedController alloc] initWithNibName:@"ET_CitySelectedController" bundle:nil];
    c->cityDatas = [NSMutableArray new];
    UINib *nib = [UINib nibWithNibName:@"ET_CityTypeCell" bundle:nil];
    [c->tableViewCitys registerNib:nib forCellReuseIdentifier:@"ET_CityTypeCell"];
    return c;
}
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
    [buttonReturn addTarget:self action:@selector(clickReturn:) forControlEvents:UIControlEventTouchUpInside];
    [buttonConfirm addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    tableViewCitys.showsHorizontalScrollIndicator = NO;
    tableViewCitys.showsVerticalScrollIndicator = NO;
    tableViewCitys.delegate = self;
    tableViewCitys.dataSource = self;
}
//==>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int countRpvArrayx = (int)[((NSArray*)self->cityDatas[section]) count];
    return countRpvArrayx;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    int section = [indexPath section];
    ET_CityTypeCell *rpc  = [tableView dequeueReusableCellWithIdentifier:@"ET_CityTypeCell"];
    return rpc;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [cityDatas count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section==0?@"所在城市":@"可选城市";
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 22.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIRecordPhoneHeadView  *rphv = [UIRecordPhoneHeadView getNewInstance];
    [rphv setHeadText:section==0?@"所在城市":@"可选城市"];
    rphv.backgroundColor =  [UIColor colorWithRed:0.114 green:0.463 blue:0.784 alpha:0.7];
    return rphv;
}
//<==

-(void) clickReturn:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) clickConfirm:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
