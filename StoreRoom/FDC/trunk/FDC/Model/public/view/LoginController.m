//
//  LoginController.m
//  FDC
//
//  Created by wlpiaoyi on 15/1/22.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "LoginController.h"
#import "LoginFieldView.h"
#import "UserManager.h"
#import "FDCNavigationController.h"
#import "Utils+Expand.h"
#import "ConfigManage+Expand.h"
#import "customerIndexViewController.h"
#import "TelephoneCenter.h"
#import "CustomerOptInfoView.h"

@interface LoginController (){
}
@property (nonatomic) float viewY;
@property (nonatomic,strong) UserManager *userManager;
@property (nonatomic,strong) UIImageView *imageViewBg;
@property (nonatomic,strong) AsyncImageView *imageViewUserHead;
@property (nonatomic,strong) LoginFieldView *filedViewObject;
@property (nonatomic,strong) LoginFieldView *filedViewUser;
@property (nonatomic,strong) LoginFieldView *filedViewPassword;
@property (nonatomic,strong) UIButton *buttonLogin;
@property (nonatomic,strong) UIImageView *imageViewLogo;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [ConfigManage initialize];
    _userManager = [UserManager new];
    [self setTitle:@"登  陆"];
    [self createBg];
    [self createField];
    [self createImageViewUserHead];
    [self createImageViewLogo];
    [self.navigationController setToolbarHidden:YES];
    __weak typeof(self) weakself = self;
    [self setSELShowKeyBoardStart:^{
        
    } End:^(CGRect keyBoardFrame) {
        float bottom = weakself.view.frameHeight - weakself.buttonLogin.frameHeight-weakself.filedViewPassword.frameY-5;
        bottom = keyBoardFrame.size.height-bottom;
        if (bottom>0) {
            weakself.view.frameY = weakself.viewY-bottom;
        }
        
        
    }];
    [self setSELHiddenKeyBoardBefore:^{
        
    } End:^(CGRect keyBoardFrame) {
        weakself.view.frameY = weakself.viewY;
    }];
    // Do any additional setup after loading the view from its nib.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _viewY = self.view.frameY;
    BOOL flag = false;
    if ([NSString isEnabled:LoginUserName]) {
        [_filedViewUser setFiledValue:LoginUserName];
        flag = true;
    }
    if ([NSString isEnabled:LoginUserPassoword]) {
        [_filedViewPassword setFiledValue:LoginUserPassoword];
        flag = flag&&true;
    }
    if (flag) {
    }
}
-(void) createBg{
    _imageViewBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_back.png"]];
    [_imageViewBg setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:_imageViewBg];
    [ViewAutolayoutCenter persistConstraintRelation:_imageViewBg margins:UIEdgeInsetsMake(0, 0, 0, 0) toItems:nil];
}
-(void) createField{
    _filedViewObject = [LoginFieldView new];
    _filedViewUser = [LoginFieldView new];
    _filedViewPassword = [LoginFieldView new];
    [_filedViewObject setTitle:@"项目" placeholder:@"请输入项目名称"];
    [_filedViewUser setTitle:@"账号" placeholder:@"请输入您的账号"];
    [_filedViewPassword setTitle:@"密码" placeholder:@"请输入您的密码"];
    [_filedViewPassword setSecureTextEntry:YES];
    
    CGRect r = CGRectMake(0, DisableConstrainsValueMAX, 260, 40);
    _filedViewObject.frame = _filedViewUser.frame = _filedViewPassword.frame = r;
    
    _filedViewObject.frameY = -r.size.height-25;
    _filedViewUser.frameY = -10;
    _filedViewPassword.frameY = r.size.height+5;
    [self.view addSubview:_filedViewObject];
    [self.view addSubview:_filedViewUser];
    [self.view addSubview:_filedViewPassword];
    
    [ViewAutolayoutCenter persistConstraintSize:_filedViewObject];
    [ViewAutolayoutCenter persistConstraintSize:_filedViewUser];
    [ViewAutolayoutCenter persistConstraintSize:_filedViewPassword];
    
    [ViewAutolayoutCenter persistConstraintCenter:_filedViewObject];
    [ViewAutolayoutCenter persistConstraintCenter:_filedViewUser];
    [ViewAutolayoutCenter persistConstraintCenter:_filedViewPassword];
    
    
    _buttonLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonLogin setTitle:@"登 陆" forState:UIControlStateNormal];
    [_buttonLogin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_buttonLogin setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1.000 green:0.816 blue:0.251 alpha:1]] forState:UIControlStateNormal];
    [_buttonLogin setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    [self.view addSubview:_buttonLogin];
    r.origin.x = 0;r.origin.y = DisableConstrainsValueMAX;
    _buttonLogin.frame = r;
    [_buttonLogin addTarget:self action:@selector(onclickLogin)];
    [_buttonLogin setCornerRadiusAndBorder:5 BorderWidth:0 BorderColor:nil];
    [ViewAutolayoutCenter persistConstraintSize:_buttonLogin];
    [ViewAutolayoutCenter persistConstraintCenter:_buttonLogin];
    [ViewAutolayoutCenter persistConstraintRelation:_buttonLogin margins:UIEdgeInsetsMake(40, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX) toItems:@{@"top":_filedViewPassword}];
    
}
-(void) createImageViewUserHead{
    
    UIView *tempView = [UIView new];
    [tempView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tempView];
    [ViewAutolayoutCenter persistConstraintRelation:tempView margins:UIEdgeInsetsMake(0, 0, 0, 0) toItems:@{@"bottom":_filedViewObject}];

    _imageViewUserHead = [[AsyncImageView alloc] initWithImage:[UIImage imageNamed:@"login_head.png"]];
    [_imageViewUserHead setContentMode:UIViewContentModeScaleToFill];
    [tempView addSubview:_imageViewUserHead];
    float width = 60;
    if (appWidth()>320) {
        width = 70;
    }
    [_imageViewUserHead setFrame:CGRectMake(0, 0, width, width)];
    [ViewAutolayoutCenter persistConstraintSize:_imageViewUserHead];
    [ViewAutolayoutCenter persistConstraintCenter:_imageViewUserHead];
}
-(void) createImageViewLogo{
    UIView *tempView = [UIView new];
    [tempView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tempView];
    [ViewAutolayoutCenter persistConstraintRelation:tempView margins:UIEdgeInsetsMake(0, 0, 0, 0) toItems:@{@"top":_buttonLogin}];
    
    
    UIImage *imageLogo = [UIImage imageNamed:@"login_logo.png"];
    _imageViewLogo = [[UIImageView alloc] initWithImage:imageLogo];
    [_imageViewLogo setContentMode:UIViewContentModeScaleToFill];
    [tempView addSubview:_imageViewLogo];
    
    [_imageViewLogo setFrame:CGRectMake(0, 0, appWidth()*1/3, appWidth()*1/3/(imageLogo.size.width/imageLogo.size.height))];
    [ViewAutolayoutCenter persistConstraintSize:_imageViewLogo];
    [ViewAutolayoutCenter persistConstraintCenter:_imageViewLogo];
}
-(void) onclickLogin{
    NSString *userName = [self.filedViewUser filedValue];
    NSString *password = [self.filedViewPassword filedValue];
    if (![NSString isEnabled:userName]) {
        [Utils showAlert:@"请输入用户名!" title:nil];
        return;
    }
    if (![NSString isEnabled:password]) {
        [Utils showAlert:@"请输入密码!" title:nil];
        return;
    }
    [Utils showLoading:nil];
    [self.userManager loginWithUserName:userName password:password success:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        if (data){
            [Utils setRootControlerForSell:[UIViewController new]];
        }
    } faild:^(id data, NSDictionary *userInfo) {
        [Utils hiddenLoading];
        [Utils showAlert:@"网络连接失败" title:nil];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
