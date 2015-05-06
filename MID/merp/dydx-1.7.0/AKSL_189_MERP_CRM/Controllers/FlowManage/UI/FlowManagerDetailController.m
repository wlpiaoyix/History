//
//  FlowManagerDetailController.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "FlowManagerDetailController.h"
#import "UICommitFlowManager.h"
#import "ModleCheckBox.h"
@interface FlowManagerDetailController (){
@private
    UICommitFlowManager *cfm;
}
@property (strong, nonatomic) IBOutlet UIView *view01;
@property (strong, nonatomic) IBOutlet UIButton *buttonReturn;

@end

@implementation FlowManagerDetailController
+(id) getNewInstance{
    return [[FlowManagerDetailController alloc] initWithNibName:@"FlowManagerDetailController" bundle:nil];
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
    
    cfm = [UICommitFlowManager getNewInstance];
    [cfm setButtonTargetHidden:YES];
    CGRect r = cfm.frame;
    r.origin = CGPointMake(0, 0);
    r.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-44);
    cfm.frame = r;
    [self.view01 addSubview:cfm];
    [_buttonReturn addTarget:self action:@selector(clickReturn:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) clickReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
