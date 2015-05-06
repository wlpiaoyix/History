//
//  InspectStoreMainPage.m
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/10.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "InspectStoreMainPage.h"
#import "TransformableTableViewCell.h"
#import "JTTableViewGestureRecognizer.h"
#import "UIColor+JTGestureBasedTableViewHelper.h"
#import "InspectStoreFilterCell.h"
#import "SelectorOfInspectStore.h"
#import "NewInspectCameraPage.h"
#import "UIViewController+MMDrawerController.h"
#import "AddInspectStoreViewController.h"
#import "TourRoundContentViewController.h"
#import "TourRoundAddTagsViewController.h"
#import "HttpApiCall.h"
#import "MyTourroundViewController.h"
#import "InspectStoreInfoListPage.h"


@interface InspectStoreMainPage ()<JTTableViewGestureEditingRowDelegate, JTTableViewGestureMoveRowDelegate,UIActionSheetDelegate>{
    NSMutableArray * listForData;
    NSIndexPath * deleteIndex;
    int startTagId;
    int endTagId;
}

@property (nonatomic, strong) JTTableViewGestureRecognizer *tableViewRecognizer;
@property (nonatomic, strong) SelectorOfInspectStore * grabbedObject;

@end

@implementation InspectStoreMainPage

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
    self.tabelViewForList.delegate = self;
    self.tabelViewForList.dataSource = self;
    listForData = [NSMutableArray new];
    
    // Do any additional setup after loading the view from its nib.
    self.tableViewRecognizer = [self.tabelViewForList enableGestureTableViewWithDelegate:self];
    
//    for (int i=0; i<10; i++) {
//        SelectorOfInspectStore * selector = [SelectorOfInspectStore new];
//        selector.type = i;
//        selector.isCanDelete = i>1;
//        selector.isCanMove =YES;
//        selector.title = [NSString stringWithFormat:@"最新%ld",random()];
//        if (i==1) {
//             selector.title = @"我的";
//        }
//        if(i==2){
//           selector.title = @"点赞";
//        }
//        if (i==3) {
//            selector.title = @"评价";
//        }
//        if(i== 9){
//           selector.title = @"添加标签";
//            selector.type = 4;
//            selector.isCanDelete =NO;
//            selector.isCanMove =NO;
//        }
//        
//        selector.countOfComment = 20;
//        selector.countOfLike = 13;
//        selector.countOfRemind = 2;
//        selector.isMoveing = NO;
//        [listForData addObject:selector];
//    }
    [self getTagsData];
    UINib * nib = [UINib nibWithNibName:@"InspectStoreFilterCell" bundle:nil];
    [self.tabelViewForList registerNib:nib forCellReuseIdentifier:@"InspectStoreFilterCell"];
    
}

-(void)getTagsData
{
    NSString *url = @"/api/inspection/main";
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_tags_main"];
    __weak ASIFormDataRequest *request = requestx;
    //[self showActivityIndicator];
    [request setCompletionBlock:^
     {
         [request setResponseEncoding:NSUTF8StringEncoding];
         NSString *reArg = [request responseString];
         NSDictionary *dic = [reArg JSONValueNewMy];
         if ([dic objectForKey:@"insTabs"] == nil) {
             return;
         }
         listForData = [SelectorOfInspectStore setjson:[dic objectForKey:@"insTabs"]];
         [self.tabelViewForList reloadData];
     }];
    [request setFailedBlock:^{
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];
}
//Table DataSoucre
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return listForData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"InspectStoreFilterCell";
    InspectStoreFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    SelectorOfInspectStore * info = listForData[indexPath.row];
    
    [cell setData:info];
    //NSLog(@"Info:Row:%d----%@",indexPath.row,cell?@" True":@" False");
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectorOfInspectStore *selector = [listForData objectAtIndex:indexPath.row];
    selector.countOfRemind =0;
    if (selector.type == 4) {
        TourRoundAddTagsViewController *addTags= [[TourRoundAddTagsViewController alloc] initWithNibName:@"TourRoundAddTagsViewController" bundle:nil];
        [addTags setRetureMethods:^(NSDictionary *tagDic)
         {
             if (tagDic != nil) {
                 SelectorOfInspectStore * selector = [SelectorOfInspectStore new];
                 selector.title = [tagDic objectForKey:@"title"];
                 selector.imageUrl = API_IMAGE_URL_GET2([tagDic objectForKey:@"coverPic"]);
                 selector.userCode = [tagDic objectForKey:@"desc"];
                 selector.condition = [tagDic objectForKey:@"condition"];
                 if ([[tagDic objectForKey:@"type"] isEqualToString:@"default"]) {
                     selector.isCanDelete = NO;
                 }
                 else
                 {
                     selector.isCanDelete = YES;
                 }
                 selector.type = 5;
                 selector.tagId = [[tagDic objectForKey:@"id"] intValue];
                 selector.isCanMove = YES;
                 [listForData insertObject:selector atIndex:listForData.count-1];
             }
             [self.tabelViewForList reloadData];
         }];
        [self.mm_drawerController.navigationController pushViewController:addTags animated:YES];
    }
    
    else if (selector.type == 1) {
        MyTourroundViewController *mytourround = [[MyTourroundViewController alloc] initWithNibName:@"MyTourroundViewController" bundle:nil];
        [mytourround setUserCode:[ConfigManage getLoginUser].userCode :selector.title];
        [self.mm_drawerController.navigationController pushViewController:mytourround animated:YES];
        selector.countOfComment = 0;
        selector.countOfLike = 0;
    }
    else if (selector.type == 5 && selector.userCode !=nil && [selector.condition hasPrefix:@"user"])
    {
        MyTourroundViewController *mytourround = [[MyTourroundViewController alloc] initWithNibName:@"MyTourroundViewController" bundle:nil];
        [mytourround setUserCode:selector.userCode :selector.title];
        [self.mm_drawerController.navigationController pushViewController:mytourround animated:YES];
        selector.countOfComment = 0;
        selector.countOfLike = 0;
    }else{
        InspectStoreInfoListPage * viewlist = [[InspectStoreInfoListPage alloc]initWithNibName:@"InspectStoreInfoListPage" bundle:nil];
        [viewlist setData:selector];
        [self.mm_drawerController.navigationController pushViewController:viewlist animated:YES];
    }
    [tableView  reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark JTTableViewGestureEditingRowDelegate

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer didEnterEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath {
    //InspectStoreFilterCell *cell = (InspectStoreFilterCell*)[self.tabelViewForList cellForRowAtIndexPath:indexPath];
    //cell.contentView.frame = cell.bounds;
    UIColor *backgroundColor = nil;
    switch (state) {
        case JTTableViewCellEditingStateMiddle:
            backgroundColor = [UIColor greenColor];
            break;
        case JTTableViewCellEditingStateRight:
            backgroundColor = [UIColor greenColor];
            break;
            case JTTableViewCellEditingStateLeft:
            
            break;
        default:
           
           // backgroundColor = [UIColor darkGrayColor];
            break;
    }
    // cell.contentView.backgroundColor = backgroundColor;
   // if ([cell isKindOfClass:[TransformableTableViewCell class]]) {
   ///     ((TransformableTableViewCell *)cell).tintColor = backgroundColor;
   // }
}

// This is needed to be implemented to let our delegate choose whether the panning gesture should work
- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectorOfInspectStore * info = listForData[indexPath.row];
    return info.isCanDelete;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer commitEditingState:(JTTableViewCellEditingState)state forRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *tableView = gestureRecognizer.tableView;
    [tableView beginUpdates];
    if (state == JTTableViewCellEditingStateLeft) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"是否删除标签"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"确定",nil];
        deleteIndex = indexPath;
        [actionSheet showInView:self.view];
        //[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else if (state == JTTableViewCellEditingStateRight) {
        // An example to retain the cell at commiting at JTTableViewCellEditingStateRight
       // [self.rows replaceObjectAtIndex:indexPath.row withObject:DONE_CELL];
        //[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } else {
        // JTTableViewCellEditingStateMiddle shouldn't really happen in
        // - [JTTableViewGestureDelegate gestureRecognizer:commitEditingState:forRowAtIndexPath:]
    }
    
    [tableView endUpdates];
    
    // Row color needs update after datasource changes, reload it.
    [tableView performSelector:@selector(reloadVisibleRowsExceptIndexPath:) withObject:indexPath afterDelay:JTTableViewRowAnimationDuration];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!deleteIndex) {
        return;
    }
     [_tabelViewForList beginUpdates];
    SelectorOfInspectStore *store = [listForData objectAtIndex:deleteIndex.row];
    switch (buttonIndex) {
        case 0:
            [listForData removeObjectAtIndex:deleteIndex.row];
            [self deleteTag:store.tagId];
            [_tabelViewForList  deleteRowsAtIndexPaths:[NSArray arrayWithObject:deleteIndex] withRowAnimation:UITableViewRowAnimationMiddle];
            deleteIndex =nil;
            break;
        default:
            [_tabelViewForList  reloadRowsAtIndexPaths:[NSArray arrayWithObject:deleteIndex] withRowAnimation:UITableViewRowAnimationRight];
            deleteIndex =nil;
            break;
    }
     [_tabelViewForList endUpdates];
}
-(void)deleteTag:(int)tagId
{
    NSString *url = [NSString stringWithFormat:@"/api/inspection/tab/%i",tagId];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallDELET:url Logo:@"deleta_tag"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^
     {
         [request setResponseEncoding:NSUTF8StringEncoding];
         NSString *responseString = [request responseString];
         NSDictionary * dicRes = [responseString JSONValueNewMy];
         if (!dicRes) {
             return;
         }
     }];
    [request setFailedBlock:^
     {
         
     }];
    [request startAsynchronous];
    
}
#pragma mark JTTableViewGestureMoveRowDelegate

- (BOOL)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectorOfInspectStore * info = listForData[indexPath.row];
    return info.isCanMove;
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsCreatePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
     self.grabbedObject = [listForData objectAtIndex:indexPath.row];
    self.grabbedObject.isMoveing = YES;
   // [self.rows replaceObjectAtIndex:indexPath.row withObject:DUMMY_CELL];
    SelectorOfInspectStore *store = [listForData objectAtIndex:indexPath.row];
    startTagId = store.tagId;

}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsMoveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if(destinationIndexPath.row <listForData.count-1&&sourceIndexPath.row!=listForData.count-1){
        id object = [listForData objectAtIndex:sourceIndexPath.row];
        [listForData removeObjectAtIndex:sourceIndexPath.row];
        [listForData insertObject:object atIndex:destinationIndexPath.row];
    }
}

- (void)gestureRecognizer:(JTTableViewGestureRecognizer *)gestureRecognizer needsReplacePlaceholderForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.grabbedObject.isMoveing = NO;
   // [self.rows replaceObjectAtIndex:indexPath.row withObject:self.grabbedObject];
     self.grabbedObject = nil;
    if (indexPath.row == 0) {
        endTagId = 0;
    }
    else{
        SelectorOfInspectStore *store = [listForData objectAtIndex:indexPath.row-1];
        endTagId = store.tagId;
    }
    
    [self updataTagPosition];

}
-(void)updataTagPosition
{
    NSString *url = [NSString stringWithFormat:@"/api/inspection/tab/sort/%i/%i",startTagId,endTagId];
    __weak ASIFormDataRequest *requestx = [HttpApiCall requestCallPUT:url Params:nil Logo:@"update_tagPosition"];
    [requestx setCompletionBlock:^{
        [requestx setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [requestx responseString];
    }];
    [requestx setFailedBlock:^{
        UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:@"错误" message: @"服务器没有响应！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }];
    [requestx startSynchronous];
}
-(IBAction)goAddInspect:(id)sender{
    AddInspectStoreViewController * newinspect = [[AddInspectStoreViewController alloc]initWithNibName:@"AddInspectStoreViewController" bundle:nil];
    [self.mm_drawerController.navigationController pushViewController:newinspect animated:YES];
}

-(IBAction)topbutclick:(id)sender{
    [self topButtonClick:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
