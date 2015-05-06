//
//  FlowManageViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-17.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "FlowManageViewController.h"
#import "MainFlowInfoCell.h"
#import "UIContextsFlow.h"
#import "ModleCheckBox.h"
#import "ModleCheckType.h"
#import "UIFlowInfoView.h"
#import "UIPersonFlowView.h"
#import "UIPersonalFlowManagerView2.h"
#import "UIViewController+MMDrawerController.h"
@interface FlowManageViewController (){
@private
    UIColor *colorTaget;
    UIColor *colorDefault;
    UIColor *colorSubTitle;
    int indexCheckView;
}
@property (strong, nonatomic) IBOutlet UIView *viewMain;
@property (strong, nonatomic) IBOutlet UIView *viewFlow;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewFlowContent;
@property (strong, nonatomic) IBOutlet UIView *viewFlowReport;
@property (strong, nonatomic) IBOutlet UIView *viewFlowQuery;

@property (strong, nonatomic) IBOutlet UIButton *buttonToMain;
@property (strong, nonatomic) IBOutlet UIButton *buttonReport;
@property (strong, nonatomic) IBOutlet UIButton *buttonQuery;

@property (strong, nonatomic) IBOutlet UILabel *lableFlag;

@end

@implementation FlowManageViewController

static FlowManageViewController * mainpage;

+(id) getNewInstance{
   
    if (!mainpage) {
         mainpage = [[FlowManageViewController alloc] initWithNibName:@"FlowManageViewController" bundle:nil];
        mainpage->colorTaget = [UIColor colorWithRed:0.682 green:0.859 blue:0.475 alpha:1];
        mainpage->colorDefault = [UIColor colorWithRed:0.416 green:0.416 blue:0.416 alpha:1];
        mainpage->colorSubTitle = [UIColor colorWithRed:0.988 green:1.000 blue:0.957 alpha:1];
    }
    return mainpage;
    
}
+(void)newInstance{
    if(mainpage){
        [mainpage removeFromParentViewController];
        mainpage = nil;
    }
    mainpage = [[FlowManageViewController alloc] initWithNibName:@"FlowManageViewController" bundle:nil];
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
    
    //==>
    CGRect r = _scrollViewFlowContent.frame;
    [_scrollViewFlowContent setFrame:CGRectMake(r.origin.x, r.origin.y, r.size.width*2, r.size.height)];
    CGSize s =  _scrollViewFlowContent.contentSize;
    s.width = r.size.width;
    _scrollViewFlowContent.contentSize = s;
    [_scrollViewFlowContent setScrollEnabled:NO];
    
    r = _viewFlowReport.frame;
    r.origin.x = 0;
    r.origin.y = 0;
    r.size.width = SCREEN_WIDTH;
    r.size.height = SCREEN_HEIGHT-44-_buttonQuery.frame.size.height;
    _viewFlowReport.frame = r;
    
    r = _viewFlowQuery.frame;
    r.origin.x = SCREEN_WIDTH;
    r.origin.y = 0;
    r.size.width = SCREEN_WIDTH;
    r.size.height = SCREEN_HEIGHT-44-_buttonQuery.frame.size.height;
    _viewFlowQuery.frame = r;
    //<==
    
    //==>
    [_viewMain addSubview:_viewFlow];
    [_scrollViewFlowContent addSubview:_viewFlowReport];
    [_scrollViewFlowContent addSubview:_viewFlowQuery];
    //<==
    
    //==>
    [_buttonReport addTarget:self action:@selector(clickReport:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonQuery addTarget:self action:@selector(clickQuery:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonToMain addTarget:self action:@selector(cilckToptoLeft:) forControlEvents:UIControlEventTouchUpInside];
    //<==
    
    //==>
    [self checkScrollView:indexCheckView Animated:NO];
    //<==
}
-(void) viewWillAppear:(BOOL)animated{
    [self checkScrollView:indexCheckView Animated:NO];
    [super viewWillAppear:animated];
    UIFlowInfoView *fv = (UIFlowInfoView*)[_viewFlowReport viewWithTag:43356];
    [fv reloadAllData];
}
-(void) clickReport:(id) sender{
    indexCheckView = 0;
    [self checkScrollView:indexCheckView Animated:YES];
}
-(void) clickQuery:(id) sender{
    indexCheckView = 1;
    [self checkScrollView:indexCheckView Animated:YES];
}
-(void) checkScrollView:(int) index Animated:(bool) animated{
    __weak typeof(self) tempself = self;
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect r =  tempself.lableFlag.frame ;
            r.origin.x = r.size.width*index;
            tempself.lableFlag.frame = r;
        }];
    }else{
        CGRect r =  tempself.lableFlag.frame ;
        r.origin.x = r.size.width*index;
        tempself.lableFlag.frame = r;
    }
    [_scrollViewFlowContent setContentOffset:CGPointMake(SCREEN_WIDTH*index, 0) animated:animated];
    switch (index) {
        case 0:
        {
        
            [_buttonReport setSelected:YES];
            [_buttonQuery setSelected:NO];
            NSArray *temp = [_viewFlowReport subviews];
            if(!(temp&&[temp count])){
                UIFlowInfoView *fv = [UIFlowInfoView getNewInstance];
                [fv setController:self];
                fv.tag = 43356;
                [_viewFlowReport addSubview:fv];
            }
        }
            break;
        case 1:
        {
            [_buttonQuery setSelected:YES];
            [_buttonReport setSelected:NO];
            NSArray *temp = [_viewFlowQuery subviews];
            if(!(temp&&[temp count])){
//                UIPersonFlowView *pfv = [UIPersonFlowView getNewInstance];
//                [pfv setController:self];
//                CGRect r = pfv.frame;
//                r.size = _viewFlowQuery.frame.size;
//                pfv.frame = r;
                UIPersonalFlowManagerView2 *p = [UIPersonalFlowManagerView2 getNewInstance];
                CGRect r = p.frame;
                r.size = _viewFlowQuery.frame.size;
                p.frame = r;
                [p setController:self];
                [_viewFlowQuery addSubview:p];
            }
        }
    break;
    
        default:
            break;
    }
}
-(void) cilckToptoLeft:(id) sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
