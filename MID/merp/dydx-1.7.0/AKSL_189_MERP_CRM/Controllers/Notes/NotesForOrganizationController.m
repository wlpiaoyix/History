//
//  NotesForOrganizationController.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-25.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//
#import "NotesForOrganizationController.h"
#import "NotesForOrganizationCell.h"
#import "NotesAddViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "HttpApiCall.h"
#import "ASIFormDataRequest.h"
#define NOTESFORORGCELLREGNAME @"notesForOrganizationCell"
@interface NotesForOrganizationController (){
    NSDictionary * SelectedDic;
    int maxCount;
}
@property bool nibsRegistered;
@property NSMutableArray *jsonArray;
@end

@implementation NotesForOrganizationController

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
    maxCount = INT32_MAX;
    [self updateData:NO];
}

-(void)updateData:(bool)isAdd{
    int pageSize = 40;
    int startIndex = 1;
    if(isAdd&&_jsonArray){
        if (_jsonArray.count>=maxCount||_jsonArray.count%pageSize){
            return;
        }else{
            startIndex = _jsonArray.count+1;
        }
    }
    [self showActivityIndicator];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:[NSString stringWithFormat:@"/api/organizations/halls/%d/%d",startIndex,pageSize] Params:nil Logo:@"get_users_orgs"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        NSString *reArg = [request responseString];
        @try {
            if(!reArg){
                return;
            }
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            maxCount = [[temp objectForKey:@"totalCount"]intValue];
            if (!_jsonArray||!isAdd) {
                _jsonArray = [temp objectForKey:@"data"];
            }else if(isAdd){
                [_jsonArray addObjectsFromArray:[temp objectForKey:@"data"]];
            }
            [self.tableViewOrgList reloadData];
        }
        @catch (NSException *exception) {
        }
        @finally {
            [self hideActivityIndicator];
        }
    }];
    [request setFailedBlock:^{
        showMessageBox(WEB_BASE_MSG_REQUESTOUTTIME);
        [self hideActivityIndicator];
    }];
    [self showActivityIndicator];
    [request startAsynchronous];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.jsonArray?[self.jsonArray count]:0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"NotesForOrganizationCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:NOTESFORORGCELLREGNAME];
        self.nibsRegistered = YES;
    }
    NotesForOrganizationCell *cell = [tableView dequeueReusableCellWithIdentifier:NOTESFORORGCELLREGNAME];
    if(cell){
        NSDictionary *json = self.jsonArray[[indexPath row]];
        UIView *u = [[UIView alloc]init];
        u.backgroundColor = [UIColor colorWithRed:0.396 green:0.408 blue:0.459 alpha:0.5];
        [cell setSelectedBackgroundView:u];
        cell.lableOrgName.text = [json objectForKey:@"fullName"];
        if (indexPath.row==_jsonArray.count-1) {
            [self updateData:YES];
        }
    }
    return cell;
}

-(void) setRetureMethods:(RetureMethodDic) returnMethod{
    _returnMethod = returnMethod;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectedDic = self.jsonArray[[indexPath row]];
    [self buttonReturn:nil];
}
- (IBAction)buttonReturn:(UIButton *)sender {
    if(_returnMethod){
        _returnMethod(SelectedDic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
