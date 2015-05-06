//
//  FeedbackViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-5-13.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface FeedbackViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *textContent;
- (IBAction)back:(id)sender;
- (IBAction)Submit:(id)sender;

@end
