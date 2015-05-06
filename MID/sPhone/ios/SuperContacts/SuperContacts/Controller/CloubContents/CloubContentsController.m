//
//  CloubContentsController.m
//  SuperContacts
//
//  Created by wlpiaoyi on 14-2-5.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "CloubContentsController.h"
#import "ParsetVcardAndEntity.h"
#import "SABFromLocationContentService.h"
#import "ASIFormDataRequest.h"
#import "HttpApiCall.h"
#import "ParsetVcardAndEntity.h"
#import "CTM_MainController.h"
#import "CTM_RightController.h"
@interface CloubContentsController (){
@private int numLocation;//本地通信录数据量
@private int numCloub;//云端通信录数据量
    bool flagCopy;
    bool flagRest;
    //==>下载文件参数
    id	 sync;
    NSURLConnection	*connection;
    bool finished;
    NSMutableData *datas;
}
@property (strong, nonatomic) IBOutlet UILabel *lableLocation;
@property (strong, nonatomic) IBOutlet UILabel *lableCloub;
@end

@implementation CloubContentsController
+(id) getNewleInstance{
    return [[CloubContentsController alloc]initWithNibName:@"CloubContentsController" bundle:nil];
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
    datas = [NSMutableData new];
    [self reloadTagInfo];
    [super viewDidLoad];
}
- (IBAction)clickMain:(id)sender {
    [super topLeftOrRight:ENUM_BVCLEFT];
}
- (IBAction)clickCopy:(id)sender {
    if(flagCopy){
        COMMON_SHOWALERT(@"已备份!");
        return;
    }
    SABFromLocationContentService *flcs = COMMON_FLCS;
    NSArray *array = [flcs queryByName:nil];
    NSString *info = [ParsetVcardAndEntity parseEntityToVcard:array];
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    NSString *path = [[ConfigManage getTempDirectory] stringByAppendingString:@"/temp.vcf"];
    NSFileManager *f = [NSFileManager defaultManager];
    if([f fileExistsAtPath:path]){
        [f removeItemAtPath:path error:NULL];
    }
    [data writeToFile:path atomically:YES];
//    NSFileHandle *fileHandle=[NSFileHandle fileHandleForUpdatingAtPath:path];//追加数据
//    [fileHandle seekToEndOfFile]; //跳到文件末尾
//    [fileHandle writeData:data]; //写入
//    [fileHandle closeFile]; //关闭写入流
//    data = [NSData dataWithContentsOfFile:path];
    [self uploadFile:path];
}

- (IBAction)clickRest:(id)sender {
    if (flagRest) {
        COMMON_SHOWALERT(@"已同步同信录!");
        return;
    }
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:@"/cloud/backup" Params:nil Logo:@"copyRecord"];
    __weak typeof(requestx) request = requestx;
    __weak typeof(self) tempself = self;
    [request setCompletionBlock:^{
        @try {
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *result = [request responseString];
            if(![NSString isEnabled:result]){
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"数据返回了一个空!" userInfo:nil];
            }
            NSArray *json = [result JSONValue];
            if([json count]){
                NSDictionary *jsonx = [json valueForKey:@"data"];
                NSString  *userContactUrl = [jsonx valueForKey:@"userContactUrl"];
                userContactUrl = COMMON_GET_IMAGE_URL(userContactUrl);
                [tempself downloadFile:userContactUrl];
            }else{
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"数据返回了一个空!" userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            COMMON_SHOWALERT(exception.reason);
            [tempself hideActivityIndicator];
        }
        @finally {
        }
    }];
    [request setFailedBlock:^{
        [tempself hideActivityIndicator];
    }];
    [self showActivityIndicator];
    [request startAsynchronous];
    
}


-(void) uploadFile:(NSString*) path{//:(NSData*) data{//
    ASIFormDataRequest *requestx = [HttpApiCall requestCallUpload:@"/upload" Params:nil Logo:@"uploadFile" OutTime:60];
    [requestx setFile:path forKey:[NSString stringWithFormat:@"fileName%d",1]];
//    [requestx setData:data withFileName:@"temp.vcf"andContentType:nil forKey:[NSString stringWithFormat:@"fileName%d",1]];
//    [requestx setData:data forKey:[NSString stringWithFormat:@"fileName%d",1]];
    __weak typeof(requestx) request = requestx;
    __weak typeof(self) tempself = self;
    [request setCompletionBlock:^{
        @try {
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *result = [request responseString];
            if(![NSString isEnabled:result]){
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"数据返回了一个空!" userInfo:nil];
            }
            NSArray *json = [result JSONValue];
            if([json count]){
                NSArray *temp = [json[0] componentsSeparatedByString:@"/"];
                [tempself saveUploadFile:temp[1]];
            }else{
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"数据返回了一个空!" userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            COMMON_SHOWALERT(exception.reason);
            [tempself hideActivityIndicator];
        }
    }];
    [request setFailedBlock:^{
        [tempself hideActivityIndicator];
    }];
    [self showActivityIndicator];
    [request startAsynchronous];
}
-(void) saveUploadFile:(NSString*) fileName{
    ModleUser *user = [ConfigManage getCurrentUser];
    NSDictionary *json = [[NSMutableDictionary alloc]init];
    [json setValue:[[NSNumber alloc] initWithInt:1] forKey:@"status"];
    [json setValue:fileName forKey:@"attachName"];
    [json setValue:[NSString stringWithFormat:@"%@/%@",user.phoneNum,fileName] forKey:@"attachUrl"];
    ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/attachments" Params:json Logo:@"file_save"];
    __weak ASIFormDataRequest *request = requestx;
    __weak typeof(self) tempself = self;
    [request setCompletionBlock:^{
        @try {
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *responseString = [request responseString];
            NSDictionary *json = [responseString JSONValue];
            if(!json){
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"无效json数据" userInfo:nil];
            }
            COMMON_SHOWALERT(@"操作成功！");
            [self reloadTagInfo];
            flagCopy = true;
            [tempself hideActivityIndicator];
//            NSString *docPath = [self getDocPath];
//            if([[NSFileManager defaultManager] fileExistsAtPath:docPath]){
//                [[NSFileManager defaultManager] removeItemAtPath:docPath error:NULL];
//            }
//            user.defaultPicUrl = [json valueForKey:@"attachUrl"];
        }
        @catch (NSException *exception) {
            COMMON_SHOWALERT(@"操作失败！");
            [tempself hideActivityIndicator];
        }
        @finally {
            [tempself hideActivityIndicator];
        }
    }];
    [request setFailedBlock:^{
        COMMON_SHOWALERT(@"网络没有回应！");
        [self hideActivityIndicator];
    }];
    [request startAsynchronous];
}
-(void) reloadTagInfo{
    NSString *copyTime = [ConfigManage getConfigCache:@"copy"];
    _lableLocation.text = [NSString isEnabled:copyTime]?copyTime:@"未知";
    
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:@"/cloud/backup" Params:nil Logo:@"copyRecord"];
    __weak typeof(requestx) request = requestx;
    __weak typeof(self) tempself = self;
    [request setCompletionBlock:^{
        @try {
            [request setResponseEncoding:NSUTF8StringEncoding];
            NSString *result = [request responseString];
            if(![NSString isEnabled:result]){
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"数据返回了一个空!" userInfo:nil];
            }
            NSArray *json = [result JSONValue];
            if([json count]){
                NSDictionary *jsonx = [json valueForKey:@"data"];
                NSString  *date = [jsonx valueForKey:@"date"];
                tempself.lableCloub.text = date;
            }else{
                @throw [[NSException alloc] initWithName:@"空异常" reason:@"数据返回了一个空!" userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            COMMON_SHOWALERT(exception.reason);
        }
        @finally {
        }
    }];
    [request setFailedBlock:^{
    }];
    [request startAsynchronous];
}

-(void) downloadFile:(NSString*) fileUrl{
	NSURL *url = [NSURL URLWithString:fileUrl];
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    if(connection){
        [connection cancel];
    }
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    finished = NO;
    while (!finished) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    @synchronized(sync){
        if (!datas) datas = [NSMutableData data];
        [datas appendData:incrementalData];
    }
}
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    finished = YES;
    COMMON_SHOWMSGDELEGATE(@"确定要恢复当前通信录吗?", self, @"是",@"否",nil);
    [self hideActivityIndicator];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    SABFromLocationContentService *flcs = COMMON_FLCS;
    
    switch (buttonIndex) {
        case 0:
        {
            NSArray *users = [flcs queryByName:nil];
            for (EntityUser *user in users) {
                [flcs remove:user];
            }
            NSString* aStr = [[NSString alloc] initWithData:datas encoding:NSUTF8StringEncoding];
            users =  [ParsetVcardAndEntity parseVcardToEntity:aStr];
            for (EntityUser *user in users) {
                [flcs merge:user];
            }
            [[CTM_RightController getSingleInstance] refreshData];
            [[CTM_MainController getSingleInstance] refreshRecord];
            [ConfigManage setConfigCache:@"copy" Value:[NSString stringWithFormat:@"%@",[[NSDate new] dateFormateDate:@"yyyy-MM-dd"]]];
            _lableLocation.text = [ConfigManage getConfigCache:@"copy"];
            flagRest = true;
        }
            break;
        case 1:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    finished = YES;
    [self hideActivityIndicator];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
