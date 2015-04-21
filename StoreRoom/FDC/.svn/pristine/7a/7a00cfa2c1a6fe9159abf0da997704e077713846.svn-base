//
//  FinanceViewController.m
//  FDC
//
//  Created by NewDoone on 15/2/26.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "FinanceViewController.h"

@interface FinanceViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)UIWebView* indexWeb;

@end

@implementation FinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView];
    // Do any additional setup after loading the view from its nib.
}
-(void)createWebView{
    CGRect frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-self.navigationController.toolbar.frameHeight-64);

    
    self.indexWeb=[[UIWebView alloc]initWithFrame:frame];
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"kuanxiang" ofType:@"html"];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *html = [NSString stringWithContentsOfFile:path encoding:enc error:nil];
    [self.indexWeb loadHTMLString:html baseURL:baseURL];

    [self.view addSubview:self.indexWeb];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:@"selectProject(record);" completionHandler:^(id ider, NSError * error) {
        
    }];
}
@end
