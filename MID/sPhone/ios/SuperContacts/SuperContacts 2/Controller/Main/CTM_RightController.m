//
//  CTM_RightController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-8.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CTM_RightController.h"
#import "CTM_MainController.h"
#import "CTM_Contents_Cell.h"
#import "SABFromDataBaseService.h"
#import "CTM_Contents_Section.h"
#import "CTM_AddContentController.h"
#import "CTM_ViewContentControllerViewController.h"
#import "SerCallService.h"
#import "EntityPhone.h"
static CTM_RightController *xrightController;
@interface CTM_RightController (){
@private NSString *showarg;
}
@property NSArray *contantDatas;
@property SABFromDataBaseService *fdbs;
@property char* headchar;

@property (strong, nonatomic) IBOutlet UILabel *lableShow;

@property NSMutableArray *headHC;
@property NSMutableArray *dataArray;

@property bool ifnothidden;
@property EntityUser *userSelected;
@property NSArray *phones;
@end

@implementation CTM_RightController

+(id) getSingleInstance{
    @synchronized(xrightController){
        if(!xrightController){
            xrightController = [[CTM_RightController alloc]initWithNibName:@"CTM_RightController" bundle:nil];
            xrightController.fdbs = COMMON_FDBS;
            xrightController.headchar = "0123456789ABCDEFGHJKLMNOPQRSTUVWXYZ";
            xrightController.headHC = [[NSMutableArray alloc]init];
            xrightController.dataArray = [[NSMutableArray alloc] init];
        }
    }
    return xrightController;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) refreshData{
    if(xrightController){
        [xrightController queryData:xrightController.searchBarInfo.text];
        [xrightController.tableViewContents reloadData];
    }
}
-(void) queryData:(NSString*) params{
    if (params&&params.length>0) {
        params = [params uppercaseString];
    }
    _contantDatas = [_fdbs queryEntityUserByParams:params IfChekNum:false];
    [_headHC removeAllObjects];
    [_dataArray removeAllObjects];
    int count = 0;
    int maxl = [_contantDatas count];
    for (int i=0;i<strlen(_headchar);i++) {
        if(count==maxl) break;
        char xc = _headchar[i];
        NSString  *temp2 = [NSString stringWithFormat:@"%c",xc];
        bool flag = false;
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (EntityUser *user in _contantDatas) {
            if([user.longPingYing hasPrefix:temp2]){
                [temp addObject:user];
                count++;
                if(!flag)[_headHC addObject:temp2];
                flag = true;
            }
        }
        if([temp count]>0){
            [_dataArray addObject:temp];
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchBarInfo.delegate = self;
//    [self.searchBarInfo setShowsCancelButton:YES animated:YES];
    [self.searchBarInfo setShowsSearchResultsButton:YES];
    [self queryData:nil];
    [_lableShow setHidden:YES];
    UINib *nib = [UINib nibWithNibName:@"CTM_Contents_Cell" bundle:nil];
    [_tableViewContents registerNib:nib forCellReuseIdentifier:@"CTM_Contents_Cell"];
    _tableViewContents.showsHorizontalScrollIndicator = NO;
    _tableViewContents.showsVerticalScrollIndicator = NO;
    if(IOS7_OR_LATER){
        [super setCornerRadiusAndBorder:_searchBarInfo CornerRadius:5 BorderWidth:0 BorderColor:[[UIColor clearColor]  CGColor]];
    }else if(IOS6_OR_LATER){
        [super setCornerRadiusAndBorder:_searchBarInfo CornerRadius:_searchBarInfo.frame.size.height/2 BorderWidth:0 BorderColor:[[UIColor clearColor]  CGColor]];
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = [_dataArray count]?[((NSArray*)[_dataArray objectAtIndex:section]) count ]:0;
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.ifnothidden)[self.searchBarInfo resignFirstResponder];
    int _indexForTable = indexPath.section;
    EntityUser *user = ((NSArray*)_dataArray[_indexForTable])[[indexPath row]];
    CTM_Contents_Cell *ccc  = [tableView dequeueReusableCellWithIdentifier:@"CTM_Contents_Cell"];
    showarg =[user.userName substringToIndex:1];
    _lableShow.text = showarg;
    showarg = false;
    [ccc setEntityUser:user];
    __weak typeof(self) tempself = self;
    
    [ccc setContentsClickCall:^(EntityUser *user) {
        NSString *title = [NSString stringWithFormat:@"呼叫 %@",user.userName];
        _phones= [user getTelephones];
        NSString *phone1 = ((EntityPhone*)[_phones objectAtIndex:0]).phoneNum;
        NSString *phone2 = [_phones count]>=2?((EntityPhone*)[_phones objectAtIndex:1]).phoneNum:nil;
        NSString *phone3 = [_phones count]>=3?((EntityPhone*)[_phones objectAtIndex:2]).phoneNum:nil;
        NSString *phone4 = [_phones count]>=4?((EntityPhone*)[_phones objectAtIndex:3]).phoneNum:nil;
        NSString *phone5 = [_phones count]>=5?((EntityPhone*)[_phones objectAtIndex:4]).phoneNum:nil;
        COMMON_SHOWSHEET(title, tempself.view, tempself, phone1,phone2,phone3,phone4,phone5);
    }];
    UIView *ux = [UIView new];
    UIImage *image = [UIImage imageNamed:@"contents_selected_bg.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [ux addSubview:imageView];
    [ccc setSelectedBackgroundView:ux];
    return ccc;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 22.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.searchBarInfo resignFirstResponder]){
        return;
    }
    int _indexForTable = indexPath.section;
    _userSelected = ((NSArray*)_dataArray[_indexForTable])[[indexPath row]];
    CTM_ViewContentControllerViewController  *c = [CTM_ViewContentControllerViewController getSingleInstance];
    [c setEntityUser:_userSelected];
    [self.navigationController pushViewController:c animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_headHC count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *title = _headHC[section];
    return title;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0){
    return 22.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *temp = [[NSBundle mainBundle] loadNibNamed:@"CTM_Contents_Section" owner:self options:nil];
    CTM_Contents_Section *ccs = [temp lastObject];
    [ccs setBackgroundColor:[UIColor colorWithRed:0.290 green:0.408 blue:0.518 alpha:1]];
    NSString *title = _headHC[section];
    [ccs setTitleName:title];
    return ccs;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBarInfo resignFirstResponder];
    [_lableShow setHidden:NO];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_lableShow setHidden:YES];
    _lableShow.text = @"";
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.ifnothidden = true;
    [searchBar resignFirstResponder];
    [self queryData:searchBar.text];
    [_tableViewContents reloadData];
    NSLog(@"search bar vale:%@",searchBar.text);
    self.ifnothidden = false;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText; {
    [self queryData:searchText];
    [_tableViewContents reloadData];
    NSLog(@"search bar vale:%@",searchBar.text);
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
- (IBAction)addContents:(id)sender {
    CTM_AddContentController *c = [CTM_AddContentController getNewInstance];
    [c setTitleName:@"新增通信录"];
    [c setEntityUser:false];
    [c setCallBackSave:false];
    [self.navigationController pushViewController:c animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex>=[_phones count]){
        return;
    }
    EntityPhone *phone = [_phones objectAtIndex:buttonIndex];
    [SerCallService call:phone.phoneNum];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
