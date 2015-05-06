//
//  UICommitFlowManager.h
//  AKSL_189_MERP_CRM
//
//  Created by wlpiaoyi on 14-2-21.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICommitFlowManager : UIScrollView<UIScrollViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
+(id) getNewInstance;
-(void) setButtonTargetHidden:(bool) flag;
-(void) excuViewThread;
-(CGSize) excuView;
-(void) addCommitEvent:(id)target Action:(SEL) action;
-(void) setController:(UIViewController*) vc;
@property (weak, nonatomic) IBOutlet UILabel *textForReportStr;
@property (weak, nonatomic) IBOutlet UILabel *textForReportStr1;
@property (weak, nonatomic) IBOutlet UILabel *textForReportStr0;

@end
