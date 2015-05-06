//
//  SeeTourRoundViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-30.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SeeTourRoundViewController : BaseViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *imgsMain;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UILabel *lblCheckContents;

@property (weak, nonatomic) IBOutlet UILabel *lblCheckLocation;

@property (weak, nonatomic) IBOutlet UILabel *lblComment;
@property (weak, nonatomic) IBOutlet UILabel *lblLikes;
@property (weak, nonatomic) IBOutlet UIView *dianzanView;

-(void)setdata:(NSDictionary *)dataDic;
@end
