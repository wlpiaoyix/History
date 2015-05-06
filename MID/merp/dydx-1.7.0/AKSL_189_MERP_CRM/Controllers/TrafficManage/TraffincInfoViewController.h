//
//  TraffincInfoViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-4-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DAPagesContainer.h"

@interface TraffincInfoViewController : BaseViewController<DAPagesContainerDelegate>
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (assign) int type;
 
@end
