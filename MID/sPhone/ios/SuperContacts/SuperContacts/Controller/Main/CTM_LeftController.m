//
//  CTM_LeftController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-8.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_LeftController.h"
#import "CTM_MainController.h"
#import "ET_PhoneNumController.h"
#import "SysSetMainController.h"
#import "CloubContentsController.h"
#import "UIViewController+MMDrawerController.h"
static CTM_LeftController *xleftController;
@interface CTM_LeftController ()
@property (strong, nonatomic) IBOutlet UILabel *lableLocationPhoneNum;

@end

@implementation CTM_LeftController
+(id) getSingleInstance{
    @synchronized(xleftController){
        if(!xleftController){
            xleftController = [[CTM_LeftController alloc]initWithNibName:@"CTM_LeftController" bundle:nil];
        }
    }
    return xleftController;
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
    if([ConfigManage getCurrentUser]){
        _lableLocationPhoneNum.text = [ConfigManage getCurrentUser].phoneNum;
    }else{
        _lableLocationPhoneNum.text = CMCK_LOCATIONPHONENUM;
    }
}

- (IBAction)mainButtonCilck:(id)sender {
    UIButton *but = (UIButton *)sender;
    UIViewController * view = nil;
    switch (but.tag) {
        case 1001:
            view = [CTM_MainController getSingleInstance];
            break;
        case 1002:
            view = [CTM_MainController getSingleInstance];
            break;
        case 1003:
            view = [ET_PhoneNumController getNewInstance];
            break;
        case 1004:
            view = [CloubContentsController getNewleInstance];
            break;
        case 1005:
            view = [SysSetMainController getSingleInstance];
            break;
        default:
            view = [CTM_MainController getSingleInstance];
            break;
    }
    if(view!=nil){
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:view];
        nav.navigationBar.hidden = YES;
        [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
