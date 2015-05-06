//
//  InspectStoreSelectViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-2-27.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "InspectStoreSelectViewController.h"
#import "HttpApiCall.h"
#import "SwitchSelected.h"
#import "SelectFoyerTypeController.h"
#import "InspectStoreViewController.h"


@interface InspectStoreSelectViewController (){
    NSMutableArray *listForTdjl;
    NSMutableArray *listForArea;
    NSMutableArray *listForFzz;
    NSMutableArray *listForTdName;
     LoginUser * loginUser;
}

@end

@implementation InspectStoreSelectViewController

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
    listForTdName = [NSMutableArray new];
    listForTdjl = [NSMutableArray new];
    listForFzz = [NSMutableArray new];
    listForArea = [NSMutableArray new];
   UIButton * but =(UIButton *)[_viewSelectAll viewWithTag:10004];
    [but setEnabled:NO];
    but =(UIButton *)[_viewSelectAll viewWithTag:10005];
    [but setEnabled:NO];
    but =(UIButton *)[_viewSelectAll viewWithTag:10006];
    [but setEnabled:NO];
    loginUser = [ConfigManage getLoginUser];
    [self setCornerRadiusAndBorder:_viewSelectAll];
    [self setCornerRadiusAndBorder:_butToQuery];
    [self getAreaData];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goQueryRest:(id)sender {
    InspectStoreViewController * inspect = [[InspectStoreViewController alloc]initWithNibName:@"InspectStoreViewController" bundle:nil];
    inspect.isQueryRest = YES;
    [self.navigationController pushViewController:inspect animated:YES];
}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getAreaData{
    
    NSString *url = @"/api/organizations/allareas";
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_allareas_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            [listForArea removeAllObjects];
            //读取上次选择结果
            NSString * defTdtype = [ConfigManage getConfig:DEF_Area_inspect];
            NSArray * select ;
            if (defTdtype&&defTdtype.length>0) {
                select = [self getDataForSelectedStr:defTdtype];
            }
            NSString * setToText = @"";
            for (int i=0; i<temp.count; i++) {
                SwitchSelected *obj = [SwitchSelected new];
                NSDictionary * dic = [temp objectAtIndex:i];
                NSString * key =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"]intValue]];
                obj.key = [key longLongValue];
                obj.value = [dic objectForKey:@"areasName"];
                obj.isSelected = NO;
                if (select) {
                    for (int i=0; i<select.count; i++) {
                        if ([select[i] isEqualToString:key]) {
                            obj.isSelected = YES;
                            setToText = [[setToText stringByAppendingString:obj.value]stringByAppendingString:@"/"];
                        }
                    }
                }
                [listForArea addObject:obj];
            }
            if (!select){
                [self setUIButtonText:10003 Value:@"默认"];
            }else{
                [self setUIButtonText:10003 Value:setToText];
                //if(select.count==1){
                [self getAreaChin:defTdtype  Type:10003];
                // }
            }
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
    }];
    [request startAsynchronous];
}

-(void)getAreaChin:(NSString *)areaId Type:(int)type{
    NSString *url =[NSString stringWithFormat:@"/api/organizations/children/%@",areaId];
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_products_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            if (type==10003) {
                [listForFzz removeAllObjects];
                //读取上次选择结果
                NSString * defTdtype = [ConfigManage getConfig:DEF_Area_Fzz_inspect];
                NSArray * select ;
                if (defTdtype&&defTdtype.length>0) {
                    select = [self getDataForSelectedStr:defTdtype];
                }
                NSString * setToText = @"";
                for (int i=0; i<temp.count; i++) {
                    SwitchSelected *obj = [SwitchSelected new];
                    NSDictionary * dic = [temp objectAtIndex:i];
                    NSString * key =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"]intValue]];
                    obj.key = [key longLongValue];
                    obj.value = [dic objectForKey:@"name"];
                    obj.isSelected = NO;
                    if (select) {
                        for (int i=0; i<select.count; i++) {
                            if ([select[i] isEqualToString:key]) {
                                obj.isSelected = YES;
                                setToText = [[setToText stringByAppendingString:obj.value]stringByAppendingString:@"/"];
                            }
                        }
                    }
                    [listForFzz addObject:obj];
                }
                if (!select){
                    [self setUIButtonText:10004 Value:@"默认"];
                }else{
                    [self setUIButtonText:10004 Value:setToText];
                    // if(select.count==1){
                    [self getAreaChin:defTdtype Type:10004];
                    // }
                }
            }
            if (type==10004) {
                [listForTdName removeAllObjects];
                //读取上次选择结果
                NSString * defTdtype = [ConfigManage getConfig:DEF_Area_TdName_inspect];
                NSArray * select ;
                if (defTdtype&&defTdtype.length>0) {
                    select = [self getDataForSelectedStr:defTdtype];
                }
                NSString * setToText = @"";
                for (int i=0; i<temp.count; i++) {
                    SwitchSelected *obj = [SwitchSelected new];
                    NSDictionary * dic = [temp objectAtIndex:i];
                    NSString * key =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"id"]intValue]];
                    obj.key = [key longLongValue];
                    obj.value = [dic objectForKey:@"name"];
                    obj.isSelected = NO;
                    if (select) {
                        for (int i=0; i<select.count; i++) {
                            if ([select[i] isEqualToString:key]) {
                                obj.isSelected = YES;
                                setToText = [[setToText stringByAppendingString:obj.value]stringByAppendingString:@"/"];
                            }
                        }
                    }
                    [listForTdName addObject:obj];
                }
                if (!select){
                    [self setUIButtonText:10006 Value:@"默认"];
                }else{
                    [self setUIButtonText:10006 Value:setToText];
                }
            }
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{ 
    }];
    [request startAsynchronous];
    
}


-(void)setUIButtonText:(int)tag Value:(NSString *)value{
    UIButton * but;
    
    if (tag<=10006&&tag>=10003) {
        but =(UIButton *) [_viewSelectAll viewWithTag:tag]; 
    }
    
    [but setTitle:value forState:UIControlStateNormal];
    [but setEnabled:YES];
}
-(NSArray *)getDataForSelectedStr:(NSString *)str{
    NSArray * data;
    data = [str componentsSeparatedByString:@","];
    return data;
}

-(void)setUIButtonEnabled:(int)tag{
    UIButton * but;
    
    if (tag<=10006&&tag>=10003) {
        but =(UIButton *) [_viewSelectAll viewWithTag:tag];
    }
    [but setTitle:@"默认" forState:UIControlStateNormal];
    [but setEnabled:NO];
}

- (IBAction)selectButClick:(id)sender {
    
    UIButton * but = sender;
    
    SelectFoyerTypeController *view = [[SelectFoyerTypeController alloc]initWithNibName:@"SelectFoyerTypeController" bundle:nil];
    switch (but.tag){
        case 10003:{
            view.catachData = listForArea;
            view.ifSingleSelected = NO;
            view.titleName = @"经营区域";
            [view setRetureMethods:^(NSArray *selecteds) {
                if (selecteds.count>0) {
                    for (SwitchSelected * select in listForArea) {
                        select.isSelected = NO;
                    }
                    NSString * setToText = @"";
                    NSString * setTokey = @"";
                    for (int i=0; i<selecteds.count; i++) {
                        SwitchSelected *obj = (SwitchSelected *)selecteds[i];
                        for (SwitchSelected * select in listForArea) {
                            if (obj.key == select.key) {
                                select.isSelected = YES;
                            }
                        }
                        NSString * key = [NSString stringWithFormat:@"%lli",obj.key];
                        if (i>0) {
                            setToText = [setToText stringByAppendingString:@"/"];
                            setTokey = [setTokey stringByAppendingString:@","];
                        }
                        setToText = [setToText stringByAppendingString:obj.value];
                        setTokey = [setTokey stringByAppendingString:key];
                    }
                    [self setUIButtonText:10003 Value:setToText];
                    [ConfigManage setConfig:DEF_Area_inspect Value:setTokey];
                    //[self setUIButtonEnabled:10004];
                    [self setUIButtonEnabled:10006];
                    [ConfigManage setConfig:DEF_Area_TdName_inspect Value:@""];
                    [ConfigManage setConfig:DEF_Area_Fzz_inspect Value:@""];
                    //if (selecteds.count==1) {
                    [self getAreaChin:setTokey Type:10003];
                    // }
                }
            }];
            break;
        }
        case 10004:{
            view.catachData = listForFzz;
            view.ifSingleSelected = NO;
            view.titleName = @"分支局";
            [view setRetureMethods:^(NSArray *selecteds) {
                if (selecteds.count>0) {
                    for (SwitchSelected * select in listForFzz) {
                        select.isSelected = NO;
                    }
                    NSString * setToText = @"";
                    NSString * setTokey = @"";
                    for (int i=0; i<selecteds.count; i++) {
                        SwitchSelected *obj = (SwitchSelected *)selecteds[i];
                        for (SwitchSelected * select in listForFzz) {
                            if (obj.key == select.key) {
                                select.isSelected = YES;
                            }
                        }
                        NSString * key = [NSString stringWithFormat:@"%lli",obj.key];
                        if (i>0) {
                            setToText = [setToText stringByAppendingString:@"/"];
                            setTokey = [setTokey stringByAppendingString:@","];
                        }
                        setToText = [setToText stringByAppendingString:obj.value];
                        setTokey = [setTokey stringByAppendingString:key];
                    }
                    [self setUIButtonText:10004 Value:setToText];
                    [ConfigManage setConfig:DEF_Area_Fzz_inspect Value:setTokey];
                    //[self setUIButtonEnabled:10005];
                    [ConfigManage setConfig:DEF_Area_TdName_inspect Value:@""];
                    // if (selecteds.count==1) {
                    [self getAreaChin:setTokey Type:10004];
                    // }
                }
            }];
            break;
        }
        case 10006:{
            view.catachData = listForTdName;
            view.ifSingleSelected = NO;
            view.titleName = @"厅店名字";
            [view setRetureMethods:^(NSArray *selecteds) {
                if (selecteds.count>0) {
                    for (SwitchSelected * select in listForTdName) {
                        select.isSelected = NO;
                    }
                    NSString * setToText = @"";
                    NSString * setTokey = @"";
                    for (int i=0; i<selecteds.count; i++) {
                        SwitchSelected *obj = (SwitchSelected *)selecteds[i];
                        for (SwitchSelected * select in listForTdName) {
                            if (obj.key == select.key) {
                                select.isSelected = YES;
                            }
                        }
                        NSString * key = [NSString stringWithFormat:@"%lli",obj.key];
                        if (i>0) {
                            setToText = [setToText stringByAppendingString:@"/"];
                            setTokey = [setTokey stringByAppendingString:@","];
                        }
                        setToText = [setToText stringByAppendingString:obj.value];
                        setTokey = [setTokey stringByAppendingString:key];
                    }
                    [self setUIButtonText:10006 Value:setToText];
                    [ConfigManage setConfig:DEF_Area_TdName_inspect Value:setTokey];
                }
            }];
            break;
        }
        default:
            break;
    }
    [self.navigationController pushViewController:view animated:YES];
}
@end
