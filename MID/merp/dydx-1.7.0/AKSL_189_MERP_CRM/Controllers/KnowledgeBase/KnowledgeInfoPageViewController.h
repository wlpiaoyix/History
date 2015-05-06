//
//  KnowledgeInfoPageViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-16.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"

@interface KnowledgeInfoPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UILabel *textTitle;
@property (weak, nonatomic) IBOutlet UILabel *textDate;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *imageContent;
@property (weak, nonatomic) IBOutlet UILabel *textConent;

@property (strong,nonatomic) NSDictionary * data;
@end
