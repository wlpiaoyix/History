//
//  ET_PhoneNumListController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-26.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ET_PhoneNumListController.h"
#import "BSB_SearchBarView.h"
#import "ET_PhoneNumCell.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "ET_EnterpriseAddressController.h"
@interface ET_PhoneNumListController (){
@private
    NSLock *lock;
    NSMutableArray *jsonData;
    int count;
    bool hasNoData;
    bool flagCanRefresh;//是否能刷新
}
@property (strong, nonatomic) IBOutlet UILabel *lableTitle;
@property (strong, nonatomic) IBOutlet UIView *viewSearch;
@property (strong, nonatomic) IBOutlet UITableView *tableIViewData;
@property (strong, nonatomic) BSB_SearchBarView *searchBar;
@end

@implementation ET_PhoneNumListController

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
    flagCanRefresh = YES;
    _searchBar = [BSB_SearchBarView getNewInstance];
    __weak typeof(self) tempself = self;
    [_searchBar setCallBackSearch:^(NSString *text) {
        [tempself reloadData:0 SearchValue:text];
    }];
    [_viewSearch addSubview:_searchBar];
    // Do any additional setup after loading the view from its nib.
   UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(resignResponder)];
    [recognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:recognizer];
    _tableIViewData.delegate = self;
    _tableIViewData.dataSource = self;
    _tableIViewData.showsHorizontalScrollIndicator = NO;
    _tableIViewData.showsVerticalScrollIndicator = NO;
    UINib *nib = [UINib nibWithNibName:@"ET_PhoneNumCell" bundle:nil];
    [_tableIViewData registerNib:nib forCellReuseIdentifier:@"ET_PhoneNumCell"];
    
    jsonData = [NSMutableArray new];
    lock = [NSLock new];
    count = 5;
}
-(void) resignResponder{
    [[_searchBar getTextField] resignFirstResponder];
}
-(void) reloadData:(int) startIndex SearchValue:(NSString*) searchValue {
    @try {
        [lock lock];
        if(!flagCanRefresh){
            flagCanRefresh = YES;
            [lock unlock];
            return;
        }
        if(!startIndex) {
            [jsonData removeAllObjects];
            hasNoData = NO;
        }
        __weak typeof(self) tempself = self;
        NSString *url;
        if([NSString isEnabled:searchValue]){
            url = [NSString stringWithFormat:@"/enterprise/%lli/%lli/%@/%i/%i",_type,_cityId,searchValue,startIndex,count];
        }else{
            url = [NSString stringWithFormat:@"/enterprise/%lli/%lli/%i/%i",_type,_cityId,startIndex,count];
        }
        ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"getenterprise"];
        __weak typeof(requestx) request = requestx;
        [request setCompletionBlock:^{
            @try {
                [request setResponseEncoding:NSUTF8StringEncoding];
                NSString *result = [request responseString];
                if(![NSString isEnabled:result]){
                    @throw [[NSException alloc] initWithName:@"空异常" reason:@"没有数据!" userInfo:nil];
                }
                NSArray *jsonDatax = [result JSONValue];
                if (!jsonDatax) {
                    @throw [[NSException alloc] initWithName:@"空异常" reason:@"没有数据!" userInfo:nil];
                }
                jsonDatax = [jsonDatax valueForKey:@"data"];
                if (!jsonDatax) {
                    @throw [[NSException alloc] initWithName:@"空异常" reason:@"没有数据!" userInfo:nil];
                }
                jsonDatax = [jsonDatax valueForKey:@"data"];
                if (!jsonDatax) {
                    @throw [[NSException alloc] initWithName:@"空异常" reason:@"没有数据!" userInfo:nil];
                }
                if(![jsonDatax count]){
                    [_tableIViewData reloadData];
                    hasNoData = YES;
                }else{
                    [jsonData addObjectsFromArray:jsonDatax];
                    [_tableIViewData reloadData];
                }
            }
            @catch (NSException *exception) {
                COMMON_SHOWALERT(exception.reason);
            }
            @finally {
                [lock unlock];
                [tempself hideActivityIndicator];
            }
        }];
        [request setFailedBlock:^{
            COMMON_SHOWALERT(@"没有数据!");
            [lock unlock];
            [tempself hideActivityIndicator];
        }];
        [request startAsynchronous];
        [super showActivityIndicator];
    }
    @catch (NSException *exception) {
        [lock unlock];
    }
    
}
-(void) viewWillAppear:(BOOL)animated{
    [self reloadData:0 SearchValue:nil];
    _lableTitle.text = self.title;
   
    [super viewWillAppear:animated];
}
- (IBAction)clickReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return jsonData?[jsonData count]:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ET_PhoneNumCell *pnc  = [tableView dequeueReusableCellWithIdentifier:@"ET_PhoneNumCell"];
    int row = [indexPath row];
    UIView *ux = [UIView new];
    ux.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1];
    [pnc setSelectedBackgroundView:ux];
    NSDictionary *json = jsonData[row];
    NSString *name = [json valueForKey:@"fullName"];
    NSString *address = [json valueForKey:@"postalAddress"];
    NSString *imageUrl = [json valueForKey:@"defaultPicUrl"];
    [pnc setData:name Address:address ImageUrl:COMMON_GET_IMAGE_URL(imageUrl)];
    if(row+1 == [jsonData count]&&!((row+1)%5)&&!hasNoData){
        [self reloadData:row+1 SearchValue:[_searchBar getTextField].text];
    }
    return pnc;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self resignResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *json = jsonData[[indexPath row]];
    ET_EnterpriseAddressController *eac = [ET_EnterpriseAddressController getNewInstance];
    NSString *enterpriseName = [json valueForKey:@"fullName"];
    NSString *enterpriseAddress = [json valueForKey:@"postalAddress"];
    NSString *enterprisePhone = [json valueForKey:@"phoneNum"];
    NSString *longitudeAndLatitude = [json valueForKey:@"longitudeAndLatitude"];
    CGPoint p = CGPointMake(106.46925236786f,29.566308760492f);
    if([NSString isEnabled:longitudeAndLatitude]){
        NSArray *temparray = [longitudeAndLatitude  componentsSeparatedByString:@","];
        NSString *longitude = temparray[0];
        NSString *latitude = temparray[1];
        p = CGPointMake(longitude.floatValue, latitude.floatValue);
    }
    [eac setData:enterpriseName EnterpriseAddress:enterpriseAddress EnterprisePhone:enterprisePhone Point:p];
    [self.navigationController pushViewController:eac animated:YES];
    flagCanRefresh = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self resignResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
