//
//  CTM_RecordDetailController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-15.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_RecordDetailController.h"
#import "CTM_RecordCell.h"
#import "CTM_AddContentController.h"
#import "EMAsyncImageView.h"
#import "EntityUser.h"
#import "SerCallService.h"
#import "UIViewController+MMDrawerController.h"
#import "CTM_MainController.h"
@interface CTM_RecordDetailController (){
@private NSString *callPhoneNum;
}
@property (strong, nonatomic) IBOutlet EMAsyncImageView *imageHead;
@property (strong, nonatomic) IBOutlet UILabel *lableUserName;
@property (strong, nonatomic) IBOutlet UITableView *tableViewRecorde;

@property (strong, nonatomic) IBOutlet UIButton *buttonAddContent;
@property (strong, nonatomic) IBOutlet UIButton *buttonCallContent;

@end

@implementation CTM_RecordDetailController

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
    _imageHead.isIgnoreCacheFile = YES;
    __weak typeof(self) tempself = self;
    _tableViewRecorde.delegate = tempself;
    _tableViewRecorde.dataSource = tempself;
    EntityUser *user = [_curRecord getEntityUser];
    callPhoneNum = _curRecord.callPhoneNum;
    if(user&&user.userId){
        if(user.dataImage&&[NSString isEnabled:user.dataImage]){
            _imageHead.image = [UIImage imageWithContentsOfFile:user.dataImage];
        }
        _lableUserName.text = user.userName;
        [_buttonAddContent setHidden:YES];
        CGRect r = _buttonCallContent.frame;
        r.origin.x = (COMMON_SCREEN_W-r.size.width)/2;
        _buttonCallContent.frame = r;
    }else{
        _lableUserName.text = _curRecord.callPhoneNum;
    }
    [_buttonAddContent addTarget:self action:@selector(clickButtonAddContent:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonCallContent addTarget:self action:@selector(clickButtonCallContent:) forControlEvents:UIControlEventTouchUpInside];
    _tableViewRecorde.layer.cornerRadius = 0;
    _tableViewRecorde.layer.masksToBounds = YES;
    _tableViewRecorde.layer.borderWidth = 0.5;
    _tableViewRecorde.layer.borderColor = [[UIColor grayColor]CGColor];
    UINib *nib = [UINib nibWithNibName:@"CTM_RecordCell" bundle:nil];
    [_tableViewRecorde registerNib:nib forCellReuseIdentifier:@"CTM_RecordCell"];
    // Do any additional setup after loading the view from its nib.
    [self setCornerRadiusAndBorder:[self.view viewWithTag:987633]];
    [self setCornerRadiusAndBorder:[self.view viewWithTag:987634]];
}
-(void) clickButtonAddContent:(id) sender{
    COMMON_SHOWMSGDELEGATE(@"询问", self,@"取消", @"新增联系人",@"添加到现有联系人");
}
-(void) clickButtonCallContent:(id) sender{
    [SerCallService call:callPhoneNum];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
        {
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            [pb setString:callPhoneNum];
            CTM_AddContentController *c = [CTM_AddContentController getNewInstance];
            EntityUser *user = [EntityUser new];
            user.defaultPhone = callPhoneNum;
            [c setEntityUser:user];
            [c setTitleName:@"新增通信录"];
            [c setCallBackSave:false];
            [self.navigationController pushViewController:c animated:YES];
        }
            break;
        case 2:
        {
            
            [[CTM_MainController getSingleInstance]setExcueViewAppearDo:^(UIViewController *myself) {
                [myself.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
            }];
            [self.navigationController popToRootViewControllerAnimated:YES];
            COMMON_SHOWALERT(@"已经将你要添加的信息复制在粘贴板上!");
        }
            break;
            
        default:
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_recordData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CTM_RecordCell *crc  = [tableView dequeueReusableCellWithIdentifier:@"CTM_RecordCell"];
    EntityCallRecord *r = [_recordData objectAtIndex:[indexPath row]];
    [crc setAction:1];
    [crc setRecord:r];
    [crc setComing:0];
    [crc isHiddenOptButton:YES];
    UIView *ux = [UIView new];
    ux.backgroundColor = [UIColor colorWithRed:0.914 green:0.914 blue:0.914 alpha:1];
    [crc setSelectedBackgroundView:ux];
    return crc;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0f;
}

- (IBAction)clickReturnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
