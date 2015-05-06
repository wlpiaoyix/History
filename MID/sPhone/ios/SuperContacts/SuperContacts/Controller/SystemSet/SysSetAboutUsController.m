//
//  SysSetAboutUsController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-3-10.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SysSetAboutUsController.h"

@interface SysSetAboutUsController ()

@end

@implementation SysSetAboutUsController
+(id) getNewInstance{
    SysSetAboutUsController *c = [[SysSetAboutUsController alloc] initWithNibName:@"SysSetAboutUsController" bundle:nil];
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
    UIButton *buttonReturn = (UIButton*)[self.view viewWithTag:95401];
    [buttonReturn addTarget:self action:@selector(clickReturn:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void) clickReturn:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
