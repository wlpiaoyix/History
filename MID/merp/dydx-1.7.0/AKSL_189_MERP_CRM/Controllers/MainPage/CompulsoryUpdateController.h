//
//  CompulsoryUpdateController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-Apple on 14/6/28.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CompulsoryUpdateController : BaseViewController

@property (weak,nonatomic) IBOutlet UIButton * goBackBut;
@property (weak,nonatomic) IBOutlet UILabel * textForNote;
@property (weak,nonatomic) IBOutlet UIButton * goupdateBut;

@property (strong,nonatomic) NSString * noteString;
@property (assign) int updateType;

@end
