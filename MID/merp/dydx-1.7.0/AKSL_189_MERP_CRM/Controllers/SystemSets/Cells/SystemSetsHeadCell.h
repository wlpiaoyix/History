//
//  SystemSetsHeadCell.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-5.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
@interface SystemSetsHeadCell : UITableViewCell<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet EMAsyncImageView *imageHeads;
@property (strong, nonatomic) UIViewController *tareget;

@end
