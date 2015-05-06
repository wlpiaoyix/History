//
//  KnowledgeBaseViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-15.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "KnowledgeBaseViewController.h"
#import "SVPullToRefresh.h"
#import "KnowledgeDataCell.h"
#import "HttpApiCall.h"
#import "PublicInfo.h"
#import "UIViewController+MMDrawerController.h"
#import "AKUIWebViewController.h"
#import "AddKnowledgeViewController.h"

@interface KnowledgeBaseViewController (){
    bool isQuerySelected;
}

@end

@implementation KnowledgeBaseViewController
static KnowledgeBaseViewController * knowledge;

+(KnowledgeBaseViewController *)getKnowledgeBase{
    if (!knowledge) {
        knowledge = [[KnowledgeBaseViewController alloc]initWithNibName:@"KnowledgeBaseViewController" bundle:nil];
    }
    return knowledge;
}

+(void)newKnowledgeBase{
    if (knowledge) {
        [knowledge removeFromParentViewController];
        knowledge = nil;
    }
    
}
- (IBAction)AddKnowledge:(id)sender {
    AddKnowledgeViewController *addKnowledge = [[AddKnowledgeViewController alloc] init];
    [self.mm_drawerController.navigationController pushViewController:addKnowledge animated:YES];
}
int tabelviewTagBase = 30000;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (loginuser.roelId>2) {
        _butToAdd.hidden = YES;
    }else{
        _butToAdd.hidden = NO;
    }
    }
- (void)viewDidLoad
{
    [super viewDidLoad];
    isQuerySelected = NO;
    // Do any additional setup after loading the view from its nib.
    isLoadStart = 0;
    CGFloat heightforMainScroll = _mainTableView.frame.size.height;
    int numberOfTab = 4;
    loginuser = [ConfigManage getLoginUser];
    if(isLoadStart == 0){
        selectedIndex=0;
        //添加列表
        for (int i= 0; i<numberOfTab; i++) {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(320*i, 0, 320,heightforMainScroll)];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            tableView.tag = i+tabelviewTagBase;
            if(IOS7_OR_LATER)
                tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
            NSString *CustomCellNibName = @"KnowledgeDataCell";
            UINib *nib = [UINib nibWithNibName:CustomCellNibName bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CustomCellNibName];
            
            [tableView addPullToRefreshWithActionHandler:^{
                UITableView *view = (UITableView *)[_mainTableView viewWithTag:tabelviewTagBase+i];
                if(!view)return;
                [self getTableViewData:view isFrist:NO isAdd:NO isQuery:NO];
                [view.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
            }];
            [_mainTableView addSubview:tableView];
        }
    }
    _mainTableView.contentSize = CGSizeMake(320*numberOfTab, heightforMainScroll);
    [self ChangePageToScroll:1001];
    //修改搜索框背景
    _searchBar.backgroundColor=[UIColor colorWithRed:0.890 green:0.890 blue:0.890 alpha:1];
    //去掉搜索框背景
    if (!IOS7_OR_LATER) {
       [[_searchBar.subviews objectAtIndex:0]removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag ==30000&&listForSellData) {
        return listForSellData.count;
    }
    if (tableView.tag ==30001&&listForSellPower) {
        return listForSellPower.count;
    }
    if (tableView.tag ==30002&&listForWorkKnow) {
        return listForWorkKnow.count;
    }
    if (tableView.tag ==1500&&listForSearch) {
        return listForSearch.count;
    }
    if (tableView.tag == 30003 && listForFlowManage) {
        return listForFlowManage.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==1500)
        return 44;
    return 308;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //如果是筛选界面那么显示效果不一样
    if (tableView.tag==1500&&listForSearch) {
        UITableViewCell * cell = [UITableViewCell new];
       NSDictionary* dic = listForSearch[indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"digest"];
        if (indexPath.row==listForSearch.count-1) {
            [self getTableViewData:tableView isFrist:NO isAdd:YES isQuery:isQuerySelected];
        }
        return cell;
    }
    //如果是数据界面
    KnowledgeDataCell * cell= [tableView dequeueReusableCellWithIdentifier:@"KnowledgeDataCell"];
    NSDictionary *dic;
    if (tableView.tag ==30000&&listForSellData) {
        dic = listForSellData[indexPath.row];
        if (indexPath.row==listForSellData.count-1) {
            [self getTableViewData:tableView isFrist:NO isAdd:YES isQuery:NO];
        }
    }
    if (tableView.tag ==30001&&listForSellPower) {
        dic = listForSellPower[indexPath.row];
        if (indexPath.row==listForSellPower.count-1) {
            [self getTableViewData:tableView isFrist:NO isAdd:YES isQuery:NO];
        }
    }
    if (tableView.tag ==30002&&listForWorkKnow) {
        dic = listForWorkKnow[indexPath.row];
        if (indexPath.row==listForWorkKnow.count-1) {
            [self getTableViewData:tableView isFrist:NO isAdd:YES isQuery:NO];
        }
    }
    if (tableView.tag == 30003&&listForFlowManage) {
        dic = listForFlowManage[indexPath.row];
        if (indexPath.row==listForFlowManage.count-1) {
            [self getTableViewData:tableView isFrist:NO isAdd:YES isQuery:NO];
        }
    }
     [cell setData:[dic objectForKey:@"names"] ImageUrl:API_IMAGE_URL_GET2([dic objectForKey:@"digestPicattachUrl"]) Content:[dic objectForKey:@"digest"] Date:[NSDate dateFormateString:[dic objectForKey:@"createTime"] FormatePattern:nil] readNum:[[dic valueForKey:@"readNum"]intValue]];
    return cell;
}

//数据项被选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic;
    if (tableView.tag ==30000&&listForSellData) {
        dic = listForSellData[indexPath.row];
    }
    if (tableView.tag ==30001&&listForSellPower) {
        dic = listForSellPower[indexPath.row];
    }
    if (tableView.tag ==30002&&listForWorkKnow) {
        dic = listForWorkKnow[indexPath.row];
    }
    if (tableView.tag == 30003&&listForFlowManage) {
        dic = listForFlowManage[indexPath.row];
    }
    if (tableView.tag==1500&&listForSearch) {
        [_searchBar resignFirstResponder];
        dic = listForSearch[indexPath.row];
    }
    AKUIWebViewController * web = [[AKUIWebViewController alloc]initWithNibName:@"AKUIWebViewController" bundle:nil];
    web.url =[NSString stringWithFormat:@"%@:%d/api/publicinfo/pubshare/%ld?code=%@&log=get_xueyixue_page",HTTP_BASE_URL,APP_API_PORT,[[dic objectForKey:@"id"]longValue],loginuser.userId];
    web.title = [dic objectForKey:@"names"];
    web.imageUrl = API_IMAGE_URL_GET2([dic objectForKey:@"digestPicattachUrl"]);
    [self.mm_drawerController.navigationController pushViewController:web animated:YES];
}

//获取数据  isFrist ＝ 是否第一次调用或者可以理解为是否为切换选项卡调用   isAdd ＝ 是否为添加
-(void)getTableViewData:(UITableView *)tableView isFrist:(bool)isFrist isAdd:(bool)isAdd isQuery:(bool)isQuery{
    int pageSize = 15;
    NSArray * listdata;
    int type = 102;
    NSString *url;
    int startindex = 1;
    switch (selectedIndex) {
        case 1001:
            type = 102;
            listdata = listForSellData;
            break;
        case 1002:
            type = 1027;
            listdata = listForSellPower;
            break;
        case 1003:
            type = 1028;
            listdata = listForWorkKnow;
            break;
        case 1004:
            type = 1029;
            listdata = listForFlowManage;
            break;
        default:
            break;
    }
    if (isQuery) {
        listdata = listForSearch;
    }
    if (isFrist&&listdata) {
        return;
    }else if(isAdd&&listdata){
        if (listdata.count%pageSize){
            return;
        }else{
        startindex = listdata.count+1;
        }
    }
    [self showActivityIndicator];
    if (isQuery) {
        url = [NSString stringWithFormat:@"/api/publicinfo/study/,%d,/%@/%d/%d",type,_searchBar.text,startindex,pageSize];
    }else{
    url = [NSString stringWithFormat:@"/api/publicinfo/study/,%d,/%d/%d",type,startindex,pageSize];
    }
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_xueyixue_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [[reArg JSONValueNewMy]objectForKey:@"data"];
            if(temp == nil||temp.count==0){
                
                return;
            }
            switch (tableView.tag) {
                case 30000:
                    if (!listForSellData||!isAdd) {
                        listForSellData = temp;
                    }else if(isAdd){
                        [listForSellData addObjectsFromArray:temp];
                    }
                    [tableView reloadData];
                    break;
                case 30001:
                    if (!listForSellPower||!isAdd) {
                        listForSellPower = temp;
                    }else if(isAdd){
                        [listForSellPower addObjectsFromArray:temp];
                    }
                    [tableView reloadData];
                    break;
                case 30002:
                    if (!listForWorkKnow||!isAdd) {
                        listForWorkKnow = temp;
                    }else if(isAdd){
                        [listForWorkKnow addObjectsFromArray:temp];
                    }
                    [tableView reloadData];
                    break;
                case 30003:
                    if (!listForFlowManage||!isAdd) {
                        listForFlowManage = temp;
                    }else if(isAdd){
                        [listForFlowManage addObjectsFromArray:temp];
                    }
                    [tableView reloadData];
                    break;
                case 1500:
                    if (!listForSearch||!isAdd) {
                        listForSearch = temp;
                    }else if(isAdd){
                        [listForSearch addObjectsFromArray:temp];
                    }
                    [tableView reloadData];
                default:
                    break;
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
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];
}

//页面切换的时候调用，传入选项卡Button的Tag
-(void)ChangePageToScroll:(int)buttonIndex{
    
    UIButton * slectbut = (UIButton *)[self.view viewWithTag:buttonIndex];
    if(!slectbut)
        return;
    
    if (selectedIndex>1000) {
        slectbut = (UIButton *)[self.view viewWithTag:selectedIndex];
        if(slectbut)
            [slectbut setSelected:NO];
    }
    
     slectbut = (UIButton *)[self.view viewWithTag:buttonIndex];
    
     [slectbut setSelected:YES];
    
    CGFloat MainOffsetX = 0;
    CGFloat LableOffsetX = 0;
    switch (buttonIndex) {
        case 1001:
            MainOffsetX = 0;
            LableOffsetX = 0;
            break;
        case 1002:
            MainOffsetX = 320;
            LableOffsetX = 80;
            break;
        case 1003:
            MainOffsetX = 640;
            LableOffsetX = 160;
            break;
        case 1004:
            MainOffsetX = 960;
            LableOffsetX = 240;
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = _selectBackgroundLabel.frame;
        rect.origin.x = LableOffsetX;
        _selectBackgroundLabel.frame= rect;
        [_mainTableView setContentOffset:CGPointMake(MainOffsetX, 0)];
    }];
    selectedIndex = buttonIndex;
    UITableView *view = (UITableView *)[_mainTableView viewWithTag:(buttonIndex-1001+tabelviewTagBase)];
    if(view)
    [self getTableViewData:view isFrist:YES isAdd:NO isQuery:NO];
}

- (IBAction)tabButtonClick:(id)sender {
     [self ChangePageToScroll:((UIView *)sender).tag];
}

- (IBAction)leftButtonClickOne:(id)sender {
    if (isQuerySelected) {
        [self cancelSearch];
        return;
    }
    [self topButtonClick:sender];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchBar resignFirstResponder];
}

-(void)cancelSearch{
    [_searchBar resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame =  _searchView.frame;
        frame.origin.y = 92;
        frame.size.height = 44;
        _searchView.frame = frame;
    } completion:^(BOOL finished){
        isQuerySelected = NO;
        _labelText.text =@"学一学";
        [_topButton setImage:[UIImage imageNamed:@"icon_w_menu.png"] forState:UIControlStateNormal];
        _searchBar.showsCancelButton = NO;
        _searchBar.text = @"";
        if (listForSearch) {
            [listForSearch removeAllObjects];
            [_searchTableView reloadData];
        }
        
    }];


}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self cancelSearch];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (!_searchBar.text||[_searchBar.text isEqualToString:@""]) {
        return;
    }
    if (listForSearch) {
    [listForSearch removeAllObjects];
    }
 [self getTableViewData:_searchTableView isFrist:NO isAdd:YES isQuery:isQuerySelected];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
   [UIView animateWithDuration:0.3 animations:^{
       CGRect frame =  _searchView.frame;
       frame.origin.y = 44;
       frame.size.height = self.view.frame.size.height -44;
       _searchView.frame = frame;
   } completion:^(BOOL finished){
       isQuerySelected = YES;
       switch (selectedIndex) {
           case 1001:
            _labelText.text = @"搜索－本周重点";
               break;
           case 1002:
               _labelText.text = @"搜索－销售政策";
               break;
               case 1003:
               _labelText.text = @"搜索－业务知识";
               break;
           case 1004:
               _labelText.text = @"搜索－流量经营";
               break;
           default:
               break;
       }
       
       [_topButton setImage:[UIImage imageNamed:@"icon_w_back.png"] forState:UIControlStateNormal];
       _searchBar.showsCancelButton = YES;
       
   }];
  
    
   
}

@end
