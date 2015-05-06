//
//  AKUIWebViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-26.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface AKUIWebViewController : BaseViewController<UIWebViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *WebVIew;
@property (weak, nonatomic) IBOutlet UILabel *TitleName;
@property (strong,nonatomic) NSString * url;
@property (strong,nonatomic) NSString * imageUrl;
@property (strong,nonatomic) NSString * imgURL;
@property (assign) int gesState;
@property (strong,nonatomic) NSTimer * timer;
@end
