//
//  CustomerKeepController.m
//  FDC
//
//  Created by wlpiaoyi on 15/2/28.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "CustomerKeepController.h"
#import "CustomerInfoCell.h"
#import "CustomerMainManager.h"
#import "CreateNewCustomerViewController.h"
#import "CustomerKeepDetailController.h"

static NSString *CellIdentifier = @"CustomerInfoCell";

static UIColor *colorYellowBg;
static UIColor *colorBuleBg;

@interface CustomerKeepController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isFirstLoad;
}
@property (weak, nonatomic) IBOutlet UITextField *textFieldSearch;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearch;
@property (weak, nonatomic) IBOutlet UITableView *tableViewData;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@property (weak, nonatomic) IBOutlet UIButton *buttonPach;
@property (weak, nonatomic) IBOutlet UIButton *buttonName;
@property (weak, nonatomic) IBOutlet UIButton *buttonPhone;
@property (strong, nonatomic) NSArray *arrayData;
@property (strong, nonatomic) NSMutableArray *arraySelectedData;
@property (strong, nonatomic) CustomerMainManager *manager;
@end

@implementation CustomerKeepController
+(void) initialize{
    colorBuleBg = [UIColor colorWithRed:0.302 green:0.655 blue:0.851 alpha:1];
    colorYellowBg = [UIColor colorWithRed:1.000 green:0.816 blue:0.251 alpha:1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"客户管理"];
    self.manager = [CustomerMainManager new];
    self.tableViewData.delegate = self;
    self.tableViewData.dataSource = self;
    self.arraySelectedData = [NSMutableArray new];
    // Do any additional setup after loading the view from its nib.
    UINib *nib = [UINib nibWithNibName:CellIdentifier bundle:nil];
    [self.tableViewData registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    [_buttonSearch setBackgroundImage:[UIImage imageWithColor:colorBuleBg] forState:UIControlStateNormal];

    [_buttonPach setTitle:@"提 交" forState:UIControlStateSelected];
    [_buttonPach addTarget:self action:@selector(onclickReturns)];
    [_buttonPach setBackgroundImage:[UIImage imageWithColor:colorBuleBg] forState:UIControlStateNormal];
    
    [_buttonSearch addTarget:self action:@selector(onclickSearch)];
    [_buttonName setBackgroundImage:[UIImage imageWithColor:colorYellowBg] forState:UIControlStateSelected];
    [_buttonName setBackgroundImage:[UIImage imageWithColor:colorBuleBg] forState:UIControlStateNormal];
    [_buttonPhone setBackgroundImage:[UIImage imageWithColor:colorYellowBg] forState:UIControlStateSelected];
    [_buttonPhone setBackgroundImage:[UIImage imageWithColor:colorBuleBg] forState:UIControlStateNormal];
    [_buttonName setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_buttonName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buttonPhone setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [_buttonPhone setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_textFieldSearch setCornerRadiusAndBorder:1 BorderWidth:1 BorderColor:[UIColor colorWithHexString:@"222222FF"]];
    [_buttonName addTarget:self action:@selector(onclickName)];
    [_buttonPhone addTarget: self action:@selector(onclickPhone)];
    [_buttonAdd addTarget:self action:@selector(onclickAddCustomer)];
    [self onclickName];
    __weak typeof(self) weakself = self;
    [super setSELShowKeyBoardStart:nil End:^(CGRect keyBoardFrame) {
        [[weakself.view viewWithTag:547] setHidden:NO];
    }];
    [super setSELHiddenKeyBoardBefore:nil End:^(CGRect keyBoardFrame) {
        [[weakself.view viewWithTag:547] setHidden:YES];
    }];
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
    [[weakself.view viewWithTag:547] setHidden:YES];
    [[weakself.view viewWithTag:547] addGestureRecognizer:self.tapGestureRecognizer];
}
-(void) onclickName{
    _buttonName.selected = YES;
    _buttonPhone.selected = NO;
}
-(void) onclickPhone{
    _buttonPhone.selected = YES;
    _buttonName.selected = NO;
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(isFirstLoad == false){
        [self searchDataWithParam:nil index:0];
        isFirstLoad = true;
    }
}
-(void) onclickReturns{
    if(self.buttonPach.selected == false){
        self.buttonPach.selected = true;
        return;
    }
    
    if(![self.arraySelectedData count]){
        PopUpDialogVendorView *pv = [PopUpDialogVendorView alertWithMessage:@"请选择客户" title:@"提示" onclickBlock:^BOOL(PopUpDialogVendorView *dialogView, NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 1:
                {
                    self.buttonPach.selected = false;
                }
                    break;
                    
                default:
                    break;
            }
            return true;
        } buttonNames:@"确定",@"取消",nil];
        [pv show];
        return;
    }
    NSString *value = @"";
    for (CustomerInfoEntity *entity in self.arraySelectedData) {
        if(entity != self.arraySelectedData.firstObject){
            value = [value stringByAppendingString:@","];
        }
        value = [value stringByAppendingString:entity.customerId];
    }
    self.buttonPach.selected = false;
    [self.arraySelectedData removeAllObjects];
    [Utils showLoading:nil];
    [self.manager customerCallVisitWithIds:value success:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        [PYToast showWithText:@"提交成功!"];
        [self searchDataWithParam:@"" index:0];
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        [PYToast showWithText:@"网络异常!"];
    }];
    
}
-(void) onclickSearch{
    NSString *param = self.textFieldSearch.text;
    int falg = _buttonName.selected;
    [self searchDataWithParam:param index:falg];
}

-(void) searchDataWithParam:(NSString*) param index:(int) index{
    NSString *name = @"";
    NSString *phone = @"";
    switch (index) {
        case 1:{
            name = param;
        }
            break;
            
        default:{
            phone = param;
        }
            break;
    }
    [Utils showLoading:nil];
    __weak typeof(self) weakself = self;
    [self.manager queryCustomerWithObjectId:nil customerName:name customerPhone:phone certificate:nil visitDate:nil visitWay:nil orderLevel:nil tradeState:nil success:^(id data, NSDictionary *userInfo) {
        if(data&&[data isKindOfClass:[NSArray class]]){
            weakself.arrayData = data;
        }
        [Utils hiddenLoading];
        
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        
    }];
}
-(void) setArrayData:(NSArray *)arrayData{
    _arrayData = arrayData;
    [self.tableViewData reloadData];
}
-(void) onclickAddCustomer{
    CreateNewCustomerViewController *vc = [[CreateNewCustomerViewController alloc] initWithNibName:@"CreateNewCustomerViewController" bundle:nil];
    [self goNextController:vc];
}
#pragma delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerInfoEntity *entity = [self.arrayData objectAtIndex:indexPath.row];
    if(self.buttonPach.selected == false){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        CustomerKeepDetailController *c =[[CustomerKeepDetailController alloc] initWithNibName:@"CustomerKeepDetailController" bundle:nil];
        c.entity = entity;
        [self goNextController:c];
        return;
    }
    if([self.arraySelectedData containsObject:entity]){
        return;
    }
    [self.arraySelectedData addObject:entity];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.buttonPach.selected == false){
        return;
    }
    CustomerInfoEntity *entity = [self.arrayData objectAtIndex:indexPath.row];
    if([self.arraySelectedData containsObject:entity]){
        [self.arraySelectedData removeObject:entity];
    }
    
}


#pragma dataresource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomerInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    CustomerInfoEntity *entity = [self.arrayData objectAtIndex:indexPath.row];
    cell.entity = entity;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonAdd:(id)sender {
}
@end
