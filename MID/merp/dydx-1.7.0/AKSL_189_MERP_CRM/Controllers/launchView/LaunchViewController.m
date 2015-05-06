//
//  LaunchViewController.m
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-12.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "LaunchViewController.h"
#import "LoginViewController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectPage = 0;
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [ConfigManage clearFileCache];
    int numofpage = 4;
    CGRect frame = self.view.frame;
   int height = frame.size.height > 480?1136:480;
    UIImageView *imageview;
    frame.origin.y = 0;
    for (int i=0; i<numofpage; i++) {
        frame.origin.x = i*320;
        imageview = [[UIImageView alloc]initWithFrame:frame];
        imageview.image = [UIImage imageNamed:[NSString stringWithFormat:@"loading-%d-%d",i+1,height]];
        imageview.contentMode = UIViewContentModeTop;
        [_ScrollView addSubview:imageview];
    }
    frame = _ToLongin.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height - (height==480?20:50) - (IOS7_OR_LATER?20:0);
    frame.origin.x = 320*(numofpage -1 ) + 35;
    _ToLongin.frame = frame;
    [_ScrollView addSubview:_ToLongin];
    _ScrollView.contentSize = CGSizeMake(numofpage*320, frame.size.height);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    selectPage = 0;
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBackground:(id)sender {
    
        LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:login animated:YES];
}
@end
