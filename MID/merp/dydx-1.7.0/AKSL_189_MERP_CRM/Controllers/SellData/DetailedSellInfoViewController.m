//
//  DetailedSellInfoViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-9.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "DetailedSellInfoViewController.h"
#import "DetailedSellInfoView.h"

@interface DetailedSellInfoViewController ()

@end

@implementation DetailedSellInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    UIView * deview = [self.view viewWithTag:9523018];
    [deview setFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    DetailedSellInfoView * deview = [[DetailedSellInfoView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-44)];
    deview.type = [[ConfigManage getConfig:DATE_SELECT_KEY] isEqualToString:@"/year"]?0:1;
    deview.UserCode = _userCode;
    deview.tag = 9523018;
    [deview setBase:self];
    [self.view addSubview:deview];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
