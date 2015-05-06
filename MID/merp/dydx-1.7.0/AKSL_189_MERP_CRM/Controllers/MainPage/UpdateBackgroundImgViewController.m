//
//  UpdateBackgroundImgViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-6-16.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "UpdateBackgroundImgViewController.h"
#import "HttpApiCall.h"
#import "EMAsyncImageView.h"

@interface UpdateBackgroundImgViewController ()
{
    NSArray *bgArray;
}

@end

@implementation UpdateBackgroundImgViewController

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
    // Do any additional setup after loading the view from its nib.

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setData];
}
-(void)imgVeiw:(NSArray *)temp
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-50)];
    scroll.contentSize = CGSizeMake(320, 100*temp.count);
    for (int i =0; i<temp.count; i++) {
        EMAsyncImageView *imgView = [[EMAsyncImageView alloc] initWithFrame:CGRectMake(10, 10+i*100, 300, 90)];
        imgView.imageUrl = API_IMAGE_URL_GET2([temp[i] objectForKey:@"url"]);
        imgView.tag = [[temp[i] objectForKey:@"id"] integerValue];
         [imgView setContentMode:UIViewContentModeScaleAspectFill];
        [scroll addSubview:imgView];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10+i*100, 320, 90)];
        view.backgroundColor = [UIColor clearColor];
        view.tag = i+100000;
        UITapGestureRecognizer *tp=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPre:)];
        tp.numberOfTapsRequired = 1;
        [view addGestureRecognizer:tp];
        [scroll addSubview:view];
        
    }
    [self.view addSubview:scroll];
}
-(void)handleLongPre:(UITapGestureRecognizer *)ges
{
    
    NSString *bgString = [[bgArray objectAtIndex:ges.view.tag-100000] objectForKey:@"url"];
    int _id = [[[bgArray objectAtIndex:ges.view.tag -100000] objectForKey:@"id"] intValue];
    NSMutableDictionary *postDic = [NSMutableDictionary new];
    [postDic setObject:[NSNumber numberWithInt:_id] forKey:@"id"];
    [postDic setObject:bgString forKey:@"url"];
   // NSString *string= [postDic JSONRepresentation];
    __weak ASIFormDataRequest *requestx = [HttpApiCall requestCallPOST:@"/api/user/profile/bg" Params:postDic Logo:@"update_bg"];
    [requestx setCompletionBlock:^{
        [requestx setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [requestx responseString];
        NSDictionary *dic = [reArg JSONValueNewMy];
        if (!dic) {
            return;
        }
        _returnMethod(bgString);
    }];
    [requestx setFailedBlock:^{
        showMessageBox(@"修改失败");
    }];
    [requestx startSynchronous];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setData
{
    NSString * url= @"/api/attachments/profilebgs";
    ASIFormDataRequest *requestx = [HttpApiCall requestCallGET:url Params:nil Logo:@"get_userBackground"];
    __weak ASIFormDataRequest *request = requestx;
    [request setCompletionBlock:^{
        [request setResponseEncoding:NSUTF8StringEncoding];
        NSString *reArg = [request responseString];
        @try {
            NSDictionary *dic = [reArg JSONValueNewMy];
            if (dic == nil) {
                showMessageBox(@"暂无数据");
                return;
            }
            NSArray *imgArray = [dic objectForKey:@"bgs"];
            bgArray = imgArray;
            [self imgVeiw:imgArray];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }];
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];
    
}
-(void) setRetureMethods:(RetureMethod) returnMethod{
    _returnMethod = returnMethod;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
