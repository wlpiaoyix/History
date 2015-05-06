//
//  UIFlowInfoView.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UIFlowInfoView.h"
#import "MainFlowInfoCell.h"
#import "FlowManagerDetailController.h"
#import "FlowUpreportController.h"
#import "UIViewController+MMDrawerController.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "BaseViewController.h"
#import "FlowSubOrgViewController.h" 

@interface UIFlowInfoView(){
    UIColor *colorTaget;
    UIColor *colorDefault;
    UIColor *colorSubTitle;
    __weak UIViewController *controller;
    NSDictionary *json;
    NSArray *jsonArray;
    bool ifReloadData;
    int i;
}
@property (strong, nonatomic) IBOutlet UIView *view01;
@property (strong, nonatomic) IBOutlet UIView *view02;
@property (strong, nonatomic) IBOutlet UIView *view01Title;
@property (strong, nonatomic) IBOutlet UIView *view02Title;
@property (strong, nonatomic) IBOutlet UIView *viewNoData;

@property (strong, nonatomic) IBOutlet UILabel *lableCurrentMonthNum;
@property (strong, nonatomic) IBOutlet UILabel *lableTotelNum;
@property (strong, nonatomic) IBOutlet UILabel *lableCurrentTimeNum;
@property (strong, nonatomic) IBOutlet UITableView *tableViewFlowInfo;
@property (strong, nonatomic) IBOutlet UILabel *lable01Title;
@property (strong, nonatomic) IBOutlet UILabel *lable02Title;

@property (strong, nonatomic) IBOutlet UIButton *buttonCommit;

@end
@implementation UIFlowInfoView
+(id) getNewInstance{
    UIFlowInfoView *fiv = [[[NSBundle mainBundle] loadNibNamed:@"UIFlowInfoView" owner:self options:nil] lastObject];
    fiv->colorTaget = [UIColor colorWithRed:0.682 green:0.859 blue:0.475 alpha:1];
    fiv->colorDefault = [UIColor colorWithRed:0.416 green:0.416 blue:0.416 alpha:1];
    fiv->colorSubTitle = [UIColor colorWithRed:0.988 green:1.000 blue:0.957 alpha:1];
    return fiv;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    if(i){
        return;
    }
    i=1;
    [super willMoveToSuperview:newSuperview];
    CGRect r = self.frame;
    r.size.height = SCREEN_HEIGHT-44-47;
    self.frame = r;
    r = _tableViewFlowInfo.frame;
    r.size.height = SCREEN_HEIGHT-44-_buttonCommit.frame.size.height-224;
    _tableViewFlowInfo.frame = r;
    
    _tableViewFlowInfo.delegate = self;
    _tableViewFlowInfo.dataSource = self;
    _tableViewFlowInfo.showsHorizontalScrollIndicator = NO;
    _tableViewFlowInfo.showsVerticalScrollIndicator = NO;
    //==>
    UINib *nib = [UINib nibWithNibName:@"MainFlowInfoCell" bundle:nil];
    [_tableViewFlowInfo registerNib:nib forCellReuseIdentifier:@"MainFlowInfoCell"];
    [_viewNoData setHidden:YES];
    //<==
    //==>
    [_buttonCommit addTarget:self action:@selector(clickViewUpload:) forControlEvents:UIControlEventTouchUpInside];
    //<==
    //==>
    _view01Title.backgroundColor = colorSubTitle;
    _view02Title.backgroundColor = colorSubTitle;
    _lableCurrentTimeNum.textColor = colorTaget;
    _lable01Title.textColor = colorDefault;
    _lable02Title.textColor = colorDefault;
    [self setCornerRadiusAndBorder:_view01];
    [self setCornerRadiusAndBorder:_view02];
    [self setCornerRadiusAndBorder:_view01Title];
    [self setCornerRadiusAndBorder:_view02Title];
    
    //<==
    [self reloadDatax];
    [super willMoveToSuperview:newSuperview];
}
-(void) reloadAllData{
    if(ifReloadData){
        [self reloadDatax];
        ifReloadData = false;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return jsonArray?[jsonArray count]:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainFlowInfoCell *mfic  = [_tableViewFlowInfo dequeueReusableCellWithIdentifier:@"MainFlowInfoCell"];
    UIView *u = [UIView new];
    u.backgroundColor = [UIColor colorWithRed:0.306 green:0.306 blue:0.306 alpha:0.5];
    NSDictionary *jsonx = [jsonArray objectAtIndex:[indexPath row]];
    NSString *phoneNum = [jsonx objectForKey:@"phoneNum"];
    int isPack = [[[jsonx objectForKey:@"trafficPack"] valueForKey:@"dealStatus"] isEqualToString:@"1"]?1:0;
    int isApp = [[[jsonx objectForKey:@"trafficApp"] valueForKey:@"dealStatus"] isEqualToString:@"1"]?2:0;
    int isActive = [[[jsonx objectForKey:@"active"] valueForKey:@"dealStatus"] isEqualToString:@"1"]?4:0;
    int productTypes = 0;
    productTypes = productTypes|isPack;
    productTypes = productTypes|isApp;
    productTypes = productTypes|isActive;
    NSString *time = [jsonx objectForKey:@"reportTime"];
    NSDate *d = [NSDate dateFormateString:time FormatePattern:@"yyyy-MM-dd HH:mm:ss"];
    [mfic setDatas:phoneNum productType:productTypes time:[d getFriendlyTime2]];
    [mfic setSelectedBackgroundView:u];
    return mfic;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * url = [@"/api/traffic/reportdetail/" stringByAppendingString:[[jsonArray objectAtIndex:indexPath.row] valueForKey:@"phoneNum"]];
    FlowSubOrgViewController * flowrest = [[FlowSubOrgViewController alloc]initWithNibName:@"FlowSubOrgViewController" bundle:nil];
    [flowrest setUrlForQuery:url];
    flowrest.isSingerPhoneNum = YES;
     flowrest.phoneNumStr =[[jsonArray objectAtIndex:indexPath.row] valueForKey:@"phoneNum"];
    [controller.mm_drawerController.navigationController pushViewController:flowrest animated:YES];
}
-(void) clickViewUpload:(id) sender{
    FlowUpreportController *fuc  = [FlowUpreportController getNewInstance];
    self->ifReloadData = true;
    [self->controller.mm_drawerController.navigationController pushViewController:fuc animated:YES];
}
-(void) setController:(UIViewController*) vc{
    self->controller = vc;
}
-(void)setCornerRadiusAndBorder:(UIView *)view{
    view.layer.cornerRadius = 5;
//    view.layer.borderWidth = 0.5;
//    view.layer.borderColor = [[UIColor colorWithRed:0.482 green:0.482 blue:0.482 alpha:0.7]CGColor];
}
-(void) reloadDatax{
    NSString *type = @"default";
    NSString *url;
    NSString *urlsuffix = @"/api/traffic/selfreport";
    url =[NSString stringWithFormat:@"%@/%@/%@/%@",urlsuffix,type,@"today",@"today"];

    ASIFormDataRequest *reqeustx = [HttpApiCall requestCallGET:url Params:nil Logo:@"gettrafficstaffreport"];
    __weak typeof(reqeustx) request = reqeustx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *jsonDatas = [reArg JSONValueNewMy];
            if(!jsonDatas){
                @throw [[NSException alloc] initWithName:@"无数据" reason:@"网络没有返回数据" userInfo:nil];
            }
            json = [jsonDatas objectForKey:@"data"];
            if(json){
                id payment = [json valueForKey:@"validPayment"];
                id validReport = [json valueForKey:@"validReport"];
                id totalReport = [json valueForKey:@"totalReport"];
                _lableCurrentTimeNum.text = [NSString isEnabled:payment]?((NSNumber*)payment).stringValue:@"0";
                _lableCurrentMonthNum.text = [NSString isEnabled:totalReport]?((NSNumber*)totalReport).stringValue:@"0";
                _lableTotelNum.text = [NSString isEnabled:validReport]?((NSNumber*)validReport).stringValue:@"0";
                jsonArray = [json objectForKey:@"customerData"];
                if(jsonArray&&[jsonArray count]){
                    [_tableViewFlowInfo setHidden:NO];
                    [_viewNoData setHidden:YES];
                    [_tableViewFlowInfo reloadData];
                }else{
                    [_tableViewFlowInfo setHidden:YES];
                    [_viewNoData setHidden:NO];
                }
            }
        }
        @catch (NSException *exception) {
            showMessageBox(exception.reason);
        }
        @finally {
            [((BaseViewController*)self->controller) hideActivityIndicator];
        }
    }];
    [request setFailedBlock:^{
        [((BaseViewController*)self->controller) hideActivityIndicator];
    }];
    _lableCurrentTimeNum.text = @"";
    _lableCurrentMonthNum.text = @"";
    _lableTotelNum.text = @"";
    [_tableViewFlowInfo setHidden:YES];
    [_viewNoData setHidden:NO];
    [((BaseViewController*)self->controller) showActivityIndicator];
    [request startAsynchronous];
}
@end
