//
//  SystemSetsListController.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-1.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "SystemSetsListController.h"
#import "TableViewTools.h"
#import "SystemSetsCell.h"
#import "SystemSetsExtsCell.h"
#import "SystemSetsHeadCell.h"
#import "SystemSetsUserInfoCell.h"
#import "SystemSetsAlertCell.h"
#import "SystemSetsPasswordEditCell.h"
#import "SystemSetsOpinionReturnCell.h"
#import "UIViewController+MMDrawerController.h"
#import "SystemSetsMergeUserCell.h"
#import "SystemSetsAboutViewCell.h"
#import "LoginViewController.h"

static const NSString *json_datas = @"json";//json数据
static const NSString *json_rowHeight = @"rowHeight";//行高
static const NSString *json_cellType = @"cellType";//cell类型
static const NSString *json_sizeH = @"sizeH";//每个ViewTable的高度
static const NSString *json_hasBorder = @"hasBorder";//是否有边框
@interface SystemSetsListController ()
@property int baseHeight;//所有的组件会依次向下
@property (retain,nonatomic)NSArray *menus;
@end

@implementation SystemSetsListController
+(SystemSetsListController*) init{
    SystemSetsListController *sslc =   [[SystemSetsListController alloc]initWithNibName:@"SystemSetsListController" bundle:nil];
    sslc.viewBottom = [SystemSetViewBottom init];
    return  sslc;
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect r = self.viewBottom.frame;
    r.origin.y = 0;
    self.viewBottom.frame = r;
}
 
-(SystemSetsListController*) setClickSelectionRow:(CallBakeMethod) method{
    _clickSelectionRow = method;
    return self;
}
-(SystemSetsListController*) setClickButtonCancle:(CallBakeMethod) method{
    _clickButtonCancle = method;
    return self;
}
-(SystemSetsListController*) setClickButtonConfirm:(CallBakeMethod) method{
    _clickButtonConfirm = method;
    return self;
}
-(SystemSetsListController*) setMenuss:(NSArray*) menuss{
    self.menus = menuss;
    [menuss release];
    return self;
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
    
    [self.view addSubview:self.viewBottom];
    [((SystemSetViewBottom*)self.viewBottom).buttonCancle addTarget:self action:@selector(clickButtonCancle) forControlEvents:UIControlEventTouchUpInside];
    [((SystemSetViewBottom*)self.viewBottom).buttonConfirm addTarget:self action:@selector(clickButtonConfirm) forControlEvents:UIControlEventTouchUpInside];
//    CGRect bounds = self.tableViewMain.frame;
//    NSLog(@"===%d",[[NSNumber alloc]initWithFloat:bounds.origin.y].intValue);
    self.view.backgroundColor = [UIColor colorWithRed:0.914 green:0.914 blue:0.914 alpha:1];
//    bounds.origin.y = self.viewBottom.frame.size.height-topHight;
//    self.tableViewMain.frame = bounds;
    self.tableViewMain.backgroundColor = [UIColor clearColor];

}

- (UITableViewCell *)_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewTools *temp1 = (TableViewTools*)tableView;
    NSArray *menu = [(NSDictionary*)self.menus[temp1.index] objectForKey:json_datas];
    NSNumber *cellType = ((NSNumber*)[menu[[indexPath row]] objectForKey:json_cellType]);
    if(cellType){
        UITableViewCell *cell;
        int temp = [cellType intValue];
        switch (temp) {
            case 0:
                if(YES){
                    SystemSetsExtsCell *ssc = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
                    if(ssc==nil){
                        ssc = [SystemSetsExtsCell init];
                    }
                    cell = ssc;
                }
                break;
            case 1:
                if(YES){
                    SystemSetsHeadCell *ssc = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
                    if(ssc==nil){
                        ssc = [SystemSetsHeadCell init];
                    }
                    ssc.tareget = self;
                    NSDictionary *json = menu[indexPath.row];
                    NSString *imageHead = [json objectForKey:@"imageHead"];
                    if(imageHead&&![imageHead isEqual:[NSNull null]]){
                        ssc.imageHeads.imageUrl = nil;
                        ssc.imageHeads.imageUrl = imageHead;
                    }
                    cell = ssc;
                }
                break;
            case 2:
                if(YES){
                    SystemSetsUserInfoCell *ssc = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
                    if(ssc==nil){
                        ssc = [SystemSetsUserInfoCell init];
                    }
                    ssc.target = self;
                    NSDictionary *json = menu[indexPath.row];
                    NSString *text = [json objectForKey:@"text"];
                    NSString *value = [json objectForKey:@"value"];
                    if(text&&![text isEqual:[NSNull null]]){
                        ssc.lableText.text = text;
                    }
                    if(value&&![value isEqual:[NSNull null]]){
                        ssc.lableValue.text = value;
                    }
                    cell = ssc;
                }
                break;
            case 3:
                if(YES){
                    SystemSetsAlertCell *ssc = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
                    if(ssc==nil){
                        ssc = [SystemSetsAlertCell init];
                    }
                    ssc.indexPath = indexPath;
                    NSDictionary *json = menu[indexPath.row];
                    NSString *text = [json objectForKey:@"text"];
                    id isNo = [json objectForKey:@"isNo"];
                    if(text&&![text isEqual:[NSNull null]]){
                        ssc.lableText.text = text;
                    }
                    if(isNo&&![isNo isEqual:[NSNull null]]){
                        [ssc setIsNo:isNo?YES:NO];
                    }
                    cell = ssc;
                }
                break;
            case 4:
                if(YES){
                    SystemSetsPasswordEditCell *ssc = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
                    if(ssc==nil){
                        ssc = [SystemSetsPasswordEditCell init];
                    }
                    NSDictionary *json = menu[indexPath.row];
                    NSString *text = [json objectForKey:@"text"];
                    if(text&&![text isEqual:[NSNull null]]){
                        ssc.lableText.text = text;
                    }
                    ssc.buttonPassword.placeholder = [indexPath row]==0?@"请输入原密码":@"请输入新密码";
                    ssc.buttonPassword.tag = 400+[indexPath row];
                    cell = ssc;
                }
                break;
            case 5:
                if(YES){
                    SystemSetsOpinionReturnCell *ssc = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
                    if(ssc==nil){
                        ssc = [SystemSetsOpinionReturnCell init];
                    }
                    ssc.textViewOpinion.tag = 500+[indexPath row];
                    //                    NSDictionary *json = menu[indexPath.row];
                    //                    NSString *text = [json objectForKey:@"text"];
                    cell = ssc;
                }
                break;
            case 6:
                if(YES){
                    SystemSetsAboutViewCell *ssc = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
                    if(ssc==nil){
                        ssc = [SystemSetsAboutViewCell init];
                    }
                    ssc.lableName.text = [NSString stringWithFormat:@"易销邦 %@",SYSTEM_VERSION_NUMBER];
                    cell = ssc;
                }
                break;
        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *u = [[UIView alloc]init];
        [u setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
        [cell setSelectedBackgroundView:u];
        return cell;
    }
    NSDictionary *json = menu[indexPath.row];
    NSString *text = [json objectForKey:@"text"];
    SystemSetsCell *ssc = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    if(ssc==nil){
        ssc = [SystemSetsCell init];
    }
    ssc.lableSets.text = text;
    UIView *u = [[UIView alloc]init];
    [u setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [ssc setSelectedBackgroundView:u];
    return ssc;
}
- (NSNumber*)_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TableViewTools *temp1 = (TableViewTools*)tableView;
    NSArray *menu = [(NSDictionary*)self.menus[temp1.index] objectForKey:json_datas];
    return [[NSNumber alloc]initWithInt:menu.count];
}
-(NSNumber*)_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewTools *temp1 = (TableViewTools*)tableView;
    NSArray *menu = [(NSDictionary*)self.menus[temp1.index] objectForKey:json_datas];
    NSNumber *rowHeight = [(NSDictionary*)menu[[indexPath row]]objectForKey:json_rowHeight];
    return rowHeight?rowHeight:[[NSNumber alloc]initWithInt:44.0f];
}
- (void)_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewTools *temp1 = (TableViewTools*)tableView;
    NSArray *menu = [(NSDictionary*)self.menus[temp1.index] objectForKey:json_datas];
    if(_clickSelectionRow){
        UIViewController<SystemSetsProtoclForButtom> *vc = _clickSelectionRow(tableView,indexPath,self.target);
        if(vc&&vc!=nil){
            NSString *childenName = [((NSDictionary*)menu[[indexPath row]]) objectForKey:@"text"];
            vc.title = childenName;
            [self.mm_drawerController.navigationController pushViewController:vc animated:YES];
            if ([vc isKindOfClass:[SystemSetsListController class]]) {
                 SystemSetViewBottom *vb = [vc getSystemSetViewBottom];
                vb.lableCurrentName.text = vc.title;
                
                [vc setTarget:self.target];
            }
           
//            vb.lableSuperName.text = self.title;//添加上级的名称
            
            [vc release];
        }
    }
}
-(void) clickButtonCancle{
    if(_clickButtonCancle){
        NSNumber *ifReturn = _clickButtonCancle(self.target);
        switch (ifReturn.intValue) {
            case 1:
                [self topButtonClick:((SystemSetViewBottom*)self.viewBottom).buttonCancle];
                [self release];
                break;
            case 2:
                [self.navigationController popViewControllerAnimated:YES];
                [self release];
                break;
            default:
                break;
        }
        [ifReturn release];
    }
}
-(void) clickButtonConfirm{
    if(_clickButtonConfirm){
        id ifReturn = _clickButtonConfirm(self.target,self.view,self);
        if(ifReturn){
            [self.navigationController popViewControllerAnimated:YES];
            [self release];
        }
        [ifReturn release];
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *menu = self.menus[[indexPath row]];
    int sizeH = ((NSNumber*)[menu objectForKey:json_sizeH]).intValue;
    id hasBoderder = [menu objectForKey:json_hasBorder];
    //    CGRect screen = [[UIScreen mainScreen] applicationFrame]
    //    CGRect frame = self.viewBottom.frame;
    //    frame.origin.y = screen.size.height-frame.size.height;
    //    self.viewBottom.frame = frame;
    TableViewTools *tvt = [TableViewTools init];
    [tvt setTargets:self];
    [tvt setOptCells:@selector(_tableView:cellForRowAtIndexPath:)];
    [tvt setOptRowNums:@selector(_tableView:numberOfRowsInSection:)];
    [tvt setOptRowHeights:@selector(_tableView:heightForRowAtIndexPath:)];
    [tvt setOptSelectrows:@selector(_tableView:didSelectRowAtIndexPath:)];
    
    tvt.scrollEnabled = NO;
    if(hasBoderder){
        tvt.layer.cornerRadius = 5;
        tvt.layer.masksToBounds = YES;
        tvt.layer.borderWidth = 0.5;
        tvt.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
    }
    tvt.frame =CGRectMake(5, 5, 310, sizeH);
    tvt.index = [indexPath row];
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, 320, sizeH+10)];
    }
    [cell addSubview:tvt];
    cell.backgroundColor = [UIColor colorWithRed:0.914 green:0.914 blue:0.914 alpha:1];
    UIView *u = [[UIView alloc]init];
    [u setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [cell setSelectedBackgroundView:u];
    if(IOS7_OR_LATER){
        CGRect r2 = cell.frame;
        r2.origin.y -= 20;
        cell.frame = r2;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menus.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *menu = self.menus[[indexPath row]];
    CGFloat sizeH = ((NSNumber*)[menu objectForKey:json_sizeH]).floatValue;
    return sizeH+10.0f;
}
-(id) getSystemSetViewBottom{
    return self.viewBottom;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self.menus release];
    [self.viewBottom release];
    [self.tableViewMain release];
}

+(const NSString*) getJson_datas{
    return json_datas;
}
+(const NSString*) getJson_rowHeight{
    return json_rowHeight;
}
+(const NSString*) getJson_cellType{
    return json_cellType;
}
+(const NSString*) getJson_sizeH{
    return json_sizeH;
}
@end
