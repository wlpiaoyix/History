//
//  AddKnowledgeViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zuxia on 14-3-24.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface AddKnowledgeViewController : BaseViewController<UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *imgView;

@property (weak, nonatomic) IBOutlet UITextView *textContent;

@property (weak, nonatomic) IBOutlet UITextField *textTitle;

//@property (weak, nonatomic) IBOutlet UIView *openView;

@property (weak, nonatomic) IBOutlet UIButton *typeId;
@property (weak, nonatomic) IBOutlet UIView *views;

- (IBAction)addImgs:(id)sender;

- (IBAction)imgDown:(id)sender;
- (IBAction)imgUpOut:(id)sender;

- (IBAction)back:(id)sender;
- (IBAction)add:(id)sender;
- (IBAction)typeId:(id)sender;

@end
