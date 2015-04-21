//
//  CustomerKeepDetailController.m
//  FDC
//
//  Created by wlpiaoyi on 15/3/9.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "CustomerKeepDetailController.h"
#import "TelephoneCenter.h"

@interface CustomerKeepDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *lableUserName;
@property (weak, nonatomic) IBOutlet UILabel *lableSex;
@property (weak, nonatomic) IBOutlet UILabel *lableByStatus;
@property (weak, nonatomic) IBOutlet UILabel *lableFirstTime;
@property (weak, nonatomic) IBOutlet UILabel *lableFollowUpTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonMessage;
@property (weak, nonatomic) IBOutlet UIButton *buttonCall;
@property (weak, nonatomic) IBOutlet UIButton *buttonBaseInfo;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheckPrice;
@property (weak, nonatomic) IBOutlet UIButton *buttonQuerstionary;

@end

@implementation CustomerKeepDetailController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"客户管理详情"];
    [_buttonBaseInfo setCornerRadiusAndBorder:2 BorderWidth:0 BorderColor:nil];
    [_buttonCheckPrice setCornerRadiusAndBorder:2 BorderWidth:0 BorderColor:nil];
    [_buttonQuerstionary setCornerRadiusAndBorder:2 BorderWidth:0 BorderColor:nil];
    [_buttonBaseInfo setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.302 green:0.655 blue:0.851 alpha:1]] forState:UIControlStateNormal];
    [_buttonCheckPrice setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.302 green:0.655 blue:0.851 alpha:1]] forState:UIControlStateNormal];
    [_buttonQuerstionary setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.302 green:0.655 blue:0.851 alpha:1]] forState:UIControlStateNormal];
    [_buttonBaseInfo addTarget:self action:@selector(onclickBaseInfo)];
    [_buttonCheckPrice addTarget:self action:@selector(onclickCheckPrice)];
    [_buttonQuerstionary addTarget:self action:@selector(onclickQuerstionary)];
//    _lableFollowUpTime.text = _entity.customerVisitDate;
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _lableUserName.text = _entity.customerName;
    _lableSex.text = _entity.customerSex;
    _lableFirstTime.text = _entity.visitDate;
    int level = _entity.costomerLevel.intValue;
    for (int i=1; i<=5; i++) {
        BOOL value = level>=i;
        UIButton *b = (UIButton*)[self.view viewWithTag:25300+i];
        b.selected = value;
    }
}
-(void) onclickBaseInfo{
}
-(void) onclickCheckPrice{
}
-(void) onclickQuerstionary{
}

-(void) onclickCall{
    if(_entity.customerPhone != nil){
        [TelephoneCenter requestCallWithRecipient:_entity.customerPhone];
    }else{
        [Utils showAlert:@"找不到联系方式" title:nil];
    }
}
-(void) onclickMessage{
    if(_entity.customerPhone != nil){
        [TelephoneCenter requestSMSWithRecipients:@[_entity.customerPhone] message:@"短信"];
    }else{
        [Utils showAlert:@"找不到联系方式" title:nil];
    }
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

@end
