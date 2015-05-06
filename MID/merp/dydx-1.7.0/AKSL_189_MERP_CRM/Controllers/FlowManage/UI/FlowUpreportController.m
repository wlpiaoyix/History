//
//  FlowUpreportController.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-24.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "FlowUpreportController.h"
#import "UICommitFlowManager.h"
#import "ModleCheckBox.h"

@interface FlowUpreportController (){
    UICommitFlowManager *cvc;
}
@property (strong, nonatomic) IBOutlet UIButton *buttonReturn;
@property (strong, nonatomic) IBOutlet UIView *view01;

@end

@implementation FlowUpreportController
+(id) getNewInstance{
    return [[FlowUpreportController alloc] initWithNibName:@"FlowUpreportController" bundle:nil];
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
    self->cvc = [UICommitFlowManager getNewInstance];
    [self->cvc setController:self];
    [self->cvc  addCommitEvent:self Action:@selector(hiddenViewUpload)];
    [_buttonReturn addTarget:self action:@selector(hiddenViewUpload) forControlEvents:UIControlEventTouchUpInside];
    //==>
    CGRect r = cvc.frame;
    r.origin.y = 0;
    r.size.height = SCREEN_HEIGHT-44;
    cvc.frame = r;
    [_view01 addSubview:cvc];
    //<=
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void) hiddenViewUpload{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
