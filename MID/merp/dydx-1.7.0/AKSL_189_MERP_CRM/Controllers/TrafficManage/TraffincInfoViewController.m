//
//  TraffincInfoViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "TraffincInfoViewController.h"
#import "TrafficTodayReportCell.h"
#import "TrafficInfoListController.h"

@interface TraffincInfoViewController (){
 bool isLonding;
LoginUser * longinUser;
}

@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@end

@implementation TraffincInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!isLonding) {
        CGRect farmes = _mainView.frame;
        farmes.origin.y = 0;
        farmes.size.height+=5;
        self.pagesContainer.view.frame = farmes;
        NSMutableArray * aryView = [NSMutableArray new];
        TrafficInfoListController * list = [[TrafficInfoListController alloc]initWithNibName:@"TrafficInfoListController" bundle:nil];
        list.title = @"流量销售";
        list.type = 10;
        list.pViewController = self;
        [aryView addObject:list];
        list = [[TrafficInfoListController alloc]initWithNibName:@"TrafficInfoListController" bundle:nil];
        list.title = @"流量应用";
        list.type = 11;
        list.pViewController = self;
        [aryView addObject:list];
        list = [[TrafficInfoListController alloc]initWithNibName:@"TrafficInfoListController" bundle:nil];
        list.title = @"流量使用";
        list.type = 13;
        list.pViewController = self;
        [aryView addObject:list];
        self.pagesContainer.viewControllers = aryView;
        [self.pagesContainer setSelectedIndex:self.type animated:YES];
        isLonding = YES;
    }
   
}

- (IBAction)GoBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //配置滑动页面
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.pagesContainer.topBarBackgroundColor = [UIColor whiteColor];
    [_mainView addSubview:self.pagesContainer.view];
    self.pagesContainer.delegate = self;
    [self.pagesContainer didMoveToParentViewController:self];
   
}

-(void)DidSelectedIndex:(NSUInteger)selectedIndex{
    TrafficInfoListController *view = (TrafficInfoListController *) self.pagesContainer.viewControllers[selectedIndex];
    [view reloadData:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
