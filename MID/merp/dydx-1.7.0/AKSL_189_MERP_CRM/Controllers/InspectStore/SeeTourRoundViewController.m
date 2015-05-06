//
//  SeeTourRoundViewController.m
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-30.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import "SeeTourRoundViewController.h"
#import "UIScrollViewScanShowOpt.h"
#import "InspectStoreViewController.h"

@interface SeeTourRoundViewController ()
{
    NSDictionary *dic;
    UIScrollViewScanShowOpt *scanshow;
    int currentIndexJsonData;
}

@end

@implementation SeeTourRoundViewController

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
    currentIndexJsonData = 0;
    [self setCornerRadiusAndBorder:self.dianzanView];
    scanshow = [[UIScrollViewScanShowOpt alloc] init];
    [scanshow _setRects:CGRectMake(0, 0, COMMON_SCREEN_W, COMMON_SCREEN_H-90)];
    scanshow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSMutableArray *datas = [[NSMutableArray alloc] init];
    for(int i = 0 ;i<[[dic objectForKey:@"listAttamentUrl"] count];i++)
    {
        NSString *json = API_IMAGE_URL_GET2([[dic objectForKey:@"listAttamentUrl"] objectAtIndex:i]);
        [datas addObject:json];
    }
    
    [scanshow setViewURL:datas];			
    [scanshow setIndex:currentIndexJsonData];
    [self.imgsMain addSubview:scanshow];
    [self setContnt];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
-(void)setdata:(NSDictionary *)dataDic
{
    dic = dataDic;
}
-(void)setContnt
{
    NSDate *date = [NSDate dateFormateString:[dic objectForKey:@"checkTime"] FormatePattern:nil];
    self.lblTitle.text = [date getFriendlyTime:YES];
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:13];
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [[dic objectForKey:@"checkContents"] sizeWithFont:font constrainedToSize:size];
    if (labelsize.height>36) {
        CGRect farmes = self.lblCheckContents.frame;
        farmes.origin.y -= labelsize.height + 16 - farmes.size.height;
        farmes.size.height = labelsize.height + 16;
        self.lblCheckContents.frame = farmes;
    }

    self.lblCheckContents.text = [dic objectForKey:@"checkContents"];
    self.lblCheckLocation.text = [dic objectForKey:@"checkLocation"];
    self.lblComment.text = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"comment"] count]];
    self.lblLikes.text = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"likes"] count]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toInfoPage:(id)sender {
    InspectStoreViewController * inspect = [[InspectStoreViewController alloc]initWithNibName:@"InspectStoreViewController" bundle:nil];
    inspect.isQueryRest = YES;
    inspect.isSingeInfo = YES;
    inspect.QueryInspectId = [[dic valueForKey:@"id"]longValue];
    [self.navigationController pushViewController:inspect animated:YES];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
