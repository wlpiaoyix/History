//
//  FeedbackViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-13.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "FeedbackViewController.h"


@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

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
    [self setCornerRadiusAndBorder:[self textContent]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Submit:(id)sender {
}
@end
