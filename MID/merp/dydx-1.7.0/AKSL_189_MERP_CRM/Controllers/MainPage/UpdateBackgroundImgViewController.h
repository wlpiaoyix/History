//
//  UpdateBackgroundImgViewController.h
//  AKSL_189_MERP_CRM
//
//  Created by zhouli on 14-6-16.
//  Copyright (c) 2014年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^RetureMethod)(NSString *bgImg);
@interface UpdateBackgroundImgViewController : UIViewController<UIGestureRecognizerDelegate>
{
    RetureMethod _returnMethod;
}
-(void) setRetureMethods:(RetureMethod) returnMethod;
@end
