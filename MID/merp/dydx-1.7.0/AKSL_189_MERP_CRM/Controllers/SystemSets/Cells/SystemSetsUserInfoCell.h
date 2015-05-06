//
//  SystemSetsUserInfoCell.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-5.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface SystemSetsUserInfoCell : UITableViewCell<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (retain, nonatomic) BaseViewController *target;
@property (strong, nonatomic) IBOutlet UILabel *lableText;
@property (strong, nonatomic) IBOutlet UILabel *lableValue;
@property (strong, nonatomic) IBOutlet UIButton *buttonTo;

@end
