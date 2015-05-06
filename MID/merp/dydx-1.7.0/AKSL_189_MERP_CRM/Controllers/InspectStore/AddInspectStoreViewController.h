//
//  AddInspectStoreViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by AKSL-td on 14-1-17.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
#import "BaseViewController.h"

@interface AddInspectStoreViewController : BaseViewController<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIView *OpView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *textUserName;
@property (weak, nonatomic) IBOutlet UILabel *textDate;
@property (weak, nonatomic) IBOutlet UITextView *textContent;
@property (weak, nonatomic) IBOutlet UIView *ImageAllVIew;
@property (weak, nonatomic) IBOutlet UIButton *textType;
@property (weak, nonatomic) IBOutlet UIButton *textTingdian;
@property (weak, nonatomic) IBOutlet EMAsyncImageView *ImageMap;
@property (weak, nonatomic) IBOutlet UIButton *textAddr;
@property (weak, nonatomic) IBOutlet UIView *viewName;
- (IBAction)ImageButtonClick:(id)sender;
- (IBAction)ImageButtonDown:(id)sender;
- (IBAction)ImageButtonUpOut:(id)sender;
@end
