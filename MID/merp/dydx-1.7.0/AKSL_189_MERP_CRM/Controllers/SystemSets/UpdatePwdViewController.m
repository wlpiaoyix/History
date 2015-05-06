//
//  UpdatePwdViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-13.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UpdatePwdViewController.h"

@interface UpdatePwdViewController ()

@end

@implementation UpdatePwdViewController

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
    [self setCornerRadiusAndBorder:[self textOne]];
    [self setCornerRadiusAndBorder:[self textThree]];
    [self setCornerRadiusAndBorder:[self textTwo]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updatePwd:(id)sender {
}
@end
