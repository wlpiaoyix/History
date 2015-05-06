//
//  ET_EnterpriseAddressController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-12.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "ET_EnterpriseAddressController.h"
#import "EMAsyncImageView.h"
#import "SerCallService.h"
#import "CLLocationManagerImpl.h"
#import "GTMBase64.h"
#import "ASIFormDataRequest.h"
@interface ET_EnterpriseAddressController (){
@private
    NSString *enterpriseName;
    NSString *enterpriseAddress;
    NSString *enterprisePhone;
    CGPoint pointTo;
    CGPoint pointFrom;
    id syn01;
    NSString *currentCityName;
    NSString *targetCityName;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (strong, nonatomic) IBOutlet UILabel *lableTitleName;
@property (strong, nonatomic) IBOutlet UILabel *lableEnterpriseName;
@property (strong, nonatomic) IBOutlet UILabel *lableEnterpriseAddress;
@property (strong, nonatomic) IBOutlet UILabel *lableDistance;
@property (strong, nonatomic) IBOutlet EMAsyncImageView *imageMap;
@property (strong, nonatomic) IBOutlet UILabel *lablePhone;

@end

@implementation ET_EnterpriseAddressController
+(id) getNewInstance{
    return [[ET_EnterpriseAddressController alloc] initWithNibName:@"ET_EnterpriseAddressController" bundle:nil];
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
    [self setCornerRadiusAndBorder:_imageMap CornerRadius:_imageMap.frame.size.width/2 BorderWidth:0.0f BorderColor:nil];
    CGRect r = _scrollViewMain.frame;
    r.size.height = COMMON_SCREEN_H-44;
    r.origin.y = 44;
    _scrollViewMain.frame = r;
    _scrollViewMain.contentSize = CGSizeMake(COMMON_SCREEN_W, 524.0f);
    _scrollViewMain.scrollEnabled = YES;
    _scrollViewMain.showsHorizontalScrollIndicator = NO;
    _scrollViewMain.showsVerticalScrollIndicator = NO;
}
-(void) setData:(NSString*) enterpriseNamex EnterpriseAddress:(NSString*) enterpriseAddressx EnterprisePhone:(NSString*) enterprisePhonex Point:(CGPoint) pointx{
    enterpriseName = enterpriseNamex;
    enterpriseAddress = enterpriseAddressx;
    enterprisePhone = enterprisePhonex;
    pointTo = pointx;
}
-(void) viewWillAppear:(BOOL)animated{
    _lableTitleName.text = enterpriseName;
    _lableEnterpriseName.text = enterpriseName;
    _lableEnterpriseAddress.text = enterpriseAddress;
    _lablePhone.text = enterprisePhone;
    [self loadMap];
    [super viewWillAppear:animated];
}
- (IBAction)clickCall:(id)sender {
    NSString *phone = _lablePhone.text;
    if([NSString isEnabled:phone]){
        [SerCallService call:phone];
    }
}
- (IBAction)clickwx:(id)sender {
}
- (IBAction)clickzklh:(id)sender {
}
- (IBAction)clickjbjc:(id)sender {
}
- (IBAction)clickReturn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

long long int lastMillion;
-(void) loadMap{
    CLLocationManagerImpl *cmi = [CLLocationManagerImpl getInstance];
    __weak typeof(self) tempself = self;
    [cmi setTargetMethods:^id(id key, ...) {
        va_list arglist;
        va_start(arglist, key);
        CLLocationManager *manager = va_arg(arglist, CLLocationManager*);
        CLLocation *newLocation = va_arg(arglist, CLLocation*);
        CLLocation *oldLocation = va_arg(arglist, CLLocation*);
        va_end(arglist);
        long long int lastMillionx = [[NSDate new] timeIntervalSince1970];
        if((lastMillionx - lastMillion)>5){
            lastMillion = lastMillionx;
            [tempself locationManager:manager didUpdateToLocation:newLocation fromLocation:oldLocation];
        }
        return  false;
    }];
}
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    __weak typeof(self) tempself = self;
    CLLocationCoordinate2D lc2D = newLocation.coordinate;
    float mapX = lc2D.longitude;
    float mapY = lc2D.latitude;
    NSString *tempURL = [NSString stringWithFormat:@"http://api.map.baidu.com/ag/coord/convert?from=0&to=4&x=%f&y=%f",mapX,mapY];
    NSURL *url = [NSURL URLWithString:tempURL] ;
    ASIFormDataRequest *requestx = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *request = requestx;
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *responseString = [request responseString];
        @try {
            NSDictionary *json = [responseString JSONValue];
            NSString *x = [json objectForKey:@"x"];
            NSString *y = [json objectForKey:@"y"];
            NSData * data =  [GTMBase64 decodeString:x];
            x =  [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            data  = [GTMBase64 decodeString:y];
            y =[[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
            NSString *mapURL = [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage?center=%@,%@&width=%d&height=%d&zoom=%d&markers=%@,%@&lable=%@",x,y,(int)tempself.imageMap.frame.size.width*2,(int)tempself.imageMap.frame.size.height*2,19,x,y,@"sdfsdf"];
            tempself.imageMap.isIgnoreCacheFile = YES;
            tempself.imageMap.imageUrl= mapURL;
            pointFrom = CGPointMake([x floatValue], [y floatValue]);
            NSThread *t = [[NSThread alloc] initWithTarget:tempself selector:@selector(checkDistance) object:nil];
            [t start];
        }
        @catch (NSException *exception) {
            COMMON_SHOWALERT(@"百度地图无法得到你的位置名称");
        }
    }];
    [request setFailedBlock:^{
        COMMON_SHOWALERT(@"百度地图无法得到你的位置名称");
        [tempself hideActivityIndicator];
    }];
    [self showActivityIndicator];
    [request startAsynchronous];
}
-(void) getCityNameByY:(float) y X:(float) x Index:(int) index{
    NSString *mapURL2 = [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?location=%f,%f&output=json&ak=%@",y,x,COMMON_BAIDU_AK];
    NSURL *url = [NSURL URLWithString:mapURL2] ;
    ASIFormDataRequest *requestx = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *request = requestx;
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *responseString = [request responseString];
        @try {
            NSDictionary *json = [responseString JSONValue];
            NSDictionary *jsonAddressComponent = [([(NSDictionary*)json objectForKey:@"result"]) objectForKey:@"addressComponent"];
            NSString *city = [jsonAddressComponent objectForKey:@"city"];
            switch (index) {
                case 0:
                {
                    currentCityName = city;
                }
                    break;
                case 1:
                {
                    [NSThread sleepForTimeInterval:3];
                    targetCityName = city;
                }
                    break;
                default:
                    break;
            }
            NSThread *t = [[NSThread alloc] initWithTarget:self selector:@selector(checkName) object:nil];
            [t start];
        }
        @catch (NSException *exception) {
            COMMON_SHOWALERT(@"百度地图无法得到你的位置名称");
        }
    }];
    [request setFailedBlock:^{
        COMMON_SHOWALERT(@"百度地图无法得到你的位置名称");
    }];
    [request startAsynchronous];
}
-(void) checkDistance{
    [self getCityNameByY:pointFrom.y X:pointFrom.x Index:0];
    [self getCityNameByY:pointTo.y X:pointTo.x Index:1];
}
-(void) checkName{
    @synchronized(syn01){
        if(currentCityName&&targetCityName){
            [self getDistance];
        }
    }
}
-(void) getDistance{
    NSString *currentItude = [NSString stringWithFormat:@"%f,%f",pointFrom.y,pointFrom.x];
    NSString *targetItude = [NSString stringWithFormat:@"%f,%f",pointTo.y,pointTo.x];
    __weak typeof(self) tempself = self;
    NSString *mapURL = [NSString stringWithFormat:@"http://api.map.baidu.com/direction/v1?mode=driving&origin=%@&destination=%@&origin_region=%@&destination_region=%@&output=json&ak=%@",currentItude,targetItude,currentCityName,targetCityName,COMMON_BAIDU_AK];
    //中文字符转换处理
    mapURL = [mapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:mapURL] ;
    ASIFormDataRequest *requestx = [ASIFormDataRequest requestWithURL:url];
    __weak ASIFormDataRequest *request = requestx;
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *responseString = [request responseString];
        @try {
            NSDictionary *json = [responseString JSONValue];
            NSDictionary *jsonresult = [json objectForKey:@"result"];
            NSDictionary *jsonroutes = [jsonresult objectForKey:@"routes"];
            NSArray *distance = [jsonroutes valueForKey:@"distance"];
            int templ = 0;
            for (NSNumber *n in distance) {
                templ += n.intValue;
            }
            if(templ<1000){
                tempself.lableDistance.text = [NSString stringWithFormat:@"%im",templ];
            }else{
                tempself.lableDistance.text = [NSString stringWithFormat:@"%ikm",templ/1000];
            }
        }
        @catch (NSException *exception) {
            COMMON_SHOWALERT(@"百度地图无法得到你的位置名称");
        }
        @finally {
            [tempself hideActivityIndicator];
        }
    }];
    [request setFailedBlock:^{
        COMMON_SHOWALERT(@"百度地图无法得到你的位置名称");
    }];
    [request startAsynchronous];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
