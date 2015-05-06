//
//  FlowPhotoViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-26.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "FlowPhotoViewController.h"
#import "UIScrollViewScanShowOpt.h"

@interface FlowPhotoViewController ()
@property (strong, nonatomic) IBOutlet UIView *view01;

@end

@implementation FlowPhotoViewController

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
    UIScrollViewScanShowOpt *izs = [UIScrollViewScanShowOpt new];
    [izs _setRects:CGRectMake(0, 0, COMMON_SCREEN_W, COMMON_SCREEN_H-42)];
    NSArray *images = [[NSArray alloc] initWithObjects:_imageView, nil];
    [izs setViewImages:images];
    [self.view01 addSubview:izs];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)clickReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
