//
//  CommitDataViewController.h
//  AKSL-189-Msp
//
//  Created by AKSL-td on 13-11-18.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface CommitDataViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *textForsms;
@property (assign,nonatomic) bool isTableData;
@property (strong,nonatomic) NSDictionary * selectDic;
@end
