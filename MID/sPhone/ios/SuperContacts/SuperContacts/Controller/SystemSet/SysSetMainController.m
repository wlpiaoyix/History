//
//  SysSetMainController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-1.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "SysSetMainController.h"
#import "SysSetPersonInfoController.h"
#import "LoginController.h"
#import "CloubContentsController.h"
#import "UIViewController+MMDrawerController.h"
#import "SysSetOpinionFreeBackController.h"
#import "SysSetAboutUsController.h"
static SysSetMainController *xSysSetMainController;
@interface SysSetMainController (){
@private UIColor *bgcolor;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (strong, nonatomic) IBOutlet UIView *view0101;
@property (strong, nonatomic) IBOutlet UIView *view02;
@property (strong, nonatomic) IBOutlet UIView *view0201;
@property (strong, nonatomic) IBOutlet UIView *view03;
@property (strong, nonatomic) IBOutlet UIView *view0302;

@end

@implementation SysSetMainController

+(id) getSingleInstance{
    @synchronized(xSysSetMainController){
        if(!xSysSetMainController){
            xSysSetMainController = [[SysSetMainController alloc]initWithNibName:@"SysSetMainController" bundle:nil];
        }
    }
    return xSysSetMainController;
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
    _scrollViewMain.scrollEnabled = YES;
    CGRect r = _scrollViewMain.frame;
    r.size.height = COMMON_SCREEN_H-44;
    _scrollViewMain.frame = r;
    _scrollViewMain.contentSize = CGSizeMake(_scrollViewMain.contentSize.width, COMMON_SCREEN_H-43);
    [self setCornerRadiusAndBorder:_view0101 CornerRadius:0];
    [self setCornerRadiusAndBorder:_view02 CornerRadius:0];
    [self setCornerRadiusAndBorder:_view0201 CornerRadius:0];
    [self setCornerRadiusAndBorder:_view03 CornerRadius:0];
    [self setCornerRadiusAndBorder:_view0302 CornerRadius:0];
    bgcolor = [UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.3];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)clickPersonSet:(id)sender {
    [self clickCallBack:sender];
    SysSetPersonInfoController *sspic = [SysSetPersonInfoController getNewInstance];
    ModleUser *user = [ConfigManage getCacheUser]?[ConfigManage getCacheUser]:[ConfigManage getCurrentUser];
    if(!user){
        user = [ModleUser new];
        user.phoneNum = CMCK_LOCATIONPHONENUM;
    }
    [sspic setUserx:user];
    [self.mm_drawerController.navigationController pushViewController:sspic animated:YES];
}
- (IBAction)clickClearCache:(id)sender {
    [self clickCallBack:sender];
//    [ConfigManage clearAllCacheData];
    [ConfigManage clearAllTempData];
    COMMON_SHOWALERT(@"缓存已清理!");
}
- (IBAction)clickContentsSet:(id)sender {
    [self clickCallBack:sender];
    COMMON_SHOWALERT(@"暂未开放此功能,敬请等待!");
}
- (IBAction)clickOpinionBack:(id)sender {
    [self clickCallBack:sender];
    [self.mm_drawerController.navigationController pushViewController:[SysSetOpinionFreeBackController getSingleInstance] animated:YES];
}
- (IBAction)clickIntroduce:(id)sender {
    [self clickCallBack:sender];
    [self.navigationController pushViewController:[SysSetAboutUsController getNewInstance] animated:YES];
}
- (IBAction)clickCheckEdtion:(id)sender {
    [self clickCallBack:sender];
    COMMON_SHOWALERT(@"已是最新版本!");
}
- (IBAction)clickLogout:(id)sender {
    COMMON_SHOWMSGDELEGATE(@"确定退出登录吗?", self, @"是",@"否",nil);
}
- (void)alertView:(PopUpDialogView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            LoginController *lc = [LoginController getNewInstance];
            [self.navigationController pushViewController:lc animated:YES];
            [alertView close];
        }
            break;
        default:
            break;
    }
}
- (IBAction)clickReturn:(id)sender {
    [super topLeftOrRight:ENUM_BVCLEFT];
}
-(void) clickCallBack:(UIView*) targetView{
    UIColor *color = targetView.backgroundColor;
    if(color.CGColor==bgcolor.CGColor){
        return;
    }
    targetView.backgroundColor = bgcolor;
    NSThread *t = [[NSThread alloc]initWithTarget:self selector:@selector(setTargetViewBG:) object:targetView];
    [t start];
}
-(void) setTargetViewBG:(UIView*) targetView{
    [NSThread sleepForTimeInterval:0.2];
    targetView.backgroundColor = [UIColor clearColor];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
