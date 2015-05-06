//
//  NotesImageViewController.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-15.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "NotesImageViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "UIScrollViewScanShowOpt.h"
//#import "EMAsyncImageView.h"
//static int NIVBASETAG1 = 1800;
//static int NIVBASETAG2 = 1900;
@interface NotesImageViewController ()
//@property (strong, nonatomic) UISwipeGestureRecognizer *left;
//@property (strong, nonatomic) UISwipeGestureRecognizer *right;
@property (strong, nonatomic) NSMutableDictionary *jsonData;
@property int currentIndexJsonData;
@property (strong, nonatomic) UIScrollViewScanShowOpt *svss;
//@property int tagView;
//@property int tagImage;
@end

@implementation NotesImageViewController
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
//    self.left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toRight)];
//    self.right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toLeft)];
//    self.left.direction = UISwipeGestureRecognizerDirectionLeft;
//    self.right.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.view addGestureRecognizer:self.left];
//    [self.view addGestureRecognizer:self.right];
    self.svss = [[UIScrollViewScanShowOpt alloc]init];
    [self.svss _setRects:CGRectMake(0, 42, COMMON_SCREEN_W, COMMON_SCREEN_H-42)];
    [self.svss setIndex:self.currentIndexJsonData];
    //    [self.scrollView setViewImages:data];
    [self.view addSubview:self.svss];
    self.lableImageInfo.lineBreakMode = UILineBreakModeWordWrap;
    self.lableImageInfo.numberOfLines = 0;
    [self.lableImageInfo removeFromSuperview];
    [self.viewImageInfo removeFromSuperview];
    if(self.title)self.lableTitle.text = self.title;

}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    id imageURL;
    id imageView;
    NSString *imageInfo;
    if(self.jsonData &&self.jsonData!=nil){
        imageURL = [(NSDictionary*)((NSArray*)[self.jsonData objectForKey:@"data"])[self.currentIndexJsonData] objectForKey:@"imageURL"];
        imageInfo = [self.jsonData objectForKey:@"imageInfo"];
        imageView = [(NSDictionary*)((NSArray*)[self.jsonData objectForKey:@"data"])[self.currentIndexJsonData] objectForKey:@"imageView"];
    }
    if(imageView){
        NSMutableArray *datas = [[NSMutableArray alloc]init];
        for (NSDictionary *json in (NSArray*)[self.jsonData objectForKey:@"data"]) {
            [datas addObject:[json objectForKey:@"imageView"]];
        }
        [self.svss setViewImages:datas];
//        [self checkView:imageView];
    }else{
        NSMutableArray *datas = [[NSMutableArray alloc]init];
        for (NSDictionary *json in (NSArray*)[self.jsonData objectForKey:@"data"]) {
            [datas addObject:[json objectForKey:@"imageURL"]];
        }
        [self.svss setViewURL:datas];
//        [self checkURL:imageURL];
    }
    [self.lableImageInfo removeFromSuperview];
    [self.viewImageInfo removeFromSuperview];
    UIFont *font = [UIFont systemFontOfSize:15];
    self.lableImageInfo.font = font;
    CGSize size=[self.lableImageInfo.text sizeWithFont:font constrainedToSize:CGSizeMake(self.lableImageInfo.frame.size.width, 1000)];
    CGRect r2 = self.lableImageInfo.frame;
    r2.size.height = size.height;
    r2.origin.y =  8;
    r2.origin.x = 0;
    self.lableImageInfo.frame = r2;
    CGRect r1 = self.viewImageInfo.frame;
    r1.origin.y = self.view.frame.size.height-size.height-18;
    r1.size.height = size.height+18;
    self.viewImageInfo.frame = r1;
    
    if(imageInfo){
        self.lableImageInfo.text = imageInfo;//?imageInfo:@"我晕哦不对呢我晕哦不对呢我晕哦不对呢我晕哦不对呢我晕哦不对呢我晕哦不对呢我晕哦不对呢我晕哦不对呢我晕哦不对呢我晕哦不对呢我晕哦不对呢我晕哦不对呢我晕哦不对呢我晕哦不对呢asdadsasdasdasdasd";
        [self.view addSubview:self.viewImageInfo];
        [self.viewImageInfo addSubview:self.lableImageInfo];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-(void) checkURL:(NSString*) imageURL{
//    [self.viewHD addSubview:[self imageURL:imageURL orgX:320]];
//    [self.viewHD addSubview:[self imageURL:imageURL orgX:0]];
//}
//-(void) checkView:(UIImage*) imageView{
//    
//    [self.viewHD addSubview:[self imageView:imageView orgX:320]];
//    [self.viewHD addSubview:[self imageView:imageView  orgX:0]];
//}
//-(UIView*) imageView:(UIImage*) imageView orgX:(int) orgX{
//    int index1;
//    UIView *u;
//    if(self.tagView==0){
//        u = self.viewCheck;
//        self.tagView = 1;
//        index1 = 1801;
//        self.tagImage = NIVBASETAG1;
//    }else{
//        u = self.viewCheck2;
//        self.tagView =0;
//        index1 = 1901;
//        self.tagImage = NIVBASETAG2;
//    }
//    
//    u.tag = self.tagImage;
//    CGRect r = [[UIScreen mainScreen] applicationFrame];
//    r.size.height -= 44;
//    r.origin.y = 0;
//    if(orgX!=0)r.origin.x = orgX;
//    u.frame = r;
//    
//    EMAsyncImageView *imageNotes = (EMAsyncImageView*)[u viewWithTag:index1];
//    
//    UIView *ux = [u viewWithTag:index1+1];
//    if(imageView!=nil){
//        [ux setHidden:YES];
//        imageNotes.image = imageView;
//    }else{
//        [ux setHidden:NO];
//    }
//    imageNotes.layer.cornerRadius = 0.0f;
//    return u;
//}
//-(UIView*) imageURL:(NSString*) imageURL orgX:(int) orgX{
//    int index1;
//    UIView *u;
//    if(self.tagView==0){
//        u = self.viewCheck;
//        self.tagView = 1;
//        index1 = 1801;
//        self.tagImage = NIVBASETAG1;
//    }else{
//        u = self.viewCheck2;
//        self.tagView =0;
//        index1 = 1901;
//        self.tagImage = NIVBASETAG2;
//    }
//    u.tag = self.tagImage;
//    CGRect r = [[UIScreen mainScreen] applicationFrame];
//    r.size.height -= 44;
//    r.origin.y = 0;
//    if(orgX!=0)r.origin.x = orgX;
//    u.frame = r;
//    
//    EMAsyncImageView *imageNotes = (EMAsyncImageView*)[u viewWithTag:index1];
//    UIView *ux = [u viewWithTag:index1+1];
//    if(imageURL!=nil){
//        [ux setHidden:YES];
//        imageNotes.imageUrl=nil;
//        imageNotes.imageUrl=imageURL;
//    }else{
//        [ux setHidden:YES];
//    }
//    imageNotes.layer.cornerRadius = 0.0f;
//    return u;
//}
//-(id) checkImageData:(NSDictionary*) json OrgX:(int) orgx{
//    id u;
//    if(!json){
//        u = [self imageURL:nil orgX:orgx];
//        return u;
//    }
//    NSString *imageURL = [json objectForKey:@"imageURL"];
//    UIImage *imageView = [json objectForKey:@"imageView"];
//    if(imageURL){
//        u = [self imageURL:imageURL orgX:orgx];
//    }else if(imageView){
//        u = [self imageView:imageView orgX:orgx];
//    }else{
//        u = [self imageURL:nil orgX:orgx];
//    }
//    return u;
//}
//
//-(void) toRight{
//    //==>读取下一条数据，如果是最后一条则返回
//    NSDictionary *json;
//    if(self.jsonData){
//        NSArray *jsonArray = [self.jsonData objectForKey:@"data"];
//        if([jsonArray count]<self.currentIndexJsonData+2){
////            showMessageBox(@"已是最后一张！");
//            return;
//        }
//        ++self.currentIndexJsonData;
//        json = jsonArray[self.currentIndexJsonData];
//    }
//    //<==
//    [UIView animateWithDuration:0.3 animations:^{
//        UIView *u = [self.view viewWithTag:self.tagImage];
//        CGRect r = u.frame;
//        r.origin.x = 0-r.size.width;
//        u.frame = r;
//        UIView *u2 = [self checkImageData:json OrgX:320];
//        CGRect r2 = u2.frame;
//        r2.origin.x = (320.0-r2.size.width)/2;
//        u2.frame = r2;
//        
//    }];
//}
//-(void) toLeft{
//    //==>读取下一条数据，如果是最后一条则返回
//    NSDictionary *json;
//    if(self.jsonData){
//        NSArray *jsonArray = [self.jsonData objectForKey:@"data"];
//        if(self.currentIndexJsonData-1<0){
////            showMessageBox(@"已是第一张！");
//            return;
//        }
//        --self.currentIndexJsonData;
//        json = jsonArray[self.currentIndexJsonData];
//    }
//    //<==
//    [UIView animateWithDuration:0.3 animations:^{
//        UIView *u = [self.view viewWithTag:self.tagImage];
//        CGRect r = u.frame;
//        r.origin.x = r.size.width;
//        u.frame = r;
//        UIView *u2 = [self checkImageData:json OrgX:-320];
//        CGRect r2 = u2.frame;
//        r2.origin.x = (320.0-r2.size.width)/2;
//        u2.frame = r2;
//        
//    }];
//}
- (IBAction)buttonReturn:(id)sender {
//    if(self.tagView==0){
//        [self.viewCheck removeFromSuperview];
//    }else{
//        [self.viewCheck2 removeFromSuperview];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
