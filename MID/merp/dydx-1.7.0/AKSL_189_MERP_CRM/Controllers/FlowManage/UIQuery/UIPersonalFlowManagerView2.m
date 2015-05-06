//
//  UIPersonalFlowManagerView2.m
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-23.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UIPersonalFlowManagerView2.h"
#import "UIFlowUploadCell.h"
#import "FlowManagerDetailController.h"
#import "HttpApiCall.h"
#import "BaseViewController.h"
#import "FlowQueryViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "UIFlowYestodayCell.h"
#import "FlowSubOrgViewController.h"

@interface UIPersonalFlowManagerView2(){
@private
    UIColor *colorSubTitle;
    UIColor *colorTaget;
    UIColor *colorDefault;
    __weak UIViewController *controller;
    NSDictionary *json;
    NSArray *jsonArray;
    int i;
}
@property (strong, nonatomic) IBOutlet UIView *view01;
@property (strong, nonatomic) IBOutlet UIView *view02;
@property (strong, nonatomic) IBOutlet UIView *viewTitle01;
@property (strong, nonatomic) IBOutlet UIView *viewTitle02;
@property (strong, nonatomic) IBOutlet UIView *viewNoData;

@property (strong, nonatomic) IBOutlet UITableView *tableViewInfo;
@property (strong, nonatomic) IBOutlet UILabel *lableCurrentMothNum;
@property (strong, nonatomic) IBOutlet UILabel *lableTotalNum;
@property (strong, nonatomic) IBOutlet UILabel *lableCurrentTimeNum;

@property (strong, nonatomic) IBOutlet UILabel *lable01Title;
@property (strong, nonatomic) IBOutlet UILabel *lable02Title;

@property (strong, nonatomic) IBOutlet UIButton *buttonQuery;

@end
@implementation UIPersonalFlowManagerView2
+(id) getNewInstance{
    UIPersonalFlowManagerView2 *cvc = [[[NSBundle mainBundle] loadNibNamed:@"UIPersonalFlowManagerView2" owner:self options:nil] lastObject];
    cvc->colorSubTitle = [UIColor colorWithRed:0.988 green:1.000 blue:0.957 alpha:1];
    cvc->colorTaget = [UIColor colorWithRed:0.682 green:0.859 blue:0.475 alpha:1];
    cvc->colorDefault = [UIColor colorWithRed:0.416 green:0.416 blue:0.416 alpha:1];
    return cvc;
}
-(void) willMoveToSuperview:(UIView *)newSuperview{
    if(i){
        return;
    }
    i=1;
    _tableViewInfo.delegate = self;
    _tableViewInfo.dataSource = self;
    _tableViewInfo.showsHorizontalScrollIndicator = NO;
    _tableViewInfo.showsVerticalScrollIndicator = NO;
    _viewTitle01.backgroundColor = colorSubTitle;
    _viewTitle02.backgroundColor = colorSubTitle;
    //=>
    [self setCornerRadiusAndBorder:_viewTitle02];
    [self setCornerRadiusAndBorder:_viewTitle01];
    _lable01Title.textColor = colorDefault;
    _lable02Title.textColor = colorDefault;
    _lableCurrentTimeNum.textColor = colorTaget;
    [self setCornerRadiusAndBorder:_view01];
    [self setCornerRadiusAndBorder:_view02];
    [self setCornerRadiusAndBorder:_viewTitle01];
    [self setCornerRadiusAndBorder:_viewTitle02];
    [_viewNoData setHidden:YES];
    //<==
    //==>
    UINib *nib = [UINib nibWithNibName:@"UIFlowYestodayCell" bundle:nil];
    [_tableViewInfo registerNib:nib forCellReuseIdentifier:@"UIFlowYestodayCell"];
    [_buttonQuery addTarget:self action:@selector(clickQuery:) forControlEvents:UIControlEventTouchUpInside];
    //<==
    [self reloadDatax];
    [super willMoveToSuperview:newSuperview];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return jsonArray?[jsonArray count]:0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIFlowYestodayCell *fuc  = [_tableViewInfo dequeueReusableCellWithIdentifier:@"UIFlowYestodayCell"];
    UIView *u = [UIView new];
    u.backgroundColor = [UIColor colorWithRed:0.306 green:0.306 blue:0.306 alpha:0.5];
    [fuc setSelectedBackgroundView:u];
    NSDictionary *jsonx = [jsonArray objectAtIndex:[indexPath row]];
    [fuc setData:jsonx];
    return fuc;
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
-(void) setController:(UIViewController*) vc{
    controller = vc;
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
    url =[NSString stringWithFormat:@"%@/%@/%@/%@",urlsuffix,type,@"yesterday",@"yesterday"];
    
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
                _lableCurrentMothNum.text = [NSString isEnabled:totalReport]?((NSNumber*)totalReport).stringValue:@"0";
                _lableTotalNum.text = [NSString isEnabled:validReport]?((NSNumber*)validReport).stringValue:@"0";
                jsonArray = [json objectForKey:@"customerData"];
                if(jsonArray&&[jsonArray count]){
                    [_tableViewInfo setHidden:NO];
                    [_viewNoData setHidden:YES];
                    [_tableViewInfo reloadData];
                }else{
                    [_tableViewInfo setHidden:YES];
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
    _lableCurrentMothNum.text = @"";
    _lableTotalNum.text = @"";
    [_tableViewInfo setHidden:YES];
    [_viewNoData setHidden:NO];
    [((BaseViewController*)self->controller) showActivityIndicator];
    [request startAsynchronous];
}
-(void) clickQuery:(id) sender{
    FlowQueryViewController *fqvc = [[FlowQueryViewController alloc] initWithNibName:@"FlowQueryViewController" bundle:nil];
    [self->controller.mm_drawerController.navigationController pushViewController:fqvc animated:YES];
}

@end
