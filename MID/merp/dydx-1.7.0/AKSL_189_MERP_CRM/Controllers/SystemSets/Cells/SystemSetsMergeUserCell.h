//
//  SystemSetsMergeUserCell.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-26.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
@interface SystemSetsMergeUserCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lableUserCode;
@property (strong, nonatomic) IBOutlet EMAsyncImageView *imageUserHead;
@property (strong, nonatomic) IBOutlet UILabel *lableIfEditPhoto;
@property (strong, nonatomic) IBOutlet UIView *viewUserName;
@property (strong, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (strong, nonatomic) IBOutlet UIView *viewUserPhone;
@property (strong, nonatomic) IBOutlet UITextField *textFieldUserPhone;
@property (strong, nonatomic) IBOutlet UIView *viewUserSex;
@property (strong, nonatomic) IBOutlet UILabel *lableUserSex;
@property (strong, nonatomic) IBOutlet UIView *viewPost;
@property (strong, nonatomic) IBOutlet UILabel *lablePost;
@property (strong, nonatomic) IBOutlet UIView *viewLocation;
@property (strong, nonatomic) IBOutlet UILabel *lableLocation;

@end
