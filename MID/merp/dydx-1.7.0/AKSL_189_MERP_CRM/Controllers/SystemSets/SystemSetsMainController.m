//
//  SystemSetsMainController.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-2.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetsMainController.h"
#import "MainPageViewController.h"
#import "TableViewTools.h"
#import "ConfigManage.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "LoginViewController.h"
#import "LoginUser.h"
#import "UIViewController+MMDrawerController.h"
#import "ScanQRViewController.h"
@interface SystemSetsMainController ()
@property NSDictionary *JsonsAndLists;
@property int currentFlag;
@end

@implementation SystemSetsMainController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.JsonsAndLists = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(id) getDatas{
    NSArray *json1 = [[NSArray alloc]initWithObjects:
                      [@"{\"id\":1,\"text\":\"个人中心\",\"rowHeight\":57}" JSONValueNewMy],
                      
                       nil];
    NSDictionary *menu1 = [[NSMutableDictionary alloc]init];
    [menu1 setValue:[[NSNumber alloc]initWithFloat:57] forKey:@"sizeH"];
    [menu1 setValue:@"" forKey:@"hasBorder"];
    [menu1 setValue:json1 forKey:@"json"];
    
    NSArray *json6 = [[NSArray alloc]initWithObjects:
                      [@"{\"id\":1,\"text\":\"消息提醒\",\"rowHeight\":57}" JSONValueNewMy],
                      [@"{\"id\":1,\"text\":\"修改密码\",\"rowHeight\":57}" JSONValueNewMy],
                      nil];
    NSDictionary *menu6 = [[NSMutableDictionary alloc]init];
    [menu6 setValue:[[NSNumber alloc]initWithFloat:114] forKey:@"sizeH"];
    [menu6 setValue:@"" forKey:@"hasBorder"];
    [menu6 setValue:json6 forKey:@"json"];
    
    NSArray *json3 = [[NSArray alloc]initWithObjects:
                      [@"{\"id\":1,\"text\":\"意见反馈\",\"rowHeight\":57}" JSONValueNewMy],
                      [@"{\"id\":2,\"text\":\"关于软件\",\"rowHeight\":57}" JSONValueNewMy],
                      [[NSString stringWithFormat:@"{\"id\":2,\"text\":\"软件更新:%@\",\"rowHeight\":57}",SYSTEM_VERSION_NUMBER] JSONValueNewMy], nil];
    NSDictionary *menu3 = [[NSMutableDictionary alloc]init];
    [menu3 setValue:[[NSNumber alloc]initWithFloat:171] forKey:@"sizeH"];
    [menu3 setValue:@"" forKey:@"hasBorder"];
    [menu3 setValue:json3 forKey:@"json"];
    
    NSArray *json4 = [[NSArray alloc]initWithObjects:
                      [@"{\"id\":1,\"text\":\"清理缓存\",\"rowHeight\":57}" JSONValueNewMy], nil];
    NSDictionary *menu4 = [[NSMutableDictionary alloc]init];
    [menu4 setValue:[[NSNumber alloc]initWithFloat:57] forKey:@"sizeH"];
    [menu4 setValue:@"" forKey:@"hasBorder"];
    [menu4 setValue:json4 forKey:@"json"];
    
    NSArray *json5 = [[NSArray alloc]initWithObjects:
                      [@"{\"id\":1,\"text\":\"退出登录\",\"rowHeight\":44,\"cellType\":0,\"rowHeight\":86}" JSONValueNewMy], nil];
    NSDictionary *menu5 = [[NSMutableDictionary alloc]init];
    [menu5 setValue:[[NSNumber alloc]initWithFloat:86] forKey:@"sizeH"];
    [menu5 setValue:json5 forKey:@"json"];
    NSArray *menus;
    int type = [ConfigManage getLoginUser].roelId;
    if (type >= 4) {
        
        NSArray *json2 = [[NSArray alloc]initWithObjects:
                          [@"{\"id\":1,\"text\":\"网页扫描登录\",\"rowHeight\":57}" JSONValueNewMy],
                          nil];
        NSDictionary *menu2 = [[NSMutableDictionary alloc]init];
        [menu2 setValue:[[NSNumber alloc]initWithFloat:0] forKey:@"sizeH"];
        [menu2 setValue:@"" forKey:@"hasBorder"];
        [menu2 setValue:json2 forKey:@"json"];
        menus  = [[NSArray alloc]initWithObjects:menu1,menu6,menu2,menu3,menu4,menu5, nil];
    }
    else
    {
        NSArray *json2 = [[NSArray alloc]initWithObjects:
                          [@"{\"id\":1,\"text\":\"网页扫描登录\",\"rowHeight\":57}" JSONValueNewMy],
                          nil];
        NSDictionary *menu2 = [[NSMutableDictionary alloc]init];
        [menu2 setValue:[[NSNumber alloc]initWithFloat:57] forKey:@"sizeH"];
        [menu2 setValue:@"" forKey:@"hasBorder"];
        [menu2 setValue:json2 forKey:@"json"];
      menus  = [[NSArray alloc]initWithObjects:menu1,menu6,menu2,menu3,menu4,menu5, nil];
    }
    
    return menus;
}
-(id) getDatas_1{
    LoginUser *user = [ConfigManage getLoginUser];
    
    NSDictionary *j1j = [[NSMutableDictionary alloc]init];
    [j1j setValue:@"头像" forKey:@"text"];
    [j1j setValue:[[NSNumber alloc] initWithInt:66] forKey:@"rowHeight"];
    [j1j setValue:[[NSNumber alloc] initWithInt:1] forKey:@"cellType"];
    if(user.headerImageUrl)[j1j setValue:user.headerImageUrl forKey:@"imageHead"];
    NSArray *json1 = [[NSArray alloc]initWithObjects:j1j, nil];//\"imageHead\":\"#\"
    NSDictionary *menu1 = [[NSMutableDictionary alloc]init];
    [menu1 setValue:[[NSNumber alloc]initWithFloat:66] forKey:@"sizeH"];
    [menu1 setValue:@"" forKey:@"hasBorder"];
    [menu1 setValue:[[NSNumber alloc]initWithInt:1] forKey:@"cellType"];
    [menu1 setValue:json1 forKey:@"json"];
    
    NSDictionary *j2j = [[NSMutableDictionary alloc]init];
    [j2j setValue:@"名字" forKey:@"text"];
    [j2j setValue:user.username forKey:@"value"];
    [j2j setValue:[[NSNumber alloc] initWithInt:2] forKey:@"cellType"];
//    NSDictionary *j2j2 = [[NSMutableDictionary alloc]init];
//    [j2j2 setValue:@"职位" forKey:@"text"];
//    id postName = user.type;
//    [j2j2 setValue:(postName&&postName!=nil&&[NSNull null]!=postName)?(NSString*)postName:@"暂定" forKey:@"value"];
//    [j2j2 setValue:[[NSNumber alloc] initWithInt:2] forKey:@"cellType"];
    NSDictionary *j2j3 = [[NSMutableDictionary alloc]init];
    [j2j3 setValue:@"电话" forKey:@"text"];
    [j2j3 setValue:user.mobilePhone forKey:@"value"];
    [j2j3 setValue:[[NSNumber alloc] initWithInt:2] forKey:@"cellType"];
    NSArray *json2 = [[NSArray alloc]initWithObjects:j2j,/*j2j2,*/j2j3, nil];
    NSDictionary *menu2 = [[NSMutableDictionary alloc]init];
//    [menu2 setValue:@"" forKey:@"hasBorder"];
    [menu2 setValue:[[NSNumber alloc]initWithFloat:88] forKey:@"sizeH"];
    [menu2 setValue:json2 forKey:@"json"];
    
    
    NSDictionary *j3j = [[NSMutableDictionary alloc]init];
    [j3j setValue:@"性别" forKey:@"text"];
    [j3j setValue:user.sexName forKey:@"value"];
    [j3j setValue:[[NSNumber alloc] initWithInt:2] forKey:@"cellType"];
    NSDictionary *j3j2 = [[NSMutableDictionary alloc]init];
    [j3j2 setValue:@"地区" forKey:@"text"];
    [j3j2 setValue:user.setString forKey:@"value"];
    [j3j2 setValue:[[NSNumber alloc] initWithInt:2] forKey:@"cellType"];
    NSArray *json3 = [[NSArray alloc]initWithObjects:j3j,j3j2,nil];
    NSDictionary *menu3 = [[NSMutableDictionary alloc]init];
    [menu3 setValue:[[NSNumber alloc]initWithFloat:88] forKey:@"sizeH"];
    [menu3 setValue:@"" forKey:@"hasBorder"];
    [menu3 setValue:json3 forKey:@"json"];
    NSArray *menus;
    int type = [ConfigManage getLoginUser].roelId;
    if (type==6||type==4) {
        menus = [[NSArray alloc]initWithObjects:menu1,menu2,menu3, nil];
    }else{
    NSDictionary *j4j = [[NSMutableDictionary alloc]init];
    [j4j setValue:@"消息列表" forKey:@"text"];
    [j4j setValue:[[NSNumber alloc] initWithInt:2] forKey:@"cellType"];
    NSArray *json4 = [[NSArray alloc]initWithObjects:j4j,nil];
    NSDictionary *menu4 = [[NSMutableDictionary alloc]init];
    [menu4 setValue:[[NSNumber alloc]initWithFloat:44] forKey:@"sizeH"];
    [menu4 setValue:@"" forKey:@"hasBorder"];
    [menu4 setValue:json4 forKey:@"json"];
    menus = [[NSArray alloc]initWithObjects:menu1,menu2,menu3,menu4, nil];
    }
   
    return menus;
}
-(id) getDatas_2{
    NSArray *json1 = [[NSArray alloc]initWithObjects:
                      [@"{\"id\":1,\"text\":\"声音\",\"isNo\":\"=\",\"cellType\":3}" JSONValueNewMy],
                      [@"{\"id\":1,\"text\":\"振动\",\"cellType\":3}" JSONValue], nil];
    NSDictionary *menu1 = [[NSMutableDictionary alloc]init];
    [menu1 setValue:@"" forKey:@"hasBorder"];
    [menu1 setValue:[[NSNumber alloc]initWithFloat:88] forKey:@"sizeH"];
    [menu1 setValue:json1 forKey:@"json"];
    
    NSArray *menus = [[NSArray alloc]initWithObjects:menu1, nil];
    return menus;
}
-(id) getDatas_3{
    NSArray *json1 = [[NSArray alloc]initWithObjects:
                      [@"{\"id\":1,\"text\":\"旧密码\",\"cellType\":4}" JSONValueNewMy],
                      [@"{\"id\":1,\"text\":\"新密码\",\"cellType\":4}" JSONValueNewMy],
                      [@"{\"id\":1,\"text\":\"重复密码\",\"cellType\":4}" JSONValueNewMy], nil];
    NSDictionary *menu1 = [[NSMutableDictionary alloc]init];
    [menu1 setValue:@"" forKey:@"hasBorder"];
    [menu1 setValue:[[NSNumber alloc]initWithFloat:132] forKey:@"sizeH"];
    [menu1 setValue:json1 forKey:@"json"];
    
    NSArray *menus = [[NSArray alloc]initWithObjects:menu1, nil];
    return menus;
}

-(id) getDatas_4{
    NSArray *json1 = [[NSArray alloc]initWithObjects:
                      [@"{\"id\":1,\"text\":\"意见反馈\",\"cellType\":5,\"rowHeight\":230}" JSONValueNewMy],nil];
    NSDictionary *menu1 = [[NSMutableDictionary alloc]init];
    //    [menu1 setValue:@"" forKey:@"hasBorder"];
    [menu1 setValue:[[NSNumber alloc]initWithFloat:230] forKey:@"sizeH"];
    [menu1 setValue:json1 forKey:@"json"];
    
    NSArray *menus = [[NSArray alloc]initWithObjects:menu1, nil];
    return menus;
}
-(id) getDatas_5{
    NSArray *json1 = [[NSArray alloc]initWithObjects:
                      [@"{\"id\":1,\"text\":\"关于软件\",\"cellType\":6,\"rowHeight\":524}" JSONValueNewMy],nil];
    NSDictionary *menu1 = [[NSMutableDictionary alloc]init];
    //    [menu1 setValue:@"" forKey:@"hasBorder"];
    [menu1 setValue:[[NSNumber alloc]initWithFloat:525] forKey:@"sizeH"];
    [menu1 setValue:json1 forKey:@"json"];
    
    NSArray *menus = [[NSArray alloc]initWithObjects:menu1, nil];
    return menus;
}

-(id) getDatas_6
{
    NSArray *json1 = [[NSArray alloc]initWithObjects:
                      [@"{\"id\":1,\"text\":\"网页扫描登录\",\"cellType\":5,\"rowHeight\":230}" JSONValueNewMy],nil];
    NSDictionary *menu1 = [[NSMutableDictionary alloc]init];
    //    [menu1 setValue:@"" forKey:@"hasBorder"];
    [menu1 setValue:[[NSNumber alloc]initWithFloat:230] forKey:@"sizeH"];
    [menu1 setValue:json1 forKey:@"json"];
    NSArray *menus = [[NSArray alloc]initWithObjects:menu1, nil];
    return menus;
}

+(SystemSetsListController*)  initForReturnList{
    SystemSetsMainController *temp = [[SystemSetsMainController alloc]initWithNibName:@"SystemSetsMainController" bundle:nil];
    SystemSetsListController *sslc1 = [SystemSetsListController init];
    [sslc1 setMenuss:[temp getDatas]];
    sslc1.target = temp;
    sslc1.title = @"系统设置";
    ((SystemSetViewBottom*)[sslc1 getSystemSetViewBottom]).lableCurrentName.text = sslc1.title;
    ((SystemSetViewBottom*)[sslc1 getSystemSetViewBottom]).buttonCancle.tag = 100;
    [[sslc1 getSystemSetViewBottom] layoutSubviews];
    [sslc1 setClickSelectionRow:^id(id key, ...) {
        va_list arglist;
        va_start(arglist, key);
        UITableView *tableView = key;
        NSIndexPath *indexPath = va_arg(arglist, NSIndexPath*);
        SystemSetsMainController *target = va_arg(arglist, SystemSetsMainController*);
        va_end(arglist);
        SystemSetsListController *sslc = [target checkController_1:tableView IndexPath:indexPath Target:target];
        return sslc;
    }];
    [sslc1 setClickButtonCancle:^id(SystemSetsMainController *target, ...) {
        return [[NSNumber alloc] initWithInt:1];
    }];
    return sslc1;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    SystemSetsListController *sslc1 = [SystemSetsListController init];
//    [sslc1 setMenuss:[self getDatas]];
//    sslc1.target = self;
//    sslc1.title = @"系统设置";
//    ((SystemSetViewBottom*)[sslc1 getSystemSetViewBottom]).lableCurrentName.text = sslc1.title;
//    ((SystemSetViewBottom*)[sslc1 getSystemSetViewBottom]).buttonCancle.tag = 100;
//    [[sslc1 getSystemSetViewBottom] layoutSubviews];
//    [sslc1 setClickSelectionRow:^id(id key, ...) {
//        va_list arglist;
//        va_start(arglist, key);
//        UITableView *tableView = key;
//        NSIndexPath *indexPath = va_arg(arglist, NSIndexPath*);
//        SystemSetsMainController *target = va_arg(arglist, SystemSetsMainController*);
//        va_end(arglist);
//        SystemSetsListController *sslc = [target checkController_1:tableView IndexPath:indexPath Target:target];
//        return sslc;
//    }];
//    [sslc1 setClickButtonCancle:^id(SystemSetsMainController *target, ...) {
//        return [[NSNumber alloc] initWithInt:1];
//    }];
//    
// 
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:sslc1];
//    nav.navigationBar.hidden = YES;
//    [self.target.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
//    [self.navigationController pushViewController:sslc1 animated:NO];
//    self.currentFlag = 1;
//     Do any additional setup after loading the view from its nib.
//    [nav release];
//    [sslc1 release];
}
-(void) showMessage:(NSString*) msg{
    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"温馨提示" message: msg  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
-(id) checkController_1:(UITableView*) tableView IndexPath:(NSIndexPath*) indexPath Target:(SystemSetsMainController*) target{
        SystemSetsListController *sslc;
        int tv = (((TableViewTools*)tableView).index+1)*100;
        int tt = [indexPath row];
        switch (tv+tt) {
            case 100:
                if(YES){
                    sslc = [SystemSetsListController init];
                    [((SystemSetViewBottom*)sslc.viewBottom).buttonCancle setImage:[UIImage imageNamed:@"icon_w_back.png"] forState:UIControlStateNormal];
                    [sslc setClickButtonCancle:^id(id key, ...) {
                        return [[NSNumber alloc] initWithInt:2];
                    }];
                    
                    [sslc setMenuss:[target getDatas_1]];
                }
                break;
            case 201:
                if(YES){
                    sslc = [SystemSetsListController init];
                    [((SystemSetViewBottom*)sslc.viewBottom).buttonCancle setImage:[UIImage imageNamed:@"icon_w_back.png"] forState:UIControlStateNormal];
                    [((SystemSetViewBottom*)sslc.viewBottom).buttonConfirm setImage:[UIImage imageNamed:@"icon_w_ok.png"] forState:UIControlStateNormal];
                    [sslc setClickButtonCancle:^id(id key, ...) {
                        return [[NSNumber alloc] initWithInt:2];
                    }];
                    [sslc setClickButtonConfirm:^id(id key, ...) {
                        va_list arglist;
                        va_start(arglist, key);
                        SystemSetsMainController *ssl = (SystemSetsMainController*)key;
                        UIView *uv = va_arg(arglist, UIView*);
                        UIViewController *uc = va_arg(arglist, UIViewController*);
                        va_end(arglist);
                        UITextField *tf1 = (UITextField*)[uv viewWithTag:400];
                        UITextField *tf2 = (UITextField*)[uv viewWithTag:401];
                        UITextField *tf3 = (UITextField*)[uv viewWithTag:402];
                        NSString *msg;
                        if((!tf1.text)||tf1.text==nil||[@"" isEqual:tf1.text]){
                            msg = @"请输入原密码！";
                            [ssl showMessage:msg];
                        }else if((!tf2.text)||tf1.text==nil||[@"" isEqual:tf2.text]){
                            msg = @"请输入新密码！";
                            [ssl showMessage:msg];
                        }else if(![tf1.text isEqual:[ConfigManage getConfig:STR_USER_PASSWORD]]){
                            msg = @"原密码输入有误！";
                            [ssl showMessage:msg];
                        }else if(![tf2.text isEqual:tf3.text]){
                            msg = @"两次新密码输入不一致！";
                            [ssl showMessage:msg];
                        }else{
                            NSMutableDictionary *json = [[[ConfigManage getConfig:HTTP_API_JSON_PERSONINFO] JSONValueNewMy] objectForKey:@"user"];
                            [json setValue:tf2.text forKey:@"password"];
                            ASIFormDataRequest *request = [HttpApiCall requestCallPUT:@"/api/user" Params:json Logo:@"edit_password"];
                            [request setCompletionBlock:^{
                                [request setResponseEncoding:NSUTF8StringEncoding];
                                NSString *reArg = [request responseString];
                                @try {
                                    id temp = [reArg JSONValueNewMy];
                                    if(temp){
                                        [ConfigManage setConfig:[json JSONRepresentation] Value:HTTP_API_JSON_PERSONINFO];
                                        NSString *p = tf2.text;
                                        [ConfigManage setConfig:STR_USER_PASSWORD Value:p];
                                        
                                        [ssl showMessage:@"密码修改成功！"];
                                        [uc.navigationController popViewControllerAnimated:YES];
                                    }else{
                                        [ssl showMessage:@"修改密码失败！"];
                                    }
                                }
                                @catch (NSException *exception) {
                                    [ssl showMessage:@"出现未知错误！"];
                                }
                                @finally {
                                }
                                
                            }];
                            [request setFailedBlock:^{
                                UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"错误" message: @"服务器没有响应！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                [alert show];
                                [alert release];
                            }];
                            [request startAsynchronous];
                        }
                        return  false;
                    }];
                    
                    [sslc setMenuss:[target getDatas_3]];
                }
                break;
            case 200:
                if(YES){
                    sslc = [SystemSetsListController init];
                    [((SystemSetViewBottom*)sslc.viewBottom).buttonCancle setImage:[UIImage imageNamed:@"icon_w_back.png"] forState:UIControlStateNormal];
                    [sslc setClickButtonCancle:^id(id key, ...) {
                        return [[NSNumber alloc] initWithInt:2];
                    }];
                    [sslc setMenuss:[target getDatas_2]];
                }
                break;
            case 300:
                if(YES){
                    
                    ScanQRViewController *scan = [[ScanQRViewController alloc] initWithNibName:@"ScanQRViewController" bundle:nil];
                    sslc = (SystemSetsListController *)scan;
                }
                break;
                
            case 400:
                if(YES){
                    sslc = [SystemSetsListController init];
                    [((SystemSetViewBottom*)sslc.viewBottom).buttonCancle setImage:[UIImage imageNamed:@"icon_w_back.png"] forState:UIControlStateNormal];
                    [((SystemSetViewBottom*)sslc.viewBottom).buttonConfirm setImage:[UIImage imageNamed:@"icon_w_ok.png"] forState:UIControlStateNormal];
                    [sslc setClickButtonCancle:^id(id key, ...) {
                        return [[NSNumber alloc] initWithInt:2];
                    }];
                    [sslc setClickButtonConfirm:^id(id key, ...) {
                        va_list arglist;
                        va_start(arglist, key);
                        UIView *uv = va_arg(arglist, UIView*);
                        BaseViewController *uc = va_arg(arglist, BaseViewController*);
                        va_end(arglist);
                        UITextView *tv = (UITextView*)[uv viewWithTag:500];
                        if((!tv.text)||tv.text==nil||[@"" isEqual:tv.text]){
                            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输您的意见！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alert show];
                            [alert release];
                        }else{
                            NSString *arg = [NSString stringWithFormat:@"{\"contents\":\"%@\",\"fromUser\":{\"id\":%lli}}",tv.text,[ConfigManage getLoginUser].userkey];
                            ASIFormDataRequest *request = [HttpApiCall requestCallPOST:@"/api/feedback" Params:[arg JSONValueNewMy] Logo:@"Opinion_return"];
                            [request setCompletionBlock:^{
                                @try {
                                    [request setResponseEncoding:NSUTF8StringEncoding];
                                    NSString *reArg = [request responseString];
                                    id temp = [reArg JSONValueNewMy];;
                                    if(temp){
                                        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"感谢给我们提供您宝贵的意见！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                        [alert show];
                                        [alert release];
                                        
                                    }
                                }
                                @finally {
                                    UITextView *tv = (UITextView*)[uv viewWithTag:500];
                                    [tv resignFirstResponder];
                                    [uc.navigationController popViewControllerAnimated:YES];
                                    [uc hideActivityIndicator];
                                }
                            }];
                            [request setFailedBlock:^{
                                [uc hideActivityIndicator];
                            }];
                            [request startAsynchronous];
                            [uc showActivityIndicator];
                        }
                        return false;
                    }];
                    [sslc setMenuss:[target getDatas_4]];
                }
                break;
            case 401:
                if(YES){
                    sslc = [SystemSetsListController init];
                    [((SystemSetViewBottom*)sslc.viewBottom).buttonCancle setImage:[UIImage imageNamed:@"icon_w_back.png"] forState:UIControlStateNormal];
                    [sslc setClickButtonCancle:^id(id key, ...) {
                        return [[NSNumber alloc] initWithInt:2];
                    }];
                    [sslc setMenuss:[target getDatas_5]];
                }
                break;
            case 402:
                if(YES){
                    ASIFormDataRequest *request = [HttpApiCall requestCallGET:@"/api/upgrades/ver/latest" Params:nil Logo:@"upload"];
                    [request setCompletionBlock:^{
                        @try {
                            [request setResponseEncoding:NSUTF8StringEncoding];
                            NSString *reArg = [request responseString];
                            NSDictionary *temp = [reArg JSONValueNewMy];
                            NSString *version = [temp objectForKey:@"version"];
                            if([NSString isEnabled:version]){
                                if([version isEqual:SYSTEM_VERSION_NUMBER]){
                                    NSString *tempx = @"已是最新版本";
                                    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"温馨提示" message:tempx delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                    [alert show];
                                    [alert release];
                                }else{
                                    NSArray *tempx1 = [version componentsSeparatedByString:@"."];
                                    NSArray *tempx2 = [SYSTEM_VERSION_NUMBER componentsSeparatedByString:@"."];
                                    for(int i=0;i<[tempx1 count];i++){
                                        int tempx3 = [((NSString*)tempx1[i]) intValue];
                                        int tempx4 = [tempx2[i] intValue];
                                        if(tempx3>tempx4){
                                            break;
                                        }else if(tempx3==tempx4){
                                            continue;
                                        }else{
                                            NSString *tempx = @"已是最新版本";
                                            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"温馨提示" message:tempx delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                            [alert show];
                                            [alert release];
                                            return;
                                        }
                                    }
                                    NSString *tempx = [NSString stringWithFormat:@"有最新版本:%@ 是否要更新？",version];
                                    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"温馨提示" message:tempx delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
                                    [alert show];
                                    [alert release];
                                }
                            }else{
                                @throw [[NSException alloc]initWithName:@"nil piont" reason:@"no version" userInfo:nil];
                            }
                        }
                        @catch (NSException *exception) {
                            NSString *tempx = @"已是最新版本";
                            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"温馨提示" message:tempx delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alert show];
                            [alert release];
                        }
                        @finally {
                            [target hideActivityIndicator];
                        }
                    }];
                    [request setFailedBlock:^{
                        NSString *tempx = @"已有最新版本:";
                        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"温馨提示" message:tempx delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                        [target hideActivityIndicator];
                    }];
                    [target showActivityIndicator];
                    [request startAsynchronous];
                }
                sslc = false;
                break;
            case 500:
                if(YES){
                    UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"已完成清理！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                sslc = false;
                break;
            default:
                if(YES){
                    sslc = [SystemSetsListController init];
                    [sslc setClickButtonCancle:^id(id key, ...) {
                        return [[NSNumber alloc] initWithInt:2];
                    }];
                    [sslc setMenuss:[target getDatas]];
                }
                break;
        }
        return sslc;
}

-(id) checkController1_2:(UITableView*) tableView IndexPath:(NSIndexPath*) indexPath Target:(SystemSetsMainController*) target{
    SystemSetsListController *sslc;
    switch ([indexPath row]) {
        case 2:
            if(YES){
                showAlertBox(@"ERRO", @"Arrayy erro!");
            }
            sslc = nil;
            break;
            
        default:
            if(YES){
                showAlertBox(@"ERRO", @"Arrayy erro!");
            }
            sslc = nil;
            break;
    }
    return sslc;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:API_BASE_URL(@"/app/")]];
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.JsonsAndLists release];
}

@end
