//
//  MyScheduleCustomerViewController.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-8.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "MyScheduleCustomerViewController.h"
#import "TableViewTools.h"
#import "MyScheduleCustomerCell.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "NSDate+convenience.h"
#import "ConfigManage.h"
@interface MyScheduleCustomerViewController ()
@property (retain, nonatomic) IBOutlet UITableView *tvc;
@property bool nibsRegistered;
@end

@implementation MyScheduleCustomerViewController

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
    
    if(!self.selected)self.selected = [[NSMutableArray alloc]init];
    NSString *url = @"/api/user/sub";
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_current_month_schedules"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            self.datas = [reArg JSONValueNewMy];
            [super hideActivityIndicator];
            [self.tvc reloadData];
        }
        @catch (NSException *exception) {
            self.datas = NO;
//            showAlertBox(@"提示", exception.reason);
        }
        @finally {
            [super hideActivityIndicator];
        }
        
    }];
    [request setFailedBlock:^{
        self.datas = NO;
        [super hideActivityIndicator];
    }];
    [super showActivityIndicator];
    [request startAsynchronous];
//    NSArray *data = [[NSArray alloc]initWithObjects:[@"{\"text\":\"sdfsdfsd\"}" JSONValue], nil];
//    TableViewTools *tvt = [TableViewTools init];
//    [tvt setDatas:data];
//    CGRect r = tvt.frame;
//    r.origin.y = 42;
//    r.size.width = 320;
//    r.size.height = self.view.frame.size.height-42;
//    tvt.frame = r;
//    [self.view addSubview:tvt];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)toucheControll:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"MyScheduleCustomerCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"MyScheduleCustomerCell"];
        self.nibsRegistered = YES;
    }
    MyScheduleCustomerCell *tvc  = [tableView dequeueReusableCellWithIdentifier:@"MyScheduleCustomerCell"];
    NSDictionary *json = self.datas[[indexPath row]];
    NSString *image = [[json objectForKey:@"portrait"] objectForKey:@"attachUrl"];
    NSString *userName = [json objectForKey:@"userName"];
    NSDictionary *organization = [json objectForKey:@"organization"];
    if([NSString isEnabled:image]){
        tvc.imageHead.imageUrl = nil;
        tvc.imageHead.imageUrl = API_IMAGE_URL_GET2(image);
    }
    tvc.lableUserName.text = userName;
    tvc.lableInfo.text = [organization objectForKey:@"shortName"];
    NSNumber *ids = [[NSNumber alloc]initWithLongLong:[((NSString*)[json objectForKey:@"userCode"]) longLongValue]];
    if(self.selected){
        for (NSNumber *_id in self.selected) {
            if([ids longLongValue]==[_id longLongValue]){
                [tableView selectRowAtIndexPath:indexPath animated:YES
                                 scrollPosition:UITableViewScrollPositionNone];
                break;
            }
        }
    }
    UIView *u = [[UIView alloc]init];
    [u setBackgroundColor:[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1]];
    [tvc setSelectedBackgroundView:u];
    return tvc;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *json = self.datas[[indexPath row]];
    NSNumber *ids = [[NSNumber alloc]initWithLongLong:[((NSString*)[json objectForKey:@"userCode"]) longLongValue]];
    bool ifhas = NO;
    for (NSNumber *_ids in self.selected) {
        if(_ids.longLongValue == ids.longLongValue){
            ifhas = YES;
            break;
        }
    }
    if(!ifhas){
        [self.selected addObject:ids];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *json = self.datas[[indexPath row]];
    NSNumber *ids = [[NSNumber alloc]initWithLongLong:[((NSString*)[json objectForKey:@"userCode"]) longLongValue]];
    for (NSNumber *_ids in self.selected) {
        if(_ids.longLongValue == ids.longLongValue){
            [self.selected removeObject:_ids];
            break;
        }
    }
}
- (IBAction)clickConfirm:(id)sender {
    NSMutableArray *userIds = [[NSMutableArray alloc]init];
    NSMutableArray *userNames = [[NSMutableArray alloc]init];
    for(NSNumber *ids in self.selected){
        NSDictionary *json = [self getJSONData:ids];
        if(json&&json!=nil){
            [userIds addObject:ids];
            [userNames addObject:[json objectForKey:@"userName"]];
        }
    }
    [self.targets performSelector:self.methods withObject:userIds withObject:userNames];
    [self.navigationController popViewControllerAnimated:YES];
}
-(NSDictionary*) getJSONData:(NSNumber*) ids{
    for (NSDictionary *json in self.datas) {
        if([((NSString*)[json objectForKey:@"userCode"]) longLongValue] ==[ids longLongValue]){
            return json;
        }
    }
    return nil;
}
@end
