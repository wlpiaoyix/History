//
//  SystemSetsUserInfoCell.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-5.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetsUserInfoCell.h"
#import "SystemSetsCellsUserInfoController.h"
#import "HttpApiCall.h"
#import "MessageListViewController.h"
#import "NSObject+SBJSON.h"

@interface SystemSetsUserInfoCell()
@property int flag;
@end
@implementation SystemSetsUserInfoCell
+(id)init{
    SystemSetsUserInfoCell *ssc = [[[NSBundle mainBundle] loadNibNamed:@"SystemSetsUserInfoCell" owner:self options:nil] lastObject];
    return ssc;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if([self.lableText.text isEqual:@"名字"]){
        self.flag = 1;
    }else if([self.lableText.text isEqual:@"消息列表"]){
        self.flag = 4;
    }else if([self.lableText.text isEqual:@"性别"]){
        self.flag = 3;
    }else{
        [self.buttonTo setHidden:YES];
    }
}
- (void)setUserSex{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"性别选择"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"男",@"女",nil];
    [actionSheet showInView:self.target.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    int sex = -1;
    switch (buttonIndex) {
        case 0: {
            self.lableValue.text = @"男";
            sex = 1;
        }
            break;
        case 1: {
            self.lableValue.text = @"女";
            sex = 0;
        }
            break;
        default:
            break;
    }
    if(sex !=-1){
        NSMutableDictionary *json = [[[ConfigManage getConfig:HTTP_API_JSON_PERSONINFO] JSONValueNewMy] objectForKey:@"user"];
        [json setValue:self.lableValue.text forKey:@"gender"];
        [self commitData:json];
    }
}
-(void) commitData:(NSDictionary*) json{
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPUT:@"/api/user" Params:json Logo:@"edit_user_sex"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            id temp = [reArg JSONValueNewMy];
            if(temp){
                NSDictionary *json = [[ConfigManage getConfig:HTTP_API_JSON_PERSONINFO] JSONValueNewMy];
                [json setValue:temp forKey:@"user"];
                [ConfigManage setConfig:HTTP_API_JSON_PERSONINFO Value:[json JSONRepresentation]];
                [ConfigManage updateLoginUser];
                [ConfigManage updateOrganization];
//                showMessageBox(@"修改成功");
            }else{
                showMessageBox(@"修改失败！");
            }
        }
        @catch (NSException *exception) {
            showMessageBox(@"出现未知错误！");
        }
        @finally {
            [self.target hideActivityIndicator];
        }
        
    }];
    [request setFailedBlock:^{
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"错误" message: @"服务器没有响应！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [self.target hideActivityIndicator];
    }];
    [self.target showActivityIndicator];
    [request startAsynchronous];

}
-(void) clickMsgList:(id) sender {
    MessageListViewController * messageview = [[MessageListViewController alloc]initWithNibName:@"MessageListViewController" bundle:nil];
    [_target.navigationController pushViewController:messageview animated:YES];

}

- (IBAction)clickUserInfo:(id)sender {
    switch (self.flag) {
        case 1:{
            SystemSetsCellsUserInfoController *sscu = [[SystemSetsCellsUserInfoController alloc]initWithNibName:@"SystemSetsCellsUserInfoController" bundle:nil];
            LoginUser *u = [ConfigManage getLoginUser];
            sscu._titles = @"修改姓名";
            sscu._param = @"姓   名:";
            sscu._values = u.username;;
            sscu.flag = 1;
            sscu.target = self;
            [self.target.navigationController pushViewController:sscu animated:YES];
        }
            break;
        case 2:{
            SystemSetsCellsUserInfoController *sscu = [[SystemSetsCellsUserInfoController alloc]initWithNibName:@"SystemSetsCellsUserInfoController" bundle:nil];
            LoginUser *u = [ConfigManage getLoginUser];
            sscu._titles = @"修改电话";
            sscu._param = @"电   话:";
            sscu._values = u.mobilePhone;
            sscu.flag = 2;
            sscu.target = self;
            [self.target.navigationController pushViewController:sscu animated:YES];
        }
            break;
        case 3:{
            [self setUserSex];
        }
            break;
        case 4:{
            [self clickMsgList:nil];
        }
            break;
            
        default:
            break;
    }
}
@end
