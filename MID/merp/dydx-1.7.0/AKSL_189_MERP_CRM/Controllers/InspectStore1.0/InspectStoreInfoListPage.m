//
//  InspectStoreInfoListPage.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/26.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "InspectStoreInfoListPage.h"
#import "HttpApiCall.h"
#import "InspectStoreInfo.h"
#import "CommentInfo.h"
#import "InspectStoreDetailInfoCell.h"
#import "NotesImageViewController.h"
#import "MJRefresh.h"
#import "KxMenu.h"
#import "UIView+convenience.h"
#import "MyTourroundViewController.h"

@interface InspectStoreInfoListPage (){
    SelectorOfInspectStore * selector;
    NSMutableArray * listForData;
    int maxCount;
    long CurrInspectIdForZanPingjia;
    long CurrPepoleId;
    long CurrCommentId;
    NSString * CurrpepoleName;
    BOOL CurrIsZan;
    int indexForData;
    int CountForMsgData;
    bool isShowPingjiaInput;
    LoginUser * longinUser;
    BOOL isLonding;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
    NSArray *menuItemsType;
    NSArray *menuItemsSort;
    NSString *typeSelect;
    NSString *sortSelect;
    
    
    
}

@end

@implementation InspectStoreInfoListPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [_tableForInspectInfoView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

- (void)addFooter
{
    __unsafe_unretained InspectStoreInfoListPage *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableForInspectInfoView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [vc updataFromServer:YES];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
    };
    _footer = footer;
}
- (void)addHeader
{
    __unsafe_unretained InspectStoreInfoListPage *vc = self;
    
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tableForInspectInfoView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        if (listForData) {
            [listForData removeAllObjects];
            listForData = nil;
        }
        [vc updataFromServer:NO];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
        
        //NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        //NSLog(@"%@----刷新完毕", refreshView.class);
    };
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                // NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                // NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                //NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}


-(void)reloadData{
    [_tableForInspectInfoView reloadData];
}

-(void)hideZanpingjia{
    _viewZanpingjia.hidden = YES;
    [_TextInputPingjia resignFirstResponder];
    [_viewPingjiaInput setHidden:YES];
    isShowPingjiaInput = NO;
}
-(void)showZanpingjia:(long)inspectID isZan:(BOOL)isZan Top:(CGFloat)top indexForData:(int)index{
    if (isShowPingjiaInput) {
        [self hideZanpingjia];
        return;
    }
    isShowPingjiaInput = YES;
    CurrInspectIdForZanPingjia = inspectID;
    _viewZanpingjia.hidden = NO;
    CurrIsZan = isZan;
    indexForData = index;
    CGRect farme = _viewZanpingjia.frame;
    farme.size.width = 0;
    farme.origin.y = top;
    InspectStoreInfo *info = listForData[indexForData];
    farme.origin.y +=205-_tableForInspectInfoView.contentOffset.y+info.hieghtForContent;
    
    [_butZanOrCans setImage:[UIImage imageNamed:(CurrIsZan?@"icon_g_like_quxiao.png":@"icon_g_like_zan.png")] forState:UIControlStateNormal];
    [_butZanOrCans setTitle:(CurrIsZan?@"取消":@"赞") forState:UIControlStateNormal];
    _viewZanpingjia.frame = farme;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect farme = _viewZanpingjia.frame;
        farme.size.width = 170;
        _viewZanpingjia.frame = farme;
    }];
}
-(BOOL)isShowPingjiaInput{
    return isShowPingjiaInput;
}

-(void)showPingjia:(long)inspectID indexForData:(int)index pId:(long)p_id pname:(NSString *)pname cId:(long)c_id{
    
    if (isShowPingjiaInput) {
        [self hideZanpingjia];
        return;
    }else{
        [self hideZanpingjia];
    }
    CurrInspectIdForZanPingjia = inspectID;
    indexForData = index;
    CurrPepoleId = p_id;
    CurrpepoleName = pname;
    CurrCommentId = c_id;
    [_TextInputPingjia setText:@""];
    [_TextInputPingjia setPlaceholder:[@"回复" stringByAppendingString:pname]];
    [_viewPingjiaInput setHidden:NO];
    [_TextInputPingjia becomeFirstResponder];
    isShowPingjiaInput = YES;
}

-(void)intputshow:(NSNotification *)notification{
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGRect frame = _viewPingjiaInput.frame;
        frame.origin.y = self.view.frame.size.height - keyBoardFrame.size.height - frame.size.height;
        _viewPingjiaInput.frame = frame;
    }];
    
}
-(void)intputhide:(NSNotification *)notification{
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect frmeimage = _viewPingjiaInput.frame;
        frmeimage.origin.y =self.view.frame.size.height - frmeimage.size.height;
        _viewPingjiaInput.frame = frmeimage;
    }];
    
    
}

-(void)setData:(SelectorOfInspectStore *)data{
    selector = data;
}
-(IBAction)showSelectSort:(UIButton *)sender{
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItemsSort];
}

-(IBAction)showSelectType:(UIButton *)sender{
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItemsType];
}

- (void) pushMenuItemType:(KxMenuItem *)sender
{
    NSLog(@"%@", sender.keyValue);
    
     typeSelect = sender.keyValue;
     [self updataFromServer:NO];
 
}

- (void) pushMenuItemSort:(KxMenuItem *)sender
{
    NSLog(@"%@", sender.keyValue);
    sortSelect = sender.keyValue;
    [self updataFromServer:NO];
}

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [KxMenu setTintColor: [UIColor colorWithRed:0.518 green:0.714 blue:0.078 alpha:1]];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputshow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(intputhide:) name:UIKeyboardWillHideNotification object:nil];
    isShowPingjiaInput =NO;
    
    longinUser = [ConfigManage getLoginUser];
    [self setCornerRadiusAndBorder:_viewZanpingjia];
    [self setCornerRadiusAndBorder:_butSendPingjia];
    
    _textForTitle.text = selector.title;
    if (selector.dateSelect&&selector.dateSelect.length>0) {
        _textForDate.text  =selector.dateSelect;
    }else{
        [_textForTitle moveY:7];
        _textForDate.text = @"";
    }
    
    
    NSString *CustomCellNibName = @"InspectStoreDetailInfoCell";
    UINib *nib = [UINib nibWithNibName:CustomCellNibName bundle:nil];
    [_tableForInspectInfoView registerNib:nib forCellReuseIdentifier:CustomCellNibName];
    [self addFooter];
    [self addHeader];
    
   menuItemsSort = @[
      
      [KxMenuItem menuItem:@"  最新发表  "
                     image:nil
                    target:self
                    action:@selector(pushMenuItemSort:)
                    key:@"1105"],
      
      [KxMenuItem menuItem:@"  点赞最多  "
                     image:nil
                    target:self
                    action:@selector(pushMenuItemSort:)
                    key:@"1107"],
      
      [KxMenuItem menuItem:@"  评论最多  "
                     image:nil
                    target:self
                    action:@selector(pushMenuItemSort:)
                    key:@"1106"]
      ];
    menuItemsType =@[
                     [KxMenuItem menuItem:@"全部"
                                    image:nil
                                   target:self
                                   action:@selector(pushMenuItemType:)
                                   key:@"0"],
                     
                     [KxMenuItem menuItem:@"炒店"
                                    image:nil
                                   target:self
                                   action:@selector(pushMenuItemType:)
                                   key:@"77"],
                     
                     [KxMenuItem menuItem:@"巡店"
                                    image:nil
                                   target:self
                                   action:@selector(pushMenuItemType:)
                                      key:@"78"],
                     
                     [KxMenuItem menuItem:@"竞争对手活动"
                                    image:nil
                                   target:self
                                   action:@selector(pushMenuItemType:)
                                      key:@"79"]
                     ];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *url = @"/api/comment";
    NSMutableString * conent =[[NSMutableString alloc]initWithString:_TextInputPingjia.text];
    [conent replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [conent length])];
    NSString * commitData =[NSString stringWithFormat:@"{\"attendencesId\": %ld,\"parentId\": %ld,\"content\": \"%@\",\"toUserId\":%ld}",CurrInspectIdForZanPingjia,CurrCommentId,conent,CurrPepoleId];
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:url Params:[commitData JSONValue] Logo:@"yunyiyun_pingjia_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil ){
                
                return;
            }
            if ([[temp valueForKey:@"status"]isEqualToString:@"success"]) {
                
                InspectStoreInfo * info;
                
                    info = listForData[indexForData];
                
                NSMutableDictionary * tempD = [temp valueForKey:@"comments"];
                
                CommentInfo * comment = [CommentInfo getCommentInfo:[[tempD valueForKey:@"id"]longValue] Content:[tempD valueForKey:@"content"] ToUserName:CurrpepoleName];
                [info addComment:comment];
                
            [_tableForInspectInfoView reloadData];
                
            }else{
                showMessageBox(@"评价失败，请重新提交。");
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
    [self hideZanpingjia];
    
    return YES;
}

- (IBAction)ZanClick:(id)sender {
    [self hideZanpingjia];
    if (CurrIsZan) {
        [self quxiaoZanToServer];
    }else{
        [self zanToServer];
    }
}

-(void)quxiaoZanToServer{
    InspectStoreInfo * info;
    
    info = listForData[indexForData];
    
    NSString *url = [NSString stringWithFormat:@"/api/like/%ld",info.selfZanId];
    [self showActivityIndicator];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallDELET:url Logo:@"yunyiyun_quxiaozan_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                
                return;
            }
            if ([[temp valueForKey:@"status"]isEqualToString:@"success"]) {
                //  showMessageBox(@"评价成功！");
                [info removeSelfZan];
                
                [_tableForInspectInfoView reloadData];
                
            }else{
                showMessageBox(@"评价失败，请重新提交。");
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

-(void)zanToServer{
    NSString *url = [NSString stringWithFormat:@"/api/like/%ld",CurrInspectIdForZanPingjia];
    [self showActivityIndicator];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:url Params:nil Logo:@"yunyiyun_zan_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSMutableArray *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                
                return;
            }
            if ([[temp valueForKey:@"status"]isEqualToString:@"success"]) {
                //  showMessageBox(@"评价成功！");
                InspectStoreInfo * info;
                
                info = listForData[indexForData];
                
                
                NSMutableDictionary * likenew = [temp valueForKey:@"like"];
                [likenew setObject:[NSNumber numberWithLong:longinUser.userDataId] forKey:@"userId"];
                [likenew setObject:longinUser.username forKey:@"userName"];
                [info addZan:likenew];
                
                    [_tableForInspectInfoView reloadData];
            
            }else{
                showMessageBox(@"评价失败，请重新提交。");
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

- (IBAction)PingjiaClick:(id)sender {
    [self hideZanpingjia];
    CurrPepoleId = -1;
    CurrCommentId = -1;
    CurrpepoleName = nil;
    [_TextInputPingjia setText:@""];
    [_TextInputPingjia setPlaceholder:@"评价内容"];
    [_viewPingjiaInput setHidden:NO];
    [_TextInputPingjia becomeFirstResponder];
    isShowPingjiaInput = YES;
    
    
}
- (IBAction)CancelPingjia:(id)sender {
    [self hideZanpingjia];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hideZanpingjia];
}


//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(listForData){
        return listForData.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    InspectStoreInfo * info = listForData[indexPath.row];
    return info.hieghtForZanpingjiaNewDetailInfo;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    InspectStoreInfo * info = listForData[indexPath.row];
    static NSString *identifier = @"InspectStoreDetailInfoCell";
    InspectStoreDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell)
    {
        cell = [[InspectStoreDetailInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:tableView forKey:@"TABLE"];
//    [dic setObject:info forKey:@"INFO"];
//    [dic setObject:self forKey:@"SELF"];
//    [dic setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"ROW"];
//    [dic setObject:cell forKey:@"CELL"];
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(cellData:) object:dic];
//    [thread start];
    [cell setData:info inspectView:self indexInListData:indexPath.row];
    return cell;
}
//-(void)cellData:(NSMutableDictionary *)dic
//{
//    [[dic objectForKey:@"CELL"] setData:[dic objectForKey:@"INFO"] inspectView:self indexInListData:[[dic objectForKey:@"ROW"] integerValue]];
//    [self performSelectorOnMainThread:@selector(newCell:) withObject:[dic objectForKey:@"CELL"] waitUntilDone:YES];
//}
//-(void)newCell:(InspectStoreDetailInfoCell *)infocell
//{
//    detailInfoCell = infocell;
//}
-(void)showImagesView:(int)index{
 [self hideZanpingjia];
    InspectStoreInfo * info = listForData[index];
    NSMutableDictionary *jsonDatas = [[NSMutableDictionary alloc]init];
    [jsonDatas setValue:info.addr forKey:@"imageInfo"];
    NSMutableArray *temp2 = [[NSMutableArray alloc]init];
    for(NSString *temp3 in info.ImagesAll){
        NSMutableDictionary *temp4 =[[NSMutableDictionary alloc]init];
        [temp4 setValue:temp3 forKey:@"imageURL"];
        [temp2 addObject:temp4];
    }
    [jsonDatas setValue: temp2 forKey:@"data"];
    NotesImageViewController *l = [[NotesImageViewController alloc]initWithNibName:@"NotesImageViewController" bundle:nil];
    l.jsonData = jsonDatas;
    l.title= info.storeName;
    [self.navigationController pushViewController:l animated:YES];
    
}
//数据项被选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isShowPingjiaInput) {
        [self hideZanpingjia];
        return;
    }
}

-(void)updataFromServer:(bool)isAdd{
    
    int pageSize = 5;
    int startIndex = 1;
    if(isAdd&&listForData){
        if (listForData.count>=maxCount){
            return;
        }else{
            startIndex = listForData.count+1;
        }
    }
    [self showActivityIndicator];
    NSMutableString *str = [NSMutableString new];
    if (typeSelect&&![typeSelect isEqualToString:@"0"]){
        [str appendString:typeSelect];
        if (sortSelect){
            [str appendString:@","];
            [str appendString:sortSelect];
        }
    }else if (sortSelect){
        [str appendString:sortSelect];
    }else{
        [str appendString:@"default"];
    }
    if (str.length==0) {
        [str appendString:@"default"];
    }
    //api/attendances/{startIndex}/{count}/{area}/{fzz}/{td}
    NSString *url = [NSString stringWithFormat:@"/api/inspection/info/%d/%@/%d/%d",selector.tagId,str,startIndex,pageSize];
    

    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_attendances_data_main"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [self hideActivityIndicator];
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *temp = [reArg JSONValueNewMy];
            if(temp == nil){
                showMessageBox(@"暂无数据");
                return;
            }
            maxCount = [[temp objectForKey:@"totalCount"]intValue];
            if (!listForData) {
                listForData = [NSMutableArray new];
            }
            if (!isAdd) {
                [listForData removeAllObjects];
            }
            NSArray  * list = [temp objectForKey:@"data"];
            if (list.count==0) {
                showMessageBox(@"暂无数据");
                return;
            }
            for (NSDictionary * dic in list) {
                [listForData addObject:[InspectStoreInfo getInspectStoreInfoNewObj:dic]];
            }
            isLonding = YES;
            [_tableForInspectInfoView reloadData];
            
        }
        @catch (NSException *exception) {
            showAlertBox(@"提示", exception.reason);
            return;
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"%@",request.error);
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];
    
}

-(void)showSingePage:(NSString *)userCode Name:(NSString *)name{
    MyTourroundViewController *mytourround = [[MyTourroundViewController alloc] initWithNibName:@"MyTourroundViewController" bundle:nil];
    [mytourround setUserCode:userCode :name];
    [self.navigationController pushViewController:mytourround animated:YES];
}
@end
