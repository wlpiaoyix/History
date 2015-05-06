//
//  NotesAddViewController.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-7.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMAsyncImageView.h"
#import "BaseViewController.h"
@interface NotesAddViewController : BaseViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIScrollViewDelegate/*UIAlertViewDelegate*/,UITextViewDelegate,UIActionSheetDelegate>
@property (retain, nonatomic) NSDictionary *jsonData;//部门信息
@property (retain, nonatomic) IBOutlet UIView *viewLocations;
@property (retain, nonatomic) IBOutlet UIButton *buttonBack;
@property (retain, nonatomic) IBOutlet UIView *viewHead;
@property (retain, nonatomic) IBOutlet UIView *viewAddImage;
@property (retain, nonatomic) IBOutlet UIView *viewAddress;
@property (strong, nonatomic) IBOutlet UIScrollView *srcollViewmain;
@property (strong, nonatomic) IBOutlet UILabel *lableTag1;
@property (retain, nonatomic) IBOutlet UITextView *textViewIntroduce;
@property (strong, nonatomic) IBOutlet UIButton *buttonUpload;
@property (retain, nonatomic) IBOutlet UIView *viewMap;
@property (retain, nonatomic) IBOutlet EMAsyncImageView *imageMap;
@property (retain, nonatomic) IBOutlet UILabel *lableMap;
@property double mapX;
@property double mapY;
@property (retain, nonatomic) NSString *myName;
-(NSMutableArray*) imageViews;

@end
