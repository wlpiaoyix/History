//
//  SystemSetsCellsUserInfoController.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-28.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "BaseViewController.h"
#import "SystemSetsUserInfoCell.h"
@interface SystemSetsCellsUserInfoController : BaseViewController
@property (strong, nonatomic) SystemSetsUserInfoCell *target;
@property (retain, nonatomic) UIView *viewBottom;
@property (strong, nonatomic) IBOutlet UILabel *lableParam;
@property (strong, nonatomic) IBOutlet UIView *viewValues;
@property (strong, nonatomic) IBOutlet UITextField *textFieldValues;
@property int flag;
@property (strong, nonatomic) NSString *_titles;
@property (strong, nonatomic) NSString *_param;
@property (strong, nonatomic) NSString *_values;

@end
