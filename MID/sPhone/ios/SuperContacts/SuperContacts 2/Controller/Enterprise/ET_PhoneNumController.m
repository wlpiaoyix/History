//
//  ET_PhoneNumController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-1-23.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ET_PhoneNumController.h"
#import "UIViewController+MMDrawerController.h"
#import "ET_EnterpriseTypeLeftView.h"
#import "ET_EnterpriseTypeRightView.h"
#import "ET_PhoneNumListController.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
@interface ET_PhoneNumController (){
@private
    CallBackClickEnterpriseType1 type1;
    CallBackClickEnterpriseType2 type2;
    bool flagReloadData;
}
@property (strong, nonatomic) IBOutlet UIScrollView *viewEnterpriseType;
@property (strong, nonatomic) NSMutableArray *jsonData;
@property (strong, nonatomic) ET_PhoneNumListController *listController;
@end

@implementation ET_PhoneNumController
+(id) getNewInstance{
    return [[ET_PhoneNumController alloc]initWithNibName:@"ET_PhoneNumController" bundle:nil];
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
    [_viewEnterpriseType setScrollEnabled:YES];
//    [_viewEnterpriseType setPagingEnabled:YES];
    _viewEnterpriseType.showsHorizontalScrollIndicator = NO;
    _viewEnterpriseType.showsVerticalScrollIndicator = NO;
    
    _listController = [[ET_PhoneNumListController alloc] initWithNibName:@"ET_PhoneNumListController" bundle:nil];
    __weak typeof(self) tempself = self;
    type1 = ^(int curtype, NSString *curname) {
        NSLog(@"%@  %d",curname,curtype);
        tempself.listController.title = curname;
        tempself.listController.type = curtype;
        tempself.listController.cityId = 1;
        [tempself.mm_drawerController.navigationController pushViewController: tempself.listController animated:YES];
    };
    type2 = ^(int curtype, NSString *curname) {
        NSLog(@"%@  %d",curname,curtype);
        tempself.listController.title = curname;
        tempself.listController.type = curtype;
        tempself.listController.cityId = 1;
        [tempself.mm_drawerController.navigationController pushViewController: tempself.listController animated:YES];
    };
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(flagReloadData){
        return;
    }
    flagReloadData = true;
    __weak typeof(self) tempself = self;
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:@"/enterprise/type" Params:nil Logo:@"getenterprisetype"];
    if(!requestx) return;
    __weak typeof(requestx) request = requestx;
    [request setCompletionBlock:^{
        @try {
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *result = [request responseString];
            if(![NSString isEnabled:result]){
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"没有数据!" userInfo:nil];
            }
            _jsonData = [result JSONValue];
            if (!_jsonData) {
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"没有数据!" userInfo:nil];
            }
            _jsonData = [_jsonData valueForKey:@"data"];
            if (!_jsonData) {
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"没有数据!" userInfo:nil];
            }
            [tempself reloadData];
        }
        @catch (NSException *exception) {
            COMMON_SHOWALERT(exception.reason);
        }
        @finally {
            [tempself hideActivityIndicator];
        }
    }];
    [request setFailedBlock:^{
        COMMON_SHOWALERT(@"网络无回应!");
        [tempself hideActivityIndicator];
    }];
    [request startAsynchronous];
    [super showActivityIndicator];
}
-(void) reloadData{
    int index = 0;
    int tempx = 23238;
    float y = 0.0f;
    NSArray *subviews = [_viewEnterpriseType subviews];
    for (UIView *subView in subviews) {
        if([subView isKindOfClass:[ET_EnterpriseTypeRightView class]]){
            [subView removeFromSuperview];
            continue;
        }
        if([subView isKindOfClass:[ET_EnterpriseTypeLeftView class]]){
            [subView removeFromSuperview];
            continue;
        }
    }
    
    for (id temp in _jsonData) {
        int temp2 = tempx + index;
        int yindex = index/2;
        
        NSString *imageName;
        switch (index) {
            case 0:
            {
                imageName = @"type_mstd.png";
            }
                break;
            case 1:
            {
                imageName = @"type_jd.png";
            }
                break;
            case 2:
            {
                imageName = @"type_yl.png";
            }
                break;
            case 3:
            {
                imageName = @"type_js.png";
            }
                break;
            case 4:
            {
                imageName = @"";
            }
                break;
            default:
                break;
        }
        
        NSDictionary * json = _jsonData[index];
        long  type = ((NSNumber*)[json valueForKey:@"id"]).longValue;
        NSString *value = [json valueForKey:@"value"];
        if(index%2){
            ET_EnterpriseTypeRightView *right = (ET_EnterpriseTypeRightView*)[_viewEnterpriseType viewWithTag:temp2];
            if(!right){
                right = [ET_EnterpriseTypeRightView getNewInstance];
                right.tag = temp2;
            }
            [right setCallBack:type2];
            [right setData:value ImageUrl:imageName Type:type];
            [right removeFromSuperview];
            CGRect r = right.frame;
            r.origin.x = r.size.width;
            r.origin.y = r.size.height*yindex;
            right.frame =  r;
            [_viewEnterpriseType addSubview:right];
        }else{
            ET_EnterpriseTypeLeftView *left = (ET_EnterpriseTypeLeftView*)[_viewEnterpriseType viewWithTag:temp2];
            if(!left){
                left = [ET_EnterpriseTypeLeftView getNewInstance];
                left.tag = temp2;
            }
            [left setCallBack:type1];
            [left setData:value ImageUrl:imageName Type:type];
            [left removeFromSuperview];
            CGRect r = left.frame;
            r.origin.x = 0;
            r.origin.y = r.size.height*yindex;
            left.frame =  r;
            y = r.origin.y;
            [_viewEnterpriseType addSubview:left];
        }
        index++;
    }
    [_viewEnterpriseType setScrollEnabled:YES];
    CGRect r = _viewEnterpriseType.frame;
    r.size.height = (COMMON_SCREEN_H-44-102);
    _viewEnterpriseType.frame = r;
    [_viewEnterpriseType setContentSize:CGSizeMake(320, y+52+20)];
}
- (IBAction)clickToLeft:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
